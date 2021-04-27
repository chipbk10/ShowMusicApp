ShowMusic Code Challenge
---------

`ShowMusic` is a single-page application for displaying album playlists.

## API

The ShowMusic API provides a `/library` JSON endpoint at the URL:  
https://hes75mx2r3.execute-api.eu-central-1.amazonaws.com/prod/library


## Assignment
Create a single page application that downloads and displays the user's playlists. 

### Minimum Requirements
* The User Interface design should be horizontally scrollable rows of albums representing playlists. Playlists should scroll vertically. (mockup below). The title of the playlist should be above each row. There is an emphasis on good visual design, so the nicer it looks the better.
* The album art should be `150x150 pt` on the screen.
* The titles of each album appear underneath the albums.
* There are some minor logical errors in the JSON data. These should be treated appropriately.
* The provided solution can make use of UIKit and/or SwiftUI

## Mockup
![Mockup](./README/mockup.png)

## Misc
This exercise should not be incredibly complex or time consuming. If this was not the case, or the instructions were not clear, please provide feedback.

## Solution

### UICollectionView inside UITableViewCell
- Embed UICollectionView inside UITableViewCell to achieve the expected UI (horizontally scrollable albums && vertically scrollable playlists)
- Scroll from top bar down to refresh the data
- Show a loading indicator during loading time
- Show an Error alert if something wrong happens (due to networking failed, or invalid json, or bad request, etc.)

### Cache Images
- cache images for faster populating images in UICollectionViewCell
- caching policy: If the cache goes over the limit (set default value to 50 images), it may remove objects instantly

### Architecture
- Using `MVVM` for this demo app
- Project is organized into different components (UI, ViewModel, Services, Model, Utils, DI, etc.) 

### Simple helper functions
- `Box` to achieve simple `react`'s purpose (using getter && setter)
- `SwiftyJSON` to parse `JSON` in a convenient way
- `Builder` to achieve simple `Dependencies Injections`'s purpose

### Limitation
- During the time limitation, I skip the `unit-tests` part
- Each time navigate to the row (out of screen), we do `reloadData` of the `collectionView`. In the case, the `CollectionView` contains tons of cells, the performance will be decreased.

### How to deploy
```
git clone git@github.com:chipbk10/ShowMusicApp.git
cd ShowMusicApp
pod install
open ShowMusicApp.xcworkspace
```
