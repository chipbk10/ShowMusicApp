//
//  ImageLoader.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/27/21.
//

import UIKit

protocol IImageProvider {
    func fetch(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void)
}

class ImageProvider: IImageProvider {
    
    func fetch(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.requestFailed))
            }
            else if let imageData = data, let image = UIImage(data: imageData) {
                completion(.success(image))
            }
            else {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}

class CachedImageProvider: IImageProvider {
    
    private let imageProvider: IImageProvider
    private let cache: NSCache<NSString, UIImage>
        
    init(limit: Int = 50, imageProvider: IImageProvider) {
        self.imageProvider = imageProvider
        self.cache = NSCache()
        self.cache.countLimit = limit
    }
    
    func fetch(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let key = urlString as NSString
        
        guard let image = cache.object(forKey: key) else {
            imageProvider.fetch(urlString: urlString) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.cache.setObject(image, forKey: key)
                case .failure(let error):
                    print("Failed to fetch image: \(error.localizedDescription)")
                }
                completion(result)
            }
            return
        }
        
        print("Get image from the cache")
        completion(.success(image))
    }
}
