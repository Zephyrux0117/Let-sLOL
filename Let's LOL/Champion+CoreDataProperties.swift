//
//  Champion+CoreDataProperties.swift
//  Let's LOL
//
//  Created by xiongmingjing on 16/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import Foundation
import CoreData


extension Champion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Champion> {
        return NSFetchRequest<Champion>(entityName: "Champion");
    }

    @NSManaged public var allyTips: String?
    @NSManaged public var blurb: String?
    @NSManaged public var enemyTips: String?
    @NSManaged public var id: Int32
    @NSManaged public var image: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var name: String?
    @NSManaged public var splash: String?
    @NSManaged public var splashData: NSData?
    @NSManaged public var tags: String?
    @NSManaged public var title: String?

}
