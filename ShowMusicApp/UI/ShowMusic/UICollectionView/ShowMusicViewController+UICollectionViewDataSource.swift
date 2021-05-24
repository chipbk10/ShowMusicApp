//
//  ShowMusicViewController+UICollectionViewDataSource.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/27/21.
//

import UIKit

extension ShowMusicViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let playlistId = collectionView.tag        
        return viewModel?.getNumberOfAlbums(inPlaylist: playlistId) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowMusicCollectionViewCell.identifier,
                                                      for: indexPath) as! ShowMusicCollectionViewCell
        
        // set album title
        let playlistId = collectionView.tag
        let albumId = indexPath.row
        if let title = viewModel?.getAlbumTitle(inPlaylist: playlistId, inAlbum: albumId) {
            cell.setTitle(title: title)
        }
        
        // set album image
        viewModel?.fetchAlbumImageData(inPlaylist: playlistId, inAlbum: albumId) { image in
            cell.setImageView(image: image)
        }
                
        return cell
    }
}
