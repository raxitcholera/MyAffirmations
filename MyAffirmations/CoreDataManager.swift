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
    

}
