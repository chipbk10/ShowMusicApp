//
//  PlaylistsProvider.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/26/21.
//

import Foundation

protocol IMusicDataProvider {
    func fetch(resultQueue: DispatchQueue, completion: @escaping (Result<MusicData, NetworkError>) -> Void)
}

extension IMusicDataProvider {
    func fetch(resultQueue: DispatchQueue = .main, completion: @escaping (Result<MusicData, NetworkError>) -> Void) {
        fetch(resultQueue: resultQueue, completion: completion)
    }
}

class MusicDataProvider {
            
    fileprivate let endpointURL: URL?
    fileprivate let musicDataParser: IMusicDataParser
    fileprivate let networkSession: INetworkSession
    
    init(endpoint: String, networkSession: INetworkSession, parser: IMusicDataParser) {
        self.endpointURL = URL(string: endpoint)
        self.networkSession = networkSession
        self.musicDataParser = parser
    }
}

extension MusicDataProvider: IMusicDataProvider {
    
    func fetch(resultQueue: DispatchQueue = .main, completion: @escaping (Result<MusicData, NetworkError>) -> Void) {
        
        guard let url = endpointURL else {
            resultQueue.async { completion(.failure(.badURL)) }
            return
        }
        
        networkSession.load(with: url) { (data, error) in
            var result: Result<MusicData, NetworkError>
            
            if error != nil {
                result = .failure(.requestFailed)
            }
            else if let musicData = self.musicDataParser.parse(data: data) {
                result = .success(musicData)
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


