//
//  NetworkManager.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 5/24/21.
//

import UIKit

protocol INetworkSession {
    func load(with: URL, completion: @escaping (Data?, Error?) -> Void)
}

extension URLSession: INetworkSession {
    func load(with url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, _, error) in
            completion(data, error)
        }
        task.resume()
    }
}
