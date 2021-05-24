//
//  ImageLoader.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/27/21.
//

import UIKit

protocol IImageProvider {
    func fetch(resultQueue: DispatchQueue, urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void)
}

class ImageProvider: IImageProvider {
    
    fileprivate let networkSession: INetworkSession
    
    init(networkSession: INetworkSession) {
        self.networkSession = networkSession
    }
    
    func fetch(resultQueue: DispatchQueue, urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            resultQueue.async {
                completion(.failure(.badURL))
            }
            return
        }
        
        networkSession.load(with: url) { (data, error) in
            var result: Result<UIImage, NetworkError>
            if error != nil {
                result = .failure(.requestFailed)
            }
            else if let imageData = data, let image = UIImage(data: imageData) {
                result = .success(image)
            }
            else {
                result = .failure(.invalidData)
            }
            resultQueue.async {
                completion(result)
            }
        }
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
    
    func fetch(resultQueue: DispatchQueue, urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let key = urlString as NSString
        
        guard let image = cache.object(forKey: key) else {
            imageProvider.fetch(resultQueue: resultQueue, urlString: urlString) { [weak self] result in
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
