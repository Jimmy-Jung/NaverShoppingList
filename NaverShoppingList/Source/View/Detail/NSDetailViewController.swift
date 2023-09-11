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

    // MARK:- Properties

    private lazy var webView: WKWebView = {
        var web = WKWebView()
        let webConfiguration = WKWebViewConfiguration()
        web = WKWebView(frame: .zero, configuration: webConfiguration)
        web.uiDelegate = self
        return web
    }()
    
    // 현재 상품이 즐겨찾기에 있는지 확인
    private var storedData: RealmShoppingData? {
        let realmShoppingData = realm.objects(RealmShoppingData.self)
        let storedShoppingData = realmShoppingData.where {
            $0.productID == shoppingData.productID
        }.first
        return storedShoppingData
    }

    let realm = try! Realm()
    var shoppingData: ShoppingData!

    // MARK:- Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configurationUI()
        openWebPage(to: shoppingData.productID)
        configurationBarButton()
    }

    // MARK:- UI

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
        
        if storedData != nil {
            // 즐겨찾기에 있다면 하트를 채워진 모양으로 변경
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
    }

    // MARK:- Functions

    func openWebPage(to productID: String) {
        // URL 생성
        let newURL = "https://msearch.shopping.naver.com/product/" + productID
        guard let url = URL(string: newURL) else {
            showCancelAlert(title: "alert_title_url_error".localized, message: nil, preferredStyle: .alert)
            return }
        // URL 요청
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    /// 저장버튼 탭햇을 때 호출되는 메서드
    @objc private func storeButtonTapped() {
        // ShoppingData 모델을 RealmShoppingData 모델로 변환
        let task = shoppingData.convertToRealm()

        if let storedData {
            // 즐겨찾기에 있다면 삭제
            RealmManager.removeImageFromDocument(fileName: shoppingData.productID)
            try! realm.write {
                realm.delete(storedData)
            }
            // 버튼 이미지를 빈 하트 모양으로 변경
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        } else {
            // 즐겨찾기에 없다면 추가
            try! realm.write {
                task.storedDate = Date()
                realm.add(task)
            }
            // 버튼 이미지를 채워진 하트 모양으로 변경
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
    }

    // MARK:- WKUIDelegate Functions

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Web view did finish loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Web view did fail provisional navigation with error: \(error)")
    }
}
