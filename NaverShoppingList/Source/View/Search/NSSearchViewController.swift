//
//  ViewController.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import UIKit
import RealmSwift

final class NSSearchViewController: UIViewController {
    typealias SortType = NaverShoppingEndPoint.Sort
    
    // MARK: - Properties
    
    private let realm = RealmManager.createRealm(path: .favorite)
    private let mainView = NSSearchView()
    private let searchManager = NSSearchManager()
    /// 검색 결과가 갱신되면, collection view를 reload 한다.
    private var shoppingResults: [ShoppingData] = [] {
        didSet {
            mainView.resultsCollectionView.reloadData()
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL)
        configBackBarButton(title: title)
        configurationView()
        setConstraints()
        configurationDelegate()
        firstBehavior()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.resultsCollectionView.reloadData()
    }
    
    // 첫번째 분류 셀이 선택되도록 한다.
    private func firstBehavior() {
        let startIndex = IndexPath(item: 0, section: 0)
        mainView.sortButtonCollectionView.selectItem(at: startIndex, animated: false, scrollPosition: .left)
    }
  
    private func configurationView() {
        view.backgroundColor(.systemBackground)
        view.addSubview(mainView)
        mainView.sortButtonCollectionView.register(NSButtonCollectionViewCell.self, forCellWithReuseIdentifier: NSButtonCollectionViewCell.identifier)
        mainView.resultsCollectionView.register(NSResultCollectionViewCell.self, forCellWithReuseIdentifier: NSResultCollectionViewCell.identifier)
    }
    

    private func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configurationDelegate() {
        searchManager.delegate = self
        mainView.searchBar.delegate = self
        mainView.sortButtonCollectionView.delegate = self
        mainView.sortButtonCollectionView.dataSource = self
        mainView.resultsCollectionView.delegate = self
        mainView.resultsCollectionView.dataSource = self
    }
    
}
// MARK: - ScrollView Did Scroll

extension NSSearchViewController {
    /// 스크롤뷰가 스크롤 되면 호출되는 메소드
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let collectionView = mainView.resultsCollectionView
        guard let selectedItem = mainView.sortButtonCollectionView.indexPathsForSelectedItems else {
            fatalError("sort_button_select_error".localized)
        }
        // 현재 선택된 분류 셀에 따라, API 호출 시 사용될 분류를 결정한다.
        let sort = SortType.allCases[selectedItem.first?.item ?? 0]
        // 검색어가 비어있는 경우, API 호출을 하지 않는다.
        guard let term = mainView.searchBar.text, !term.isEmpty else { return }
        // 스크롤이 맨 아래쪽으로 내려갔을 때, API 호출을 한다.
        if scrollView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.size.height {
            Task{ await searchManager.updateRequest(query: term, sort: sort) }
        }
    }
}

// MARK: - Search Bar Delegate

// 검색바와 관련된 델리게이트 메소드
extension NSSearchViewController: UISearchBarDelegate {
    
    /// 검색 버튼 클릭 시, 키보드를 내려준다.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    /// 취소 버튼 클릭 시, 키보드를 내리고 검색 결과 초기호
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        shoppingResults = []
    }
    
    /// 엔터 눌렀을 때 검색
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // 검색어가 비어있는 경우, API 호출을 하지 않는다.
        guard let term = searchBar.text, !term.isEmpty else { return }
        guard let selectedItem = mainView.sortButtonCollectionView.indexPathsForSelectedItems else {
            fatalError("sort_button_select_error".localized)
        }
        // 검색어와 분류 정보를 전달하면서, API 호출을 한다.
        searchManager.searchTerm(term: term, sort: SortType.allCases[selectedItem.first?.item ?? 0])
    }
}

// MARK: - Collection View Delegate

// collection view와 관련된 델리게이트 메소드
extension NSSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.sortButtonCollectionView {
            return SortType.allCases.count // 분류 셀의 개수를 반환한다.
        } else {
            return shoppingResults.count // 검색 결과의 개수를 반환한다.
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.sortButtonCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSButtonCollectionViewCell.identifier, for: indexPath) as! NSButtonCollectionViewCell
            // 분류 셀의 타이틀을 설정한다.
            cell.sortType = SortType.allCases[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSResultCollectionViewCell.identifier, for: indexPath) as! NSResultCollectionViewCell
            let item = self.shoppingResults[indexPath.item]
            cell.shoppingData = item
            // 셀 내의 버튼에 tag를 설정한다.
            cell.heartButton.tag = indexPath.item
            cell.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    // MARK: - Heart Button Tapped
    
    /// 즐겨찾기 버튼이 눌렸을 때, 호출되는 메소드
    @objc func heartButtonTapped(_ sender: UIButton) {
        // 즐겨찾기에 추가할 검색 결과를 가져온다.
        let shoppingData = shoppingResults[sender.tag]
        let task = shoppingData.convertToRealm()
        let realmShoppingData = realm.objects(RealmShoppingData.self)
        let storedShoppingData = realmShoppingData.where {
            $0.productID == shoppingData.productID
        }.first
        // 즐겨찾기 버튼이 있는 셀을 가져온다.
        let cell = mainView.resultsCollectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! NSResultCollectionViewCell
        // 이미 즐겨찾기에 추가된 경우, 즐겨찾기를 제거한다.
        if let storedShoppingData {
            // 버튼을 선택되지 않은 상태로 변경한다.
            cell.heartButton.isSelected = false
            // 해당 상품의 이미지를 삭제한다.
            RealmManager.removeImageFromDocument(fileName: shoppingData.productID)
            // 해당 상품을 즐겨찾기에서 삭제한다.
            try! realm.write {
                realm.delete(storedShoppingData)
            }
        // 즐겨찾기에 추가되지 않은 경우, 즐겨찾기에 추가한다.
        } else {
            // 버튼을 선택된 상태로 변경한다.
            cell.heartButton.isSelected = true
            // 해당 상품의 이미지를 저장한다.
            RealmManager.saveImageToDocument(fileName: shoppingData.productID, image: cell.imageView.image)
            // 현재 시간과 함께 즐겨찾기 항목을 추가한다
            try! realm.write {
                task.storedDate = Date()
                realm.add(task)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.sortButtonCollectionView {
            guard let term = mainView.searchBar.text, !term.isEmpty else { return }
            // 선택된 분류 셀에 따라, API 호출을 한다.
            searchManager.searchTerm(term: term, sort: SortType.allCases[indexPath.row])
        } else {
            transition(viewController: NSDetailViewController(), style: .pushNavigation) { [weak self] vc in
                let item = self?.shoppingResults[indexPath.item]
                // 상세 페이지에 검색 결과를 전달한다.
                vc.shoppingData = item
                vc.title = item?.title.htmlToString
            }
        }
    }
}

// MARK: - Search Manager Delegate

// API 호출 결과를 받아오는 델리게이트 메소드
extension NSSearchViewController: NSSearchProtocol {
    
    /// 쇼핑리스트 가져오기
    /// 검색 결과를 갱신하는 작업은 main queue에서 실행되어야 한다.
    func fetchShoppingList(_ list: [ShoppingData]) {
        DispatchQueue.main.async {
            self.shoppingResults = list
        }
    }
    
    /// 페이지네이션으로 쇼핑리스트 추가
    /// 검색 결과를 갱신하는 작업은 main queue에서 실행되어야 한다.
    func updateShoppingList(_ list: [ShoppingData]) {
        DispatchQueue.main.async {
            self.shoppingResults.append(contentsOf: list)
        }
    }
    
    /// 에러 전달받아 알람 띄우기
    func receiveError(_ errorMessage: String) {
        DispatchQueue.main.async {
            self.showCancelAlert(title: "alert_title_receive_error".localized, message: errorMessage, preferredStyle: .alert)
        }
        
    }
}
