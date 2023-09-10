//
//  NSLikedViewController.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit
import RealmSwift

class NSLikedViewController: UIViewController {
    
    private let realm = try! Realm()
    private var realmShoppingResult: Results<RealmShoppingData>! {
        didSet {
            mainView.resultsCollectionView.reloadData()
        }
    }
    private let mainView = NSSearchView()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchShoppingData()
        configurationView()
        setConstraints()
        configurationDelegate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.resultsCollectionView.reloadData()
    }
    private func fetchShoppingData() {
        realmShoppingResult = realm.objects(RealmShoppingData.self).sorted(byKeyPath: "storedDate", ascending: false)
    }
    private func configurationView() {
        view.backgroundColor(.systemBackground)
        view.addSubview(mainView)
        mainView.sortButtonCollectionView.isHidden(true)
        mainView.resultsCollectionView.register(NSResultCollectionViewCell.self, forCellWithReuseIdentifier: NSResultCollectionViewCell.identifier)
    }
    
    private func setConstraints() {
        mainView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func configurationDelegate() {
        mainView.searchBar.delegate = self
        mainView.resultsCollectionView.delegate = self
        mainView.resultsCollectionView.dataSource = self
    }
}

extension NSLikedViewController: UISearchBarDelegate {
    private func searchTerm(term: String) {
        let realmShoppingData = realm.objects(RealmShoppingData.self)
        realmShoppingResult = realmShoppingData.where {
            $0.title.contains(term)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        realmShoppingResult = realm.objects(RealmShoppingData.self)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            searchTerm(term: searchText)
        } else {
            realmShoppingResult = realm.objects(RealmShoppingData.self)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let term = searchBar.text, !term.isEmpty else { return }
        searchTerm(term: term)
    }
}

extension NSLikedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realmShoppingResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSResultCollectionViewCell.identifier, for: indexPath) as! NSResultCollectionViewCell
        cell.shoppingData = ShoppingData(from: realmShoppingResult[indexPath.item])
        cell.heartButton.tag = indexPath.item
        cell.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func heartButtonTapped(_ sender: UIButton) {
        let task = realmShoppingResult[sender.tag]
        try! realm.write {
            realm.delete(task)
        }
        mainView.resultsCollectionView.reloadData()
        
        
    }
}

