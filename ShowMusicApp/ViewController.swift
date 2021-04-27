//
//  ViewController.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/26/21.
//

import UIKit

class ShowMusicViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Playlist Title"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"MyTableViewCell", for: indexPath)
        cell.contentView.backgroundColor = .clear
        return cell
    }
}

extension ShowMusicViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath)
        return cell
    }
}
