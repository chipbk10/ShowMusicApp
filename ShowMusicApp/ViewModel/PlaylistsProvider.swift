//
//  PlaylistsProvider.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/26/21.
//

import Foundation

protocol IPlaylistsProvider {
    
    func fetch(completion: @escaping (Result<MusicData, NetworkError>) -> Void)
}

class MusicDataProvider: IPlaylistsProvider {
            
    let endpointURL: URL?
    let parser: IMusicDataParser
    
    init(endpoint: String, parser: IMusicDataParser) {
        self.endpointURL = URL(string: endpoint)
        self.parser = parser
    }
    
    func fetch(completion: @escaping (Result<MusicData, NetworkError>) -> Void) {
        
        guard let url = endpointURL else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                // parse json
                let music = MusicData(albums: [], playlists: [])
                completion(.success(music))
            }
            else if error != nil {
                completion(.failure(.requestFailed))
            }
            else {
                completion(.failure(.unknown))
            }
            
        }
    }
}


