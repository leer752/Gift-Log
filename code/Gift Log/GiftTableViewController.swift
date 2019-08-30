//
//  GiftTableViewController.swift
//  Gift Log
//
//  Description: View controller for the gift table list screen. Actions taken from this screen:
//                  - Load existing gifts.
//                  - Deleting specific gifts.
//                  - Navigating to existing gift for edits.
//                  - Navigating to new gift screen to add a gift.
//
//  Created by Lee Rhodes on 8/16/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit
import os.log

class GiftTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var gifts = [Gift]()
    var filteredGifts = [Gift]()
    var allGifts = [Gift]()
    var giftsWithRemoval = [Gift]()
    
    // Passed by previous view controller.
    var contact: Contact?

    // Actions to take when view successfully loads:
    //  - Load any saved gifts.
    //  - If no saved gifts, load sample data.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedGifts = loadGifts()
        
        if savedGifts?.count ?? 0 > 0 {
            gifts = savedGifts ?? [Gift]()
        } else {
            loadSampleGifts()
        }
    
    }

    // MARK: - Table view data source

    // Returns 1 section as gifts do not need to be sorted into different sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // Returns the number of rows in the section.
    // This is equal to the number of registered gifts for the specified contact.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }

    // Configures cell layout.
    // Table view cells are reused and should be dequeued using a cell identifier.
    // Fetches the appropriate gift for the data source layout and configures the cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GiftTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GiftTableViewCell else {
            fatalError("The dequeued cell is not an instance of GiftTableViewCell.")
        }
        
        let gift = gifts[indexPath.row]
        
        cell.nameLabel.text = gift.name
        cell.giftImageView.image = gift.photo
        cell.priorityControl.priority = gift.priority
        cell.priceLabel.text = String(format: "$%.2f", gift.price.floatValue)
        
        return cell
    }
    

    // Support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    // Support editing the table view.
    // Allows use to slide cell to the left in order to delete it from the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedGift = gifts[indexPath.row]
            gifts.remove(at: indexPath.row)
            giftsWithRemoval = allGifts.filter { $0 != deletedGift }
            allGifts = giftsWithRemoval
            saveGifts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Insert style is not used and is therefore empty.
        }    
    }
    
    // MARK: - Navigation

    // Preparing view controller before navigation commences.
    // Different actions will take place depending on if the user is editing an existing gift or adding a new one.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddGift":
            os_log("Adding a new gift.", log: OSLog.default, type: .debug)
            guard let navigationViewController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let giftDetailViewController = navigationViewController.viewControllers.first as? GiftViewController else {
                fatalError("Unexpected first view controller.")
            }
            giftDetailViewController.activeID = contact?.uniqueID
            
        case "ShowDetail":
            guard let giftDetailViewController = segue.destination as? GiftViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedGiftCell = sender as? GiftTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedGiftCell) else {
                fatalError("The selected cell is not being displayed by the table.")
            }
            
            let selectedGift = gifts[indexPath.row]
            giftDetailViewController.gift = selectedGift
            giftDetailViewController.activeID = contact?.uniqueID
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }
    
    
    // MARK: Actions
    
    // Updates the table view display after a gift is edited or added.
    // Reloads table view display and saves gift changes to database.
    @IBAction func unwindToGiftList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GiftViewController, let gift = sourceViewController.gift {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                gifts[selectedIndexPath.row] = gift
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: gifts.count, section: 0)
                gifts.append(gift)
                allGifts.append(gift)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveGifts()
        }
    }

    // MARK: Private methods
    
    // Load sample gift data if no gifts were found.
    private func loadSampleGifts() {
        let photo1 = UIImage(named: "gift1")
        let photo2 = UIImage(named: "gift2")
        let photo3 = UIImage(named: "gift3")
        
        guard let gift1 = Gift(photo: photo1, name: "Nintendo Switch Lite Yellow", store: "Best Buy", address: "N/A", cityState: "N/A", url: "https://www.bestbuy.com/site/nintendo-switch-lite-yellow/6257142.p?skuId=6257142", price: "199.99", date: "8/13/2019", itemCode: "N/A", priority: 3, contactID: "JA44392") else {
            fatalError("Unable to instantiate gift1")
        }
        
        guard let gift2 = Gift(photo: photo2, name: "Terriermon plush", store: "Anime Pop", address: "5775 Airport Blvd ste 725c", cityState: "Austin, TX", url: "N/A", price: "34.99", date: "05/30/2019", itemCode: "N/A", priority: 2, contactID: "HH385893") else {
            fatalError("Unable to instantiate gift2")
        }
        
        guard let gift3 = Gift(photo: photo3, name: "Volleyball", store: "Academy", address: "N/A", cityState: "N/A", url: "https://www.academy.com/shop/pdp/molten-flistatec-indoor-volleyball#repChildCatid=5367503", price: "54.99", date: "01/20/2018", itemCode: "115996776", priority: 1, contactID: "DD389") else {
            fatalError("Unable to instantiate gift3")
        }
        
        guard let activeID = contact?.uniqueID else {
            fatalError("Unable to instantiate activeID")
        }
        
        if gift1.contactID == activeID {
            gifts.append(gift1)
        }
        if gift2.contactID == activeID {
            gifts.append(gift2)
        }
        if gift3.contactID == activeID {
            gifts.append(gift3)
        }
    }
    
    // Update gift database after a gift is edited, added, or deleted.
    // Also sets up data to persist even when app is re-opened.
    private func saveGifts() {
        let fullPath = getDocumentsDirectory().appendingPathComponent("gifts")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: allGifts, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Gifts successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save gifts.", log: OSLog.default, type: .debug)
        }
    }
    
    // Get path to the documents directory that the application uses on the phone.
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Load gifts found in the documents directory on the phone; does not occur if no gifts found.
    private func loadGifts() -> [Gift]? {
        filteredGifts.removeAll()
        allGifts.removeAll()
        let fullPath = getDocumentsDirectory().appendingPathComponent("gifts")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing: nsData)
                if let loadedGifts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Gift> {
                    for gift in loadedGifts {
                        allGifts.append(gift)
                        guard let activeID = contact?.uniqueID else {
                            fatalError("Unable to instantiate activeID")
                        }
                        if activeID == gift.contactID {
                            filteredGifts.append(gift)
                        }
                    }
                    return filteredGifts
                }
            } catch {
                os_log("Couldn't read file.", log: OSLog.default, type: .debug)
                return nil
            }
        }
        return nil
    }
    
}
