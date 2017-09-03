//
//  CoreDataManager.swift
//  MyAffirmations
//
//  Created by Raxit Cholera on 9/3/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataManagerDelegate: NSObjectProtocol
{
    func refreshView()
}

class CoreDataManager: NSObject {
    
    static let sharedManager = CoreDataManager()
    
    weak var delegate: CoreDataManagerDelegate?
    
    override private init()
    {
        super.init()
    }
    
    func addAffermation(dictionary: [String:Any])
    {
        _ = Affermations(dictionary: dictionary, context: dbStack.context)
        dbStack.save()
    }
    func updateAffermation(selectedAffermation:Affermations,dictionary: [String:Any])
    {
        selectedAffermation.setValue(dictionary["audiofile"], forKey: "audiofile")
        selectedAffermation.setValue(dictionary["name"], forKey: "name")
        selectedAffermation.setValue(NSDate(), forKey: "createdon")
        dbStack.save()
    }
    func deleteAffermation(selectedAffermation:Affermations)
    {
        dbStack.context.delete(selectedAffermation)
        dbStack.save()
    }
    

}
