//
//  GiftTableViewController.swift
//  Gift Log
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
    
    // Passed by previous view controller.
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load any saved gifts, otherwise load sample data.
        let savedGifts = loadGifts()
        
        if savedGifts?.count ?? 0 > 0 {
            gifts = savedGifts ?? [Gift]()
        } else {
            loadSampleGifts()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GiftTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GiftTableViewCell else {
            fatalError("The dequeued cell is not an instance of GiftTableViewCell.")
        }
        
        // Fetches the appropriate gift for the data source layout.
        let gift = gifts[indexPath.row]
        
        // Configure the cell.
        cell.nameLabel.text = gift.name
        cell.giftImageView.image = gift.photo
        cell.priorityControl.priority = gift.priority
        cell.priceLabel.text = String(format: "$%.2f", gift.price.floatValue)
        
        return cell
    }
    

    // Support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            gifts.remove(at: indexPath.row)
            saveGifts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    @IBAction func unwindToGiftList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GiftViewController, let gift = sourceViewController.gift {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing gift.
                gifts[selectedIndexPath.row] = gift
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new gift.
                let newIndexPath = IndexPath(row: gifts.count, section: 0)
                gifts.append(gift)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the gifts.
            saveGifts()
        }
    }

    // MARK: Private methods
    
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
    
    private func saveGifts() {
        let fullPath = getDocumentsDirectory().appendingPathComponent("gifts")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: gifts, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("Gifts successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save gifts.", log: OSLog.default, type: .debug)
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadGifts() -> [Gift]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("gifts")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing: nsData)
                if let loadedGifts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Gift> {
                    for gift in loadedGifts {
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
