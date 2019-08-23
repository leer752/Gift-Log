//
//  ContactTableViewController.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/21/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit
import Contacts

class ContactTableViewController: UITableViewController {
    
    // MARK: Properties

    var contacts = [Contact]()
    
    var names: [String:Array<Contact>] = ["A": [], "B": [], "C": [], "D": [], "E": [], "F": [], "G": [],
                                    "H": [], "I": [], "J": [], "K": [], "L": [], "M": [], "N": [],
                                    "O": [], "P": [], "Q": [], "R": [], "S": [], "T": [], "U": [],
                                    "V": [], "W": [], "X": [], "Y": [], "Z": []]
    
    var letterNumberIndex: [Int:String] = [0: "A", 1: "B", 2: "C", 3: "D", 4: "E", 5: "F", 6: "G", 7: "H", 8: "I", 9: "J", 10: "K",
                          11: "L", 12: "M", 13: "N", 14: "O", 15: "P", 16: "Q", 17: "R", 18: "S", 19: "T", 20: "U", 21: "V",
                          22: "W", 23: "X", 24: "Y", 25: "Z"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Try to import contacts; if none, load sample data for contacts.
        fetchContacts()
        
        if contacts.isEmpty {
            loadSampleContacts()
        }
        
        // Sort contacts into the correct letter key in the names dictionary.
        sortContacts()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        guard let sectionLetter = letterNumberIndex[section] else {
            fatalError("Failed to instantiate sectionLetter")
        }
        guard let activeSection = names[sectionLetter] else {
            fatalError("Failed to instantiate activeSection")
        }
        if !activeSection.isEmpty {
            label.text = sectionLetter } else {
            return nil }
        label.backgroundColor = UIColor.lightGray
        label.textColor = UIColor.white
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionLetter = letterNumberIndex[section] else {
            fatalError("Failed to instantiate sectionLetter")
        }
        guard let activeSection = names[sectionLetter] else {
            fatalError("Failed to instantiate activeSection")
        }
        if !activeSection.isEmpty {
            return 30.0 } else {
            return 0.0 }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionLetter = letterNumberIndex[section] else {
            fatalError("Failed to instantiate sectionLetter")
        }
        guard let activeSection = names[sectionLetter] else {
            fatalError("Failed to instantiate activeSection")
        }
        if !activeSection.isEmpty {
            return activeSection.count } else {
            return 0 }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ContactTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContactTableViewCell else {
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        // Fetches the appropriate contact for the data source layout.
        guard let sectionLetter = letterNumberIndex[indexPath.section] else {
            fatalError("Failed to instantiate sectionLetter")
        }
        guard let activeSection = names[sectionLetter] else {
            fatalError("Failed to instantiate activeSection")
        }

        let contact = activeSection[indexPath.row]
        
        // Configure the cell.
        cell.contactNameLabel.text = contact.contactName
        cell.giftTotalLabel.text = "1"
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "ContactShowDetail":
            guard let giftListViewController = segue.destination as? GiftTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedContactCell = sender as? ContactTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedContactCell) else {
                fatalError("The selected cell is not being displayed by the table.")
            }
            
            guard let sectionLetter = letterNumberIndex[indexPath.section] else {
                fatalError("Failed to instantiate sectionLetter")
            }
            guard let activeSection = names[sectionLetter] else {
                fatalError("Failed to instantiate activeSection")
            }
            
            let selectedContact = activeSection[indexPath.row]
            
            giftListViewController.contact = selectedContact
            
        default:
            fatalError("Unexpected Segue Identifier: \(String(describing: segue.identifier))")
        }
    }

    
    
    // Drafted function meant to import contacts.
    
    private func fetchContacts() {
        print("Attempting to fetch contacts.")
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access: \(err)")
                return
            }
            
            if granted {
                print("Access granted.")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactIdentifierKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (importedContact, stopPointerIfYouWantToStopEnumerating) in
                        
                        if importedContact.familyName.isEmpty {
                            guard let contact = Contact(contactName: importedContact.givenName, lastName: importedContact.givenName, uniqueID: importedContact.identifier) else {
                                fatalError("Failed to initialize imported contact details.")
                            }
                            self.contacts.append(contact)
                        } else {
                            guard let contact = Contact(contactName: importedContact.givenName + " " + importedContact.familyName, lastName: importedContact.familyName, uniqueID: importedContact.identifier) else {
                                fatalError("Failed to initialize imported contact details.")
                            }
                            self.contacts.append(contact)
                        }
                        
                    })
                    
                } catch let err {
                    print("Failed to enumerate contacts: \(err)")
                }

            } else {
                print("Access denied.")
            }
 
        }
    }
    
    
    // MARK: Private methods.
    
    private func loadSampleContacts() {
        
        guard let contact1 = Contact(contactName: "Johnny Appleseed", lastName: "Appleseed", uniqueID: "JA44392") else {
            fatalError("Unable to instantiate contact1")
        }
        
        guard let contact2 = Contact(contactName: "Holly Hopeful", lastName: "Hopeful", uniqueID: "HH385893") else {
            fatalError("Unable to instantiate contact2")
        }
        
        guard let contact3 = Contact(contactName: "Debbie Downer", lastName: "Downer", uniqueID: "DD389") else {
            fatalError("Unable to instantiate contact3")
        }
        
        contacts += [contact1, contact2, contact3]
    }
    
    private func sortContacts() {
        for (key, _) in names {
            for entry in contacts {
                if key.prefix(1) == entry.lastName.prefix(1) {
                    names[key, default: []].append(entry)
                }
            }
        }
    }
    
}
