//
//  ViewController.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/09.
//

import UIKit

final class NSSearchViewController: UIViewController {
    typealias SortType = NaverShoppingEndPoint.Sort
    
    private let mainView = NSSearchView()
    private let searchManager = NSSearchManager()
    private var shoppingResults: [ShoppingData] = [] {
        didSet {
            mainView.resultsCollectionView.reloadData()
            print(shoppingResults)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationView()
        setConstraints()
        configurationDelegate()
        let startIndex = IndexPath(item: 0, section: 0)
        mainView.sortButtonCollectionView.selectItem(at: startIndex, animated: false, scrollPosition: .left)
    }

    private func configurationView() {
        view.backgroundColor(.systemBackground)
        view.addSubview(mainView)
        mainView.sortButtonCollectionView.register(NSButtonCollectionViewCell.self, forCellWithReuseIdentifier: NSButtonCollectionViewCell.identifier)
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
        mainView.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let term = searchBar.text, !term.isEmpty else { return }
        
    }
}

extension NSSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.sortButtonCollectionView {
            return SortType.allCases.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.sortButtonCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSButtonCollectionViewCell.identifier, for: indexPath) as! NSButtonCollectionViewCell
            cell.sortType = SortType.allCases[indexPath.row]
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let term = mainView.searchBar.text, !term.isEmpty else { return }
        searchManager.searchTerm(term: term, sort: SortType.allCases[indexPath.row])
    }
}

extension NSSearchViewController: NSSearchProtocol {
    func updateShoppingList(_ list: [ShoppingData]) {
        DispatchQueue.main.async {
            self.shoppingResults = list
        }
    }
    
    func receiveError(_ errorMessage: String) {
        DispatchQueue.main.async {
            self.showCancelAlert(title: "데이터 불러오기 실패!", message: errorMessage, preferredStyle: .alert)
        }
        
    }
    

    
    
}
