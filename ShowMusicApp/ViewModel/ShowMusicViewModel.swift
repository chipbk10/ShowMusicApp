//
//  ShowMusicViewModel.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/26/21.
//

import Foundation
import UIKit

protocol IShowMusicViewModel {
    
    var isLoadingData: Box<Bool> { get }
    
    func reloadData(completion: @escaping (Bool) -> Void)
    func getNumberOfPlaylists() -> Int
    func getPlaylistTitle(atIndex: Int) -> String
    func getNumberOfAlbums(inPlaylist: Int) -> Int
    func getAlbumTitle(inPlaylist: Int, inAlbum: Int) -> String
    func fetchAlbumImageData(inPlaylist: Int, inAlbum: Int, completion: @escaping (UIImage?) -> Void)
}

class ShowMusicViewModel: IShowMusicViewModel{
            
    fileprivate let imageProvider: IImageProvider
    fileprivate let musicDataProvider: IMusicDataProvider
    fileprivate var albums: [Album]?
    fileprivate var playlists: [Playlist]?
    
    var isLoadingData: Box<Bool> = Box(false)
    
    init(musicDataProvider: IMusicDataProvider, imageProvider: IImageProvider) {
        self.musicDataProvider = musicDataProvider
        self.imageProvider = imageProvider
    }
}

extension ShowMusicViewModel {
    
    func reloadData(completion: @escaping (Bool) -> Void) {
        
        isLoadingData.value = true
        musicDataProvider.fetch { [weak self] result in
        
            switch result {
        
                case .success(let musicData):
                    self?.albums = musicData.albums
                    self?.playlists = musicData.playlists
                    self?.isLoadingData.value = false
                    completion(true)
                
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.isLoadingData.value = false
                    completion(false)
            }
        }
    }
    
    func getNumberOfPlaylists() -> Int {
        return playlists?.count ?? 0
    }
    
    func getPlaylistTitle(atIndex index: Int) -> String {
        guard let playlist = extract(objects: playlists, index: index) else { return "" }
        return playlist.title
    }
    
    func getNumberOfAlbums(inPlaylist index: Int) -> Int {
        guard let playlist = extract(objects: playlists, index: index) else { return 0 }
        return playlist.albumIds.count
    }
    
    func getAlbumTitle(inPlaylist playListId: Int, inAlbum albumId: Int) -> String {
        guard let album = getAlbum(inPlaylist: playListId, inAlbum: albumId) else { return "" }
        return album.title                
    }
    
    private func getAlbumImageUrl(inPlaylist playListId: Int, inAlbum albumId: Int) -> String? {
        guard let album = getAlbum(inPlaylist: playListId, inAlbum: albumId) else { return nil }
        return album.imageUrl
    }
    
    func fetchAlbumImageData(inPlaylist playListId: Int, inAlbum albumId: Int, completion: @escaping (UIImage?) -> Void) {
        
        guard let albumIndex = getAlbumIndex(inPlaylist: playListId, inAlbum: albumId) else {
            completion(nil)
            return
        }
        
        guard albumIndex >= 0 && albumIndex < albums!.count else {
            completion(nil)
            return
        }
        
        fetchAlbumImageData(albumIndex: albumIndex, completion: completion)
    }
    
    private func fetchAlbumImageData(albumIndex index: Int, completion: @escaping (UIImage?) -> Void) {
        let imageUrl = albums![index].imageUrl
        imageProvider.fetch(urlString: imageUrl) { result in
            switch result {
            
            case .success(let imageData):
                completion(imageData)
                
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    private func getAlbumIndex(inPlaylist playListId: Int, inAlbum albumId: Int) -> Int? {
        guard let playlist = extract(objects: playlists, index: playListId) else { return nil }
        guard let albumIndex = extract(objects: playlist.albumIds, index: albumId) else { return nil }
        return albumIndex
    }
    
    private func getAlbum(inPlaylist playListId: Int, inAlbum albumId: Int) -> Album? {
        guard let albumIndex = getAlbumIndex(inPlaylist: playListId, inAlbum: albumId) else { return nil }
        guard let album = extract(objects: albums, index: albumIndex) else { return nil }
        return album
    }
    
    func extract<T>(objects: [T]?, index: Int) -> T? {
        guard let objects = objects else { return nil }
        guard index >= 0 && index < objects.count else { return nil }
        return objects[index]
    }
}
