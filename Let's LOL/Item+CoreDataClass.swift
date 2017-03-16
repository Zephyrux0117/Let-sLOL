//
//  Item+CoreDataClass.swift
//  Let's LOL
//
//  Created by xiongmingjing on 15/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

    convenience init(id: Int, name: String, desc: String, gold: Int, tags: String, image: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Item", in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = Int32(id)
            self.name = name
            self.desc = desc
            self.gold = Int32(gold)
            self.tags = tags
            self.image = image
        } else {
            fatalError("Cannot find Item entity")
        }
    }
}
