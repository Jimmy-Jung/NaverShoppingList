//
//  ImageView+Extension.swift
//  NaverShoppingList
//
//  Created by 정준영 on 2023/09/10.
//

import UIKit

final class ImageCacheManager {
    /// Key: NSString, Value: UIImage
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

enum ImageTransition {
    /// No animation transition.
    case none
    /// Fade in the loaded image in a given duration.
    case fade(TimeInterval)
    
    var duration: TimeInterval {
        switch self {
        case .none: return 0
        case .fade(let duration): return duration
        }
    }
    var animationOptions: UIView.AnimationOptions {
        switch self {
        case .none: return []
        case .fade: return .transitionCrossDissolve
        }
    }
}

extension UIImageView {
    /// 이미지 가져오기 with caching
    /// - Parameters:
    ///   - link: URL Link
    ///   - placeHolder: 기본 이미지
    ///   - completionHandler: 네트워킹 완료시 할 작업
    func setImage(
        with link: String,
        placeHolder: UIImage? = nil,
        transition: ImageTransition? = nil,
        completionHandler: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        // 기본 이미지 설정
        if let placeHolder {
            self.image = placeHolder
        }
        // 캐시 저장 키값은 링크
        let cacheKey = NSString(string: link)
        // 캐시 저장 여부 확인
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        guard let url = URL(string: link) else { return }
        // 네트워킹
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error {
                DispatchQueue.main.async { [weak self] in
                    self?.image = placeHolder
                    completionHandler?(.failure(error))
                }
                return
            }
            if let data, let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    
                    guard let transition else {
                        self.image = image
                        return
                    }
                    UIView.transition(
                        with: self,
                        duration: transition.duration,
                        options: [transition.animationOptions, .allowUserInteraction],
                        animations: { self.image = image
                        }
                    )
                    completionHandler?(.success(image))
                }
            }
        }.resume()
    }
}
