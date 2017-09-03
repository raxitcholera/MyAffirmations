//
//  AffermationsTableViewController.swift
//  MyAffirmations
//
//  Created by Raxit Cholera on 8/14/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit
import CoreData

class AffermationsTableViewController: UIViewController {

    var allAffermations:[Affermations]!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshView()
    }

    func refreshView()
    {
        let request:NSFetchRequest<Affermations> = Affermations.fetchRequest()
        do {
            allAffermations = try dbStack.context.fetch(request)
        }catch {
            print("No records found")
        }
        performOnMainthread {
            self.tableView.reloadData()
        }
    }


}


extension AffermationsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if selectedAffermation.audiofile?.length != 0 {
            let controller = storyboard!.instantiateViewController(withIdentifier: "PlayAudioViewController") as! PlayAudioViewController
            controller.selectedAffermation = selectedAffermation
            performOnMainthread {
                self.navigationController!.pushViewController(controller, animated: true)
            }
        } else {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "RecordSoundsViewController") as! RecordSoundsViewController
            controller.selectedAffermation = selectedAffermation
            performOnMainthread {
                self.navigationController!.pushViewController(controller, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Can add more features like share to the row here
        let selectedAffermation = self.allAffermations[(indexPath as NSIndexPath).row]
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "RecordSoundsViewController") as! RecordSoundsViewController
            controller.selectedAffermation = selectedAffermation
            performOnMainthread {
                self.navigationController!.pushViewController(controller, animated: true)
            }
        }
        edit.backgroundColor = .purple
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            CoreDataManager.sharedManager.deleteAffermation(selectedAffermation: selectedAffermation)
            self.refreshView()
        }
        delete.backgroundColor = .red
        return [delete,edit]
    }
}


