//
//  RealmManager.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit
import RealmSwift

enum RealmManager {
    enum RealmPath: String {
        case favorite
    }
    
    static func createRealm(path: RealmPath) -> Realm {
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(path.rawValue)
        config.fileURL!.appendPathExtension("realm")
        let realm = try! Realm(configuration: config)
        return realm
    }
    
    static func imagePath(itemId: Int?) -> String {
        guard let itemId else { return "" }
        return "\(itemId).jpg"
    }
    
    /// 도큐먼트 폴더에서 이미지를 가져오는 메서드
    static func removeImageFromDocument(fileName: String) {
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return }
        
        // 2. 삭제할 경로 설정(세부 경로, 이미지가 저장되어 있는 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print("file remove error: ", error)
        }
    }
    
    /// 도큐먼트 폴더에서 이미지를 가져오는 메서드
    static func loadImageFromDocument(fileName: String) -> UIImage? {
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return nil}
        
        // 2. 저장할 경로 설정(세부 경로, 이미지가 저장되어 있는 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)!
        } else {
            return nil
        }
    }
    
    /// 도큐먼트 폴더에 이미지를 저장하는 메서드
    static func saveImageToDocument(fileName: String, image: UIImage?) {
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first
        else { return }
        
        // 2. 저장할 경로 설정(세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        // 3. 이미지 변환
        // jpg는 압축률 정할 수 있음
        guard let data = image?.jpegData(compressionQuality: 1) else { return }
        
        // 4. 이미지 저장
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error: ", error)
        }
    }
}
