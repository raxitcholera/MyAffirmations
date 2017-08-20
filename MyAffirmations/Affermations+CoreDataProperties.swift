//
//  Affermations+CoreDataProperties.swift
//  MyAffirmations
//
//  Created by Raxit Cholera on 8/20/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import Foundation
import CoreData


extension Affermations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Affermations> {
        return NSFetchRequest<Affermations>(entityName: "Affermations")
    }

    @NSManaged public var audiofile: NSData?
    @NSManaged public var createdon: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var text: String?

}
