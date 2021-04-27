//
//  PlaylistsProvider.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/26/21.
//

import Foundation

protocol IMusicDataProvider {
    
    func fetch(completion: @escaping (Result<MusicData, NetworkError>) -> Void)
}

class MusicDataProvider {
            
    fileprivate let endpointURL: URL?
    fileprivate let musicDataParser: IMusicDataParser
    
    init(endpoint: String, parser: IMusicDataParser) {
        self.endpointURL = URL(string: endpoint)
        self.musicDataParser = parser
    }
}

extension MusicDataProvider: IMusicDataProvider {
    
    func fetch(completion: @escaping (Result<MusicData, NetworkError>) -> Void) {
        
        guard let url = endpointURL else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(.requestFailed))
            }
            else if let musicData = self.musicDataParser.parse(data: data) {
                completion(.success(musicData))
            }
            else {
                completion(.failure(.invalidData))
            }
        }.resume()
    }
}


