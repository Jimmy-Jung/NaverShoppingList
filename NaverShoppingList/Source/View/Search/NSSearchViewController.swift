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
    
    private let realm = try! Realm()
    private let mainView = NSSearchView()
    private let searchManager = NSSearchManager()
    private var shoppingResults: [ShoppingData] = [] {
        didSet {
            mainView.resultsCollectionView.reloadData() // 검색 결과가 갱신되면, collection view를 reload 한다.
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBackBarButton(title: title)
        configurationView()
        setConstraints()
        configurationDelegate()
        let startIndex = IndexPath(item: 0, section: 0)
        // 첫번째 분류 셀이 선택되도록 한다.
        mainView.sortButtonCollectionView.selectItem(at: startIndex, animated: false, scrollPosition: .left)
    }
    
    // MARK: - Configuration View
    
    private func configurationView() {
        view.backgroundColor(.systemBackground)
        view.addSubview(mainView)
        mainView.sortButtonCollectionView.register(NSButtonCollectionViewCell.self, forCellWithReuseIdentifier: NSButtonCollectionViewCell.identifier)
        mainView.resultsCollectionView.register(NSResultCollectionViewCell.self, forCellWithReuseIdentifier: NSResultCollectionViewCell.identifier)
    }
    
    // MARK: - ScrollView Did Scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // 스크롤뷰가 스크롤 되면 호출되는 메소드
        
        let collectionView = mainView.resultsCollectionView
        guard let selectedItem = mainView.sortButtonCollectionView.indexPathsForSelectedItems else {
            fatalError("선택된 분류 셀이 없습니다.")
        }
        let sort = SortType.allCases[selectedItem.first?.item ?? 0] // 현재 선택된 분류 셀에 따라, API 호출 시 사용될 분류를 결정한다.
        let index = collectionView.indexPathsForSelectedItems?.first?.item
        guard let term = mainView.searchBar.text, !term.isEmpty else { return } // 검색어가 비어있는 경우, API 호출을 하지 않는다.
        if scrollView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.size.height { // 스크롤이 맨 아래쪽으로 내려갔을 때, API 호출을 한다.
            Task{ await searchManager.updateRequest(query: term, sort: sort) } // 검색어와 분류 정보를 전달하면서, API 호출을 한다.
        }
    }
    
    // MARK: - Set Constraints
    
    private func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Configuration Delegate
    
    private func configurationDelegate() {
        searchManager.delegate = self
        mainView.searchBar.delegate = self
        mainView.sortButtonCollectionView.delegate = self
        mainView.sortButtonCollectionView.dataSource = self
        mainView.resultsCollectionView.delegate = self
        mainView.resultsCollectionView.dataSource = self
    }
    
}

// MARK: - Search Bar Delegate

extension NSSearchViewController: UISearchBarDelegate { // 검색바와 관련된 델리게이트 메소드가 구현되어 있다.
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // 검색 버튼 클릭 시, 키보드를 내려준다.
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // 취소 버튼 클릭 시, 키보드를 내려준다.
        searchBar.text = nil // 검색어를 초기화한다.
        shoppingResults = [] // 검색 결과를 초기화한다.
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // 편집이 끝나면, 키보드를 내려준다.
        guard let term = searchBar.text, !term.isEmpty else { return } // 검색어가 비어있는 경우, API 호출을 하지 않는다.
        guard let selectedItem = mainView.sortButtonCollectionView.indexPathsForSelectedItems else {
            fatalError("선택된 분류 셀이 없습니다.")
        }
        searchManager.searchTerm(term: term, sort: SortType.allCases[selectedItem.first?.item ?? 0]) // 검색어와 분류 정보를 전달하면서, API 호출을 한다.
    }
}

// MARK: - Collection View Delegate
// collection view와 관련된 델리게이트 메소드가 구현되어 있다.
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
            cell.sortType = SortType.allCases[indexPath.item] // 분류 셀의 타이틀을 설정한다.
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSResultCollectionViewCell.identifier, for: indexPath) as! NSResultCollectionViewCell
            let item = self.shoppingResults[indexPath.item]
            cell.shoppingData = item // 셀에 검색 결과를 설정한다.
            cell.heartButton.tag = indexPath.item // 셀 내의 버튼에 tag를 설정한다.
            cell.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside) // 버튼이 눌렸을 때, 호출될 메소드를 설정한다.
            return cell
        }
    }
    
    // MARK: - Heart Button Tapped
    
    @objc func heartButtonTapped(_ sender: UIButton) { // 즐겨찾기 버튼이 눌렸을 때, 호출되는 메소드
        
        let shoppingData = shoppingResults[sender.tag] // 즐겨찾기에 추가할 검색 결과를 가져온다.
        let task = shoppingData.convertToRealm()
        let realmShoppingData = realm.objects(RealmShoppingData.self)
        let storedShoppingData = realmShoppingData.where {
            $0.productID == shoppingData.productID
        }.first
        
        let cell = mainView.resultsCollectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! NSResultCollectionViewCell // 즐겨찾기 버튼이 있는 셀을 가져온다.
        if let storedShoppingData { // 이미 즐겨찾기에 추가된 경우, 즐겨찾기를 제거한다.
            cell.heartButton.isSelected = false // 버튼을 선택되지 않은 상태로 변경한다.
            RealmManager.removeImageFromDocument(fileName: shoppingData.productID) // 해당 상품의 이미지를 삭제한다.
            try! realm.write {
                realm.delete(storedShoppingData) // 해당 상품을 즐겨찾기에서 삭제한다.
            }
            
        } else { // 즐겨찾기에 추가되지 않은 경우, 즐겨찾기에 추가한다.
            cell.heartButton.isSelected = true // 버튼을 선택된 상태로 변경한다.
            RealmManager.saveImageToDocument(fileName: shoppingData.productID, image: cell.imageView.image) // 해당 상품의 이미지를 저장한다.
            try! realm.write {
                task.storedDate = Date() // 현재 시간을 저장한다.
                realm.add(task) // 새로운 즐겨찾기 항목을 추가한다.
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.sortButtonCollectionView {
            guard let term = mainView.searchBar.text, !term.isEmpty else { return }
            searchManager.searchTerm(term: term, sort: SortType.allCases[indexPath.row]) // 선택된 분류 셀에 따라, API 호출을 한다.
        } else {
            transition(viewController: NSDetailViewController(), style: .pushNavigation) { [weak self] vc in
                let item = self?.shoppingResults[indexPath.item]
                vc.shoppingData = item // 상세 페이지에 검색 결과를 전달한다.
                vc.title = item?.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "") // 타이틀을 설정한다.
            }
        }
    }
}

// MARK: - Search Manager Delegate
// API 호출 결과를 받아오는 델리게이트 메소드가 구현되어 있다.
extension NSSearchViewController: NSSearchProtocol {
    func fetchShoppingList(_ list: [ShoppingData]) {
        // 검색 결과를 갱신하는 작업은 main queue에서 실행되어야 한다.
        DispatchQueue.main.async {
            self.shoppingResults = list // API 호출 결과를 검색 결과에 적용한다.
        }
    }
    func updateShoppingList(_ list: [ShoppingData]) {
        DispatchQueue.main.async {
            self.shoppingResults.append(contentsOf: list)
        }
    }
    
    func receiveError(_ errorMessage: String) {
        DispatchQueue.main.async {
            self.showCancelAlert(title: "데이터 불러오기 실패!", message: errorMessage, preferredStyle: .alert)
        }
        
    }
}
