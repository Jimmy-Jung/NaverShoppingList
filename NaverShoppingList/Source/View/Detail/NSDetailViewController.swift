//
//  NSDetailViewController.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit
import WebKit
import RealmSwift

class NSDetailViewController: UIViewController, WKUIDelegate {
    
    private lazy var webView: WKWebView = {
        var web = WKWebView()
        let webConfiguration = WKWebViewConfiguration()
        web = WKWebView(frame: .zero, configuration: webConfiguration)
        web.uiDelegate = self
        return web
    }()
    
    let realm = try! Realm()
    var shoppingData: ShoppingData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationUI()
        openWebPage(to: shoppingData.productID)
        configurationBarButton()
        
    }
    
    private func configurationUI() {
        view.backgroundColor(.systemBackground)
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configurationBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(storeButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .label
        let realmShoppingData = realm.objects(RealmShoppingData.self)
        let storedShoppingData = realmShoppingData.where {
            $0.productID == shoppingData.productID
        }.first
        
        if storedShoppingData != nil {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
    }
    
    func openWebPage(to productID: String) {
        let newURL = "https://msearch.shopping.naver.com/product/" + productID
        guard let url = URL(string: newURL) else {
            print("fail")
            return }
        print(url)
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func storeButtonTapped() {
        let task = shoppingData.convertToRealm()
        let realmShoppingData = realm.objects(RealmShoppingData.self)
        let storedShoppingData = realmShoppingData.where {
            $0.productID == shoppingData.productID
        }.first
        
        if let storedShoppingData {
            
            RealmManager.removeImageFromDocument(fileName: shoppingData.productID)
            try! realm.write {
                realm.delete(storedShoppingData)
            }
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        } else {
            try! realm.write {
                task.storedDate = Date()
                realm.add(task)
            }
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Web view did finish loading")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Web view did fail provisional navigation with error: \\(error)")
    }
    
}
