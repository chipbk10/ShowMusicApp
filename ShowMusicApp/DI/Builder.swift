//
//  Builder.swift
//  ShowMusicApp
//
//  Created by Hieu Luong on 4/27/21.
//

import UIKit

class Builder {
    
    private let endpoint = "https://hes75mx2r3.execute-api.eu-central-1.amazonaws.com/prod/library"
    private let cacheCountLimit = 50
    
    // image
    private lazy var imageProvider: IImageProvider = ImageProvider()
    private lazy var cachedImageProvider: IImageProvider = CachedImageProvider(limit: cacheCountLimit, imageProvider: imageProvider)
    
    // music data
    private lazy var musicDataParser: IMusicDataParser = MusicDataParser()
    private lazy var musicDataProvider: IMusicDataProvider = MusicDataProvider(endpoint: endpoint, parser: musicDataParser)
    
    // viewmodel
    private lazy var showMusicViewModel: IShowMusicViewModel = ShowMusicViewModel(musicDataProvider: musicDataProvider, imageProvider: cachedImageProvider)
    
    
    func build(window: UIWindow?) {
        guard let viewController = window?.rootViewController as? ShowMusicViewController else { return }
        viewController.viewModel = showMusicViewModel
    }
}
