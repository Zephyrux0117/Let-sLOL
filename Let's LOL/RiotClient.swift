//
//  RiotClient.swift
//  Let's LOL
//
//  Created by xiongmingjing on 07/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RiotClient {

    static let shared = RiotClient()

    func getRealmUrl(completionHandler: @escaping (_ url: String) -> Void) {

        Alamofire.request(Constant.StaticDataPath + Constant.Method.Realm, parameters: [Constant.RequestKey.APIKey: Constant.RequestValue.APIKey])
                .response { response in
                    if let data = response.data, let realm = JSON(data).dictionary {
                        if let cdn = realm[Constant.ResponseKey.Cdn]?.string, let version = realm[Constant.ResponseKey.Version]?.string {
                            completionHandler("\(cdn)/\(version)")
                            return
                        }
                    }
                    completionHandler(Constant.DefaultRealmPath)
                }
    }

    func getChampions(completionHandler: @escaping (_ champions: [String: JSON]?, _ error: String?) -> Void) {

        Alamofire.request(Constant.StaticDataPath + Constant.Method.Champion,
                        parameters: [Constant.RequestKey.APIKey: Constant.RequestValue.APIKey, Constant.RequestKey.ChampData: Constant.RequestValue.ChampDataAll])
                .response { response in

                    if let error = response.error {
                        completionHandler(nil, error.localizedDescription)
                    } else if let data = response.data {
                        if let champions = JSON(data)[Constant.ResponseKey.Data].dictionary {
                            completionHandler(champions, nil)
                        } else {
                            completionHandler(nil, JSON(data)[Constant.ResponseKey.Data].error?.localizedDescription ?? Constant.UnknownError)
                        }
                    }
                }
    }

    func getDetailInfo(_ championId: Int, completionHandler: @escaping (_ result: [String: JSON]?, _ error: String?) -> Void) {

        Alamofire.request(Constant.StaticDataPath + Constant.Method.Champion + "/\(championId)",
                        parameters: [Constant.RequestKey.APIKey: Constant.RequestValue.APIKey, Constant.RequestKey.ChampData: Constant.RequestValue.ChampDataOne])
                .response { response in

                    if let error = response.error {
                        completionHandler(nil, error.localizedDescription)
                    } else if let data = response.data {
                        if let champion = JSON(data).dictionary {
                            if champion[Constant.ResponseKey.Id] != nil {
                                completionHandler(champion, nil)
                            } else {
                                completionHandler(nil, champion[Constant.ResponseKey.Status]?[Constant.ResponseKey.Message].string ?? Constant.UnknownError)
                            }
                        }
                    }
                }
    }

    func getItems(completionHandler: @escaping (_ items: [String: JSON]?, _ error: String?) -> Void) {

        Alamofire.request(Constant.StaticDataPath + Constant.Method.Item,
                        parameters: [Constant.RequestKey.APIKey: Constant.RequestValue.APIKey, Constant.RequestKey.ItemListData: Constant.RequestValue.ItemListData])
                .response { response in

                    if let error = response.error {
                        completionHandler(nil, error.localizedDescription)
                    } else if let data = response.data {
                        if let items = JSON(data)[Constant.ResponseKey.Data].dictionary {
                            completionHandler(items, nil)
                        } else {
                            completionHandler(nil, JSON(data)[Constant.ResponseKey.Data].error?.localizedDescription ?? Constant.UnknownError)
                        }
                    }
                }
    }
}
