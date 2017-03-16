//
//  Constant.swift
//  Let's LOL
//
//  Created by xiongmingjing on 07/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import Foundation

struct Constant {
//    http://ddragon.leagueoflegends.com/cdn/img/champion/loading/Aatrox_0.jpg

    static let StaticDataPath = "https://global.api.pvp.net/api/lol/static-data/na/v1.2"
    static let DefaultRealmPath = "http://ddragon.leagueoflegends.com/cdn/7.4.3"
    static let ChampionImagePath = "/img/champion/"
    static let ItemImagePath = "/img/item/"
    static let SplashPath = "http://ddragon.leagueoflegends.com/cdn/img/champion/splash/"

    struct Method {
        static let Realm = "/realm"
        static let Champion = "/champion"
        static let Item = "/item"
    }

    struct RequestKey {
        static let APIKey = "api_key"
        static let ChampData = "champData"
        static let ItemListData = "itemListData"
    }

    struct RequestValue {
        static let APIKey = "RGAPI-8d420a78-b359-4563-b98b-6959db166ec3"
        static let ChampDataAll = "image,tags"
        static let ChampDataOne = "allytips,blurb,enemytips,skins"
        static let ItemListData = "gold,image,tags"
    }

    struct ResponseKey {
        static let Status = "status"
        static let Message = "message"
        static let Version = "v"
        static let Cdn = "cdn"
        static let Data = "data"
        static let Id = "id"
        static let Title = "title"
        static let Name = "name"
        static let Tags = "tags"
        static let Image = "image"
        static let Full = "full"
        static let Blurb = "blurb"
        static let AllyTips = "allytips"
        static let EnemyTips = "enemytips"
        static let Skins = "skins"
        static let Description = "plaintext"
        static let Gold = "gold"
        static let GoldTotal = "total"
    }

    static let UnknownError = "Unknown error."
}
