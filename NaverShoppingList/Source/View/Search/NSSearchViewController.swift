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
    
    private let realm = try! Realm()
    private let mainView = NSSearchView()
    private let searchManager = NSSearchManager()
    private var shoppingResults: [ShoppingData] = [] {
        didSet {
            mainView.resultsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBackBarButton(title: title)
        configurationView()
        setConstraints()
        configurationDelegate()
//        print(realm.configuration.fileURL)
        let startIndex = IndexPath(item: 0, section: 0)
        mainView.sortButtonCollectionView.selectItem(at: startIndex, animated: false, scrollPosition: .left)
    }

    private func configurationView() {
        view.backgroundColor(.systemBackground)
        view.addSubview(mainView)
        mainView.sortButtonCollectionView.register(NSButtonCollectionViewCell.self, forCellWithReuseIdentifier: NSButtonCollectionViewCell.identifier)
        mainView.resultsCollectionView.register(NSResultCollectionViewCell.self, forCellWithReuseIdentifier: NSResultCollectionViewCell.identifier)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let collectionView = mainView.resultsCollectionView
        guard let selectedItem = mainView.sortButtonCollectionView.indexPathsForSelectedItems else {
            fatalError("선택된 분류 셀이 없습니다.")
        }
        let sort = SortType.allCases[selectedItem.first?.item ?? 0]
        let index = collectionView.indexPathsForSelectedItems?.first?.item
        guard let term = mainView.searchBar.text, !term.isEmpty else { return }
        if scrollView.contentOffset.y > collectionView.contentSize.height - collectionView.bounds.size.height {
            Task{ await searchManager.updateRequest(query: term, sort: sort) }
        }
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

extension NSSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        shoppingResults = []
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let term = searchBar.text, !term.isEmpty else { return }
        guard let selectedItem = mainView.sortButtonCollectionView.indexPathsForSelectedItems else {
            fatalError("선택된 분류 셀이 없습니다.")
        }
        searchManager.searchTerm(term: term, sort: SortType.allCases[selectedItem.first?.item ?? 0])
    }
}

extension NSSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.sortButtonCollectionView {
            return SortType.allCases.count
        } else {
            return shoppingResults.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.sortButtonCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSButtonCollectionViewCell.identifier, for: indexPath) as! NSButtonCollectionViewCell
            cell.sortType = SortType.allCases[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSResultCollectionViewCell.identifier, for: indexPath) as! NSResultCollectionViewCell
            let item = self.shoppingResults[indexPath.item]
            cell.shoppingData = item
            cell.heartButton.tag = indexPath.item
            cell.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func heartButtonTapped(_ sender: UIButton) {
        let shoppingData = shoppingResults[sender.tag]
        let task = shoppingData.convertToRealm()
        let realmShoppingData = realm.objects(RealmShoppingData.self)
        let storedShoppingData = realmShoppingData.where {
            $0.productID == shoppingData.productID
        }.first
        
        let cell = mainView.resultsCollectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as! NSResultCollectionViewCell
        if let storedShoppingData {
            cell.heartButton.isSelected = false
            RealmManager.removeImageFromDocument(fileName: shoppingData.productID)
            try! realm.write {
                realm.delete(storedShoppingData)
            }

        } else {
            cell.heartButton.isSelected = true
            RealmManager.saveImageToDocument(fileName: shoppingData.productID, image: cell.imageView.image)
            try! realm.write {
                task.storedDate = Date()
                realm.add(task)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.sortButtonCollectionView {
            guard let term = mainView.searchBar.text, !term.isEmpty else { return }
            searchManager.searchTerm(term: term, sort: SortType.allCases[indexPath.row])
        } else {
            transition(viewController: NSDetailViewController(), style: .pushNavigation) { [weak self] vc in
                let item = self?.shoppingResults[indexPath.item]
                vc.shoppingData = item
                vc.title = item?.title.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
            }
        }
    }
}

extension NSSearchViewController: NSSearchProtocol {
    func fetchShoppingList(_ list: [ShoppingData]) {
        DispatchQueue.main.async {
            self.shoppingResults = list
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
