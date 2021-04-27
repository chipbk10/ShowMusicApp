//
//  ShowMusicViewController+UITableViewDataSource.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/27/21.
//

import UIKit

// UITableViewDataSource
extension ShowMusicViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.getPlaylistTitle(atIndex: section) ?? ""
    }
         
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.getNumberOfPlaylists() ?? 0
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:ShowMusicTableViewCell.identifier,
                                                 for: indexPath) as! ShowMusicTableViewCell        
        cell.setIndex(index: indexPath.section)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let cell = cell as? ShowMusicTableViewCell else { return }
        cell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let cell = cell as? ShowMusicTableViewCell else { return }
        storedOffsets[indexPath.row] = cell.collectionViewOffset
    }
}
