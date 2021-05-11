//
//  ShowMusicTableViewCell.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/27/21.
//

import UIKit

class ShowMusicTableViewCell: UITableViewCell {
    
    static let identifier = "ShowMusicTableViewCell"
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView?
}

extension ShowMusicTableViewCell {
    
    func setIndex(index: Int) {
        collectionView?.tag = index
        collectionView?.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { collectionView?.contentOffset.x = newValue }
        get { return collectionView?.contentOffset.x ?? 0 }
    }
}
