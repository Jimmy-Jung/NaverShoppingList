//
//  NSLikedViewController.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit
import RealmSwift

// 즐겨찾기 뷰 컨트롤러 클래스 정의
class NSLikedViewController: UIViewController {
    
    private let mainView = NSSearchView()
    private let realm = RealmManager.createRealm(path: .favorite)
    /// 즐겨찾기 데이터가 변경될 때마다 결과 CollectionView 리로드
    private var realmShoppingResult: Results<RealmShoppingData>! {
        didSet {
            mainView.resultsCollectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBackBarButton(title: title) // 뒤로가기 버튼 추가
        fetchShoppingData() // 즐겨찾기 데이터 가져오기
        configurationView() // UI 설정
        setConstraints() // 제약조건 설정
        configurationDelegate() // Delegate 설정
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.resultsCollectionView.reloadData()
    }
    
    /// 즐겨찾기 데이터 가져오는 메소드
    private func fetchShoppingData() {
        realmShoppingResult = realm.objects(RealmShoppingData.self).sorted(byKeyPath: "storedDate", ascending: false)
    }
    
    /// UI 설정 메소드
    private func configurationView() {
        view.backgroundColor(.systemBackground)
        view.addSubview(mainView)
        mainView.sortButtonCollectionView.isHidden(true)
        mainView.resultsCollectionView.register(NSResultCollectionViewCell.self, forCellWithReuseIdentifier: NSResultCollectionViewCell.identifier)
    }
    
    /// 제약조건 설정 메소드
    private func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    /// Delegate 설정 메소드
    private func configurationDelegate() {
        mainView.searchBar.delegate = self
        mainView.resultsCollectionView.delegate = self
        mainView.resultsCollectionView.dataSource = self
    }
}

extension NSLikedViewController: UISearchBarDelegate {
    /// 검색 버튼 클릭 시 키보드 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    /// 취소 버튼 클릭 시 키보드 내리고 리스트 초기화
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        realmShoppingResult = realm.objects(RealmShoppingData.self)
    }
    
    /// 검색어가 변경될 때마다 호출되는 메소드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 검색어가 있을 경우 검색어로 필터링하여 결과 CollectionView에 보여줌
        if !searchText.isEmpty {
            searchTerm(term: searchText)
        } else {
            // 검색어가 없을 경우 즐겨찾기 데이터 전체를 보여줌
            realmShoppingResult = realm.objects(RealmShoppingData.self)
        }
    }
    
    /// 검색어 입력이 종료될 때 검색어로 필터링하여 결과 CollectionView에 보여줌
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let term = searchBar.text, !term.isEmpty else { return }
        searchTerm(term: term)
    }
    
    /// 검색어로 필터링하여 결과 CollectionView에 보여주는 메소드
    private func searchTerm(term: String) {
        let realmShoppingData = realm.objects(RealmShoppingData.self)
        realmShoppingResult = realmShoppingData.where {
            $0.title.contains(term)
        }
    }
}

// MARK: - Delegate & DataSource

extension NSLikedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// 섹션의 아이템 개수를 반환하는 메서드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realmShoppingResult.count
    }
    
    /// 셀을 구성하는 메서드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSResultCollectionViewCell.identifier, for: indexPath) as! NSResultCollectionViewCell
        
        cell.shoppingData = ShoppingData(from: realmShoppingResult[indexPath.item])
        
        // 셀의 하트 버튼 태그와 액션 설정
        cell.heartButton.tag = indexPath.item
        cell.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    /// 셀을 선택했을 때 호출되는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 셀의 ShoppingData 모델을 이용하여 NSDetailViewController로 이동
        let shoppingData = ShoppingData.init(from: realmShoppingResult[indexPath.item])
        transition(viewController: NSDetailViewController(), style: .pushNavigation) { vc in
            vc.shoppingData = shoppingData
            vc.title = shoppingData.title.htmlToString
        }
    }
    
    /// 셀 내 하트 버튼을 탭했을 때 호출되는 메서드
    @objc func heartButtonTapped(_ sender: UIButton) {
        // 하트 버튼이 위치한 셀의 위치를 이용하여 즐겨찾기 데이터에서 해당 데이터 삭제
        let task = realmShoppingResult[sender.tag]
        try! realm.write {
            realm.delete(task)
        }
        // 즐겨찾기 데이터가 변경되었으므로 결과 CollectionView를 리로드
        mainView.resultsCollectionView.reloadData()
    }
}


