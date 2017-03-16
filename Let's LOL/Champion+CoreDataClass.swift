//
//  Champion+CoreDataClass.swift
//  Let's LOL
//
//  Created by xiongmingjing on 10/03/2017.
//  Copyright © 2017 xiongmingjing. All rights reserved.
//

import Foundation
import CoreData

@objc(Champion)
public class Champion: NSManagedObject {

    convenience init(id: Int, title: String, name: String, tags: String, image: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Champion", in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = Int32(id)
            self.title = title
            self.name = name
            self.tags = tags
            self.image = image
        } else {
            fatalError("Cannot find Champion entity")
        }
    }
}
