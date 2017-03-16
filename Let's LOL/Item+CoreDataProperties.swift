//
//  Item+CoreDataProperties.swift
//  Let's LOL
//
//  Created by xiongmingjing on 15/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var id: Int32
    @NSManaged public var image: String?
    @NSManaged public var imageData: NSData?
    @NSManaged public var desc: String?
    @NSManaged public var tags: String?
    @NSManaged public var gold: Int32
    @NSManaged public var name: String?

}
