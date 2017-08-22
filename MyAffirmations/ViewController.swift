//
//  ViewController.swift
//  MyAffirmations
//
//  Created by Raxit Cholera on 8/14/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var allAffermations:[Affermations]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let request:NSFetchRequest<Affermations> = Affermations.fetchRequest()
        do {
            allAffermations = try dbStack.context.fetch(request)
        }catch {
            print("No records found")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellReuseId = "Cell"
        let affermation = allAffermations[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId) as UITableViewCell!
        
        cell?.textLabel?.text = affermation.name
//        cell?.detailTextLabel?.text = ticker.ticker
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAffermations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAffermation = allAffermations[(indexPath as NSIndexPath).row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "PlayAudioViewController") as! PlayAudioViewController
        controller.selectedAffermation = selectedAffermation
        performOnMainthread {
            self.navigationController!.pushViewController(controller, animated: true)
        }
        
    }
}


