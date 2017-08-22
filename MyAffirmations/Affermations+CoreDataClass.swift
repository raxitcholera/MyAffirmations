//
//  Affermations+CoreDataClass.swift
//  MyAffirmations
//
//  Created by Raxit Cholera on 8/21/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


public class Affermations: NSManagedObject {
    convenience init(dictionary: [String:Any], context: NSManagedObjectContext)
    {
        if let ent = NSEntityDescription.entity(forEntityName: "Affermations", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.name = dictionary["name"] as? String ?? ""
            self.text = dictionary["text"] as? String ?? ""
            self.createdon = NSDate()
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
}
