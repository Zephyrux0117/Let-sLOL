## Let's LOL

### Build
Xcode 8.2.1 & Swift 3.0

### Function
This app can display champion and item information of the game "League of Legends".
Champion view shows champions table view, and can search by names. Click champion to show the detail view which contain champion image and some tips.
Item view shows item image in collection view, click the item can show alertview of the item information.

### Feature
- Use Riot API to download data
- Use UISearchController, xib file
- Use Attribute Strings in UIAlertController
- Use SwiftyJSON and Alamofire framework


### Known Bugs
- Because Riot API does not provide backgroud picture directly, some champion's picture url may not accurate, so there are some detail image views show blank
