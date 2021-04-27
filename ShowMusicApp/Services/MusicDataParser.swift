//
//  MusicDataParser.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/26/21.
//

import SwiftyJSON

protocol IMusicDataParser {
    
    func parse(data: Data?) -> MusicData?
}

class MusicDataParser: IMusicDataParser {
    
    func parse(data: Data?) -> MusicData? {
        
        guard let data = data else { return nil }
        guard let json = try? JSON(data: data) else { return nil }
        return parseMusicData(json: json)
    }
    
    private func parseMusicData(json: JSON) -> MusicData? {
        
        guard json["albums"].exists() && json["playlists"].exists() else { return nil }
        
        let albumsJson = json["albums"]
        guard let albums = parseAlbums(json: albumsJson) else { return nil }
        
        let playlistsJson = json["playlists"]
        guard let playlists = parsePlaylists(json: playlistsJson) else { return nil }
        
        return MusicData(albums: albums, playlists: playlists)
    }
    
    private func parseAlbums(json: JSON) -> [Album]? {
        var res : [Album] = []
        
        for albumJson in json.arrayValue {
            guard let album = parseAlbum(json: albumJson) else { return nil }
            res.append(album)
        }
        
        return res
    }
    
    private func parseAlbum(json: JSON) -> Album? {
        
        guard json["imageUrl"].exists() && json["id"].exists() && json["title"].exists() else { return nil }
        
        let imageUrl = json["imageUrl"].stringValue
        let title = json["title"].stringValue
        let id = json["id"].intValue
        
        return Album(imageUrl: imageUrl, title: title, id: id)
    }
    
    private func parsePlaylists(json: JSON) -> [Playlist]? {
        var res : [Playlist] = []
        
        for playlistJson in json.arrayValue {
            guard let playlist = parsePlaylist(json: playlistJson) else { return nil }
            res.append(playlist)
        }
        
        return res
    }
    
    private func parsePlaylist(json: JSON) -> Playlist? {
        
        guard json["albums"].exists() && json["id"].exists() && json["title"].exists() else { return nil }
        
        let albumIds : [Int] = json["albums"].arrayValue.map {$0.intValue}
        let title = json["title"].stringValue
        let id = json["id"].intValue
        
        return Playlist(id: id, title: title, albumIds: albumIds)
    }
}
