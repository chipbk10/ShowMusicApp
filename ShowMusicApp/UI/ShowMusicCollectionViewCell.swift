//
//  ShowMusicCollectionViewCell.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/27/21.
//

import UIKit

class ShowMusicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ShowMusicCollectionViewCell"
    let holderImageName: String = "questionmark.circle"
    
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var imageView: UIImageView?
}

extension ShowMusicCollectionViewCell {
    
    func setTitle(title: String) {
        titleLabel?.text = title
    }
    
    func setImageView(image: UIImage?) {
        imageView?.image = image ?? UIImage(systemName: holderImageName)                            
    }
}
