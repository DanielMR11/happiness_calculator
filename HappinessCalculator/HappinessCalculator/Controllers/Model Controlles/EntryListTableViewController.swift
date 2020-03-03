//
//  EntryListTableViewController.swift
//  NotificationPatternsJournal
//
//  Created by Daniel Merchan Rico on 3/3/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit
//Creating a notification Key that we can call from anywhere, also known as a global property
let notificationKey = Notification.Name(rawValue: "didChangeHappinnes")

class EntryListTableViewController: UITableViewController {
    
    var averageHappiness: Int = 0 {
        //Propertie Observer
        didSet {
            //Shouting out that we just updated our average happiness 
            NotificationCenter.default.post(name: notificationKey, object: self.averageHappiness)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return EntryController.entries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? EntryCellTableViewCell else
        {return UITableViewCell()}
        let entry = EntryController.entries[indexPath.row]
        cell.setEntry(entry: entry, avergeHappiness: 0)
        
        //Telling Our runner who should give task to
        cell.delegate = self
        
        // Configure the cell...
        
        return cell
    }
    
    func updatAverageHappiness() {
        var totalHappiness = 0
        for entry in EntryController.entries {
            if entry.isIncluded {
                totalHappiness += entry.happiness
            }
        }
        averageHappiness = totalHappiness / EntryController.entries.count
    }

}// End Of Class

//Creating our intern that will do stuff
extension EntryListTableViewController: EntryTableViewCellDelegate {
    //Creating the directions for what to do when our intern is told to do something
    func switchToggledOnCell(cell: EntryCellTableViewCell) {
        guard let entry = cell.entry else {return}
        EntryController.updateEntry(entry: entry)
        updatAverageHappiness()
        cell.updateUI(averageHappiness: averageHappiness)
    }
}
