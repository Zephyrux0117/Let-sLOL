//
// Created by xiongmingjing on 09/03/2017.
// Copyright (c) 2017 xiongmingjing. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

enum ImgType {
    case image, splash
}

class DownloadHelper {

    static let shared = DownloadHelper()
    let riotClient = RiotClient.shared
    var imageUrlPrefix: String?

    func downloadInitData(completionHander: @escaping (_ error: String?)->Void) {

        riotClient.getChampions { champions, error in
            if let error = error {
                completionHander(error)
            }
            if let champions = champions {
                DispatchQueue.main.async {
                    for champion in champions {
                        if let id = champion.value[Constant.ResponseKey.Id].int,
                           let title = champion.value[Constant.ResponseKey.Title].string,
                           let name = champion.value[Constant.ResponseKey.Name].string,
                           let tags = champion.value[Constant.ResponseKey.Tags].array,
                           let image = champion.value[Constant.ResponseKey.Image][Constant.ResponseKey.Full].string {

                            var tagStr = tags[0].string!
                            if tags.count > 1 {
                                for i in 1 ... tags.count - 1 {
                                    tagStr = tagStr + ", " + tags[i].string!
                                }
                            }
                            _ = Champion(id: id, title: title, name: name, tags: tagStr, image: image, context: self.getStack().context)
                        }
                    }
                    self.getStack().save()
                }
            }
        }
    }

    func downloadAndSaveImage(_ champion: Champion) {
        if champion.imageData == nil, let imageTitle = champion.image {
            if let prefix = imageUrlPrefix {
                let url = prefix + Constant.ChampionImagePath + imageTitle
                saveImg(url, .image, champion) { champion in
                }
            } else {
                riotClient.getRealmUrl {
                    self.imageUrlPrefix = $0
                    self.saveImg($0 + Constant.ChampionImagePath + imageTitle, .image, champion) { champion in
                    }
                }
            }
        }
    }

    func downloadAndSaveSplash(_ champion: Champion, completionHandler: @escaping (_ champion: Champion?, _ error: String?) -> Void) {
        if champion.splashData == nil {
            let url = "\(Constant.SplashPath)\(champion.name!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))_0.jpg"
            saveImg(url, .splash, champion) { champion in
                completionHandler(champion, nil)
            }
        }
    }

    func downloadAndSaveDetailInfo(_ champion: Champion, completionHandler: @escaping (_ champion: Champion?, _ error: String?) -> Void) {

        riotClient.getDetailInfo(Int(champion.id)) { (result, error) in
            if let error = error {
                completionHandler(nil, error.localizedCapitalized)
            }
            if let result = result {
                if let blurb = result[Constant.ResponseKey.Blurb]?.string {
                    champion.blurb = blurb.replacingOccurrences(of: "<br>", with: "\n")
                }
                if let allyTips = result[Constant.ResponseKey.AllyTips]?.array {
                    champion.allyTips = self.arrToStr(allyTips)
                }
                if let enemyTips = result[Constant.ResponseKey.EnemyTips]?.array {
                    champion.enemyTips = self.arrToStr(enemyTips)
                }
//                if let skins = result[Constant.ResponseKey.Skins]?.array {
//                    
//                }

                DispatchQueue.main.async {
                    self.getStack().save()
                    completionHandler(champion, nil)
                }
            }
        }
    }

    private func arrToStr(_ arr: [JSON]) -> String {
        var str = "  ✦ \(arr[0].rawString()!)"
        if arr.count > 1 {
            for i in 1 ... arr.count - 1 {
                str = "\(str)\n  ✦ \(arr[i].rawString()!)"
            }
        }
        return str
    }

    private func saveImg(_ url: String, _ type: ImgType, _ champion: Champion, completionHandler: @escaping (_ champion: Champion) -> Void) {

        Alamofire.request(url).response { response in
                    if let data = response.data {
                        DispatchQueue.main.async {
                            switch type {
                            case .image:
                                champion.imageData = data as NSData?
                            case .splash:
                                champion.splashData = data as NSData?
                            }
                            self.getStack().save()
                            completionHandler(champion)
                        }
                    }
                }
    }

    func initItemData(completionHander: @escaping (_ error: String?)->Void) {

        riotClient.getItems { items, error in
            if let error = error {
                completionHander(error)
            }
            if let items = items {
                DispatchQueue.main.async {
                    for item in items {
                        if let id = item.value[Constant.ResponseKey.Id].int,
                           let desc = item.value[Constant.ResponseKey.Description].string,
                           let name = item.value[Constant.ResponseKey.Name].string,
                           let gold = item.value[Constant.ResponseKey.Gold][Constant.ResponseKey.GoldTotal].int,
                           let tags = item.value[Constant.ResponseKey.Tags].array,
                           let image = item.value[Constant.ResponseKey.Image][Constant.ResponseKey.Full].string {

                            var tagStr = tags[0].string!
                            if tags.count > 1 {
                                for i in 1 ... tags.count - 1 {
                                    tagStr = tagStr + ", " + tags[i].string!
                                }
                            }
                            _ = Item(id: id, name: name, desc: desc, gold: gold, tags: tagStr, image: image, context: self.getStack().context)
                        }
                    }
                    self.getStack().save()
                }
            }
        }
    }

    func downloadAndSaveItemImage(_ item: Item) {
        if item.imageData == nil, let imageTitle = item.image {
            if let prefix = imageUrlPrefix {
                let url = prefix + Constant.ItemImagePath + imageTitle
                saveItemImage(url, item)
            } else {
                riotClient.getRealmUrl {
                    self.imageUrlPrefix = $0
                    self.saveItemImage($0 + Constant.ItemImagePath + imageTitle, item)
                }
            }
        }
    }

    private func saveItemImage(_ url: String, _ item: Item) {

        Alamofire.request(url).response { response in
                    if let data = response.data {
                        DispatchQueue.main.async {
                            item.imageData = data as NSData?

                            self.getStack().save()

                        }
                    }
                }
    }

    func getStack() -> CoreDataStack {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.stack
    }
}
