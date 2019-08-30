//
//  ContactTableViewController.swift
//  Gift Log
//
//  Description: View controller for the contact list screen. Actions taken from this screen:
//          - Import existing contacts from address book on phone.
//          - Navigate to a gift list for specified contact.
//          - Search for contact by name via a search bar.
//
//  Created by Lee Rhodes on 8/21/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit
import Contacts
import os.log

class ContactTableViewController: UITableViewController {
    
    // MARK: Properties

    var contacts = [Contact]()
    var searchedNames = [Contact]()
    var allGifts = [Gift]()
    
    // Alphabetical array that contacts will be sorted into; each letter will be a section header.
    var names: [String:Array<Contact>] = ["A": [], "B": [], "C": [], "D": [], "E": [], "F": [], "G": [],
                                    "H": [], "I": [], "J": [], "K": [], "L": [], "M": [], "N": [],
                                    "O": [], "P": [], "Q": [], "R": [], "S": [], "T": [], "U": [],
                                    "V": [], "W": [], "X": [], "Y": [], "Z": []]
    
    // Match index number to specified letter.
    var letterNumberIndex: [Int:String] = [0: "A", 1: "B", 2: "C", 3: "D", 4: "E", 5: "F", 6: "G", 7: "H", 8: "I", 9: "J", 10: "K",
                          11: "L", 12: "M", 13: "N", 14: "O", 15: "P", 16: "Q", 17: "R", 18: "S", 19: "T", 20: "U", 21: "V",
                          22: "W", 23: "X", 24: "Y", 25: "Z"]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let contactRefreshControl = UIRefreshControl()
    
    // Actions to take when view successfully loads:
    //  - Import contacts.
    //  - If no contacts, load sample data.
    //  - Sort contacts into the correct letter key in the names dictionary.
    //  - Assign gift count to contact.
    //  - Enable pull-to-refresh functionality for phones with iOS 10.0+.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = contactRefreshControl
        } else {
            tableView.addSubview(contactRefreshControl)
        }
        enableRefresh()
        
        fetchContacts()
        
        if contacts.isEmpty {
            loadSampleContacts()
        }
        
        sortContacts(selectedContacts: contacts)
        
        countGifts()
    }
    
    // Configure section headers for table.
    // Display section letter only if that section has contacts.
    // If section has no contacts, the letter will not be displayed; the section will be "hidden".
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
    
    // Configure height for section headers.
    // If section has no contacts, section header height will be 0. 
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

    // Returns the number of sections that will be displayed in the table view.
    // This should be equal to how many letters are in the alphabet (26).
    // The dictionary created for names has 26 keys for the alphabet so it can be used.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
    }
    
    // Returns number of rows for each section.
    // This changes depending on the section and how many contacts start with that section's letter.
    // I.e. if there are two "A" names, the first section will have 2 rows.
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
    
    
    // Configures cell layout.
    // Table view cells are reused and should be dequeued using a cell identifier.
    // Fetches the appropriate contact for the data source layout and configures the cell.
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
        if contact.giftCount <= 0 {
            cell.giftTotalLabel.text = nil
        } else {
            cell.giftTotalLabel.text = "\(contact.giftCount)"
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // Preparing view controller before navigation commences.
    // The function needs to send the selected contact to the gift list view so it can fetch the appropriate gift list.
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

    // Function prompts for access to the external contact book.
    // If granted, grabs each contact's given name, family name, and unique identifier key.
    // It then constructs a Contact instance for each contact imported that the program can use.
    private func fetchContacts() {
        print("Attempting to import contacts.")
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("Failed to request access: \(error)")
                return
            }
            
            if granted {
                print("Access granted.")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactIdentifierKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (importedContact, stopPointerIfYouWantToStopEnumerating) in
                        
                        if importedContact.familyName.isEmpty {
                            guard let contact = Contact(contactName: importedContact.givenName, lastName: importedContact.givenName, uniqueID: importedContact.identifier, giftCount: 0) else {
                                fatalError("Failed to initialize imported contact details.")
                            }
                            self.contacts.append(contact)
                        } else {
                            guard let contact = Contact(contactName: importedContact.givenName + " " + importedContact.familyName, lastName: importedContact.familyName, uniqueID: importedContact.identifier, giftCount: 0) else {
                                fatalError("Failed to initialize imported contact details.")
                            }
                            self.contacts.append(contact)
                        }
                        
                    })
                    
                } catch let error {
                    print("Failed to enumerate contacts: \(error)")
                }

            } else {
                print("Access denied.")
            }
 
        }
    }
    
    
    // MARK: Private methods.
    
    // Enable pull-to-refresh of the contact list.
    private func enableRefresh() {
        contactRefreshControl.addTarget(self, action: #selector(refreshContacts(_:)), for: .valueChanged)
    }
    
    // Connects refreshing to Objective-C so that it will function properly.
    @objc private func refreshContacts(_ sender: Any?) {
        fetchContactData()
    }
    
    // Conducts the actual reloading of data. First, it needs to re-count the gifts to make sure it has the right number for each contact.
    private func fetchContactData() {
        countGifts()
        self.tableView.reloadData()
        contactRefreshControl.endRefreshing()
    }
    
    // If no contacts were imported, this loads the sample contacts for the application.
    private func loadSampleContacts() {
        guard let contact1 = Contact(contactName: "Johnny Appleseed", lastName: "Appleseed", uniqueID: "JA44392", giftCount: 1) else {
            fatalError("Unable to instantiate contact1")
        }
        
        guard let contact2 = Contact(contactName: "Holly Hopeful", lastName: "Hopeful", uniqueID: "HH385893", giftCount: 1) else {
            fatalError("Unable to instantiate contact2")
        }
        
        guard let contact3 = Contact(contactName: "Debbie Downer", lastName: "Downer", uniqueID: "DD389", giftCount: 1) else {
            fatalError("Unable to instantiate contact3")
        }
        
        contacts += [contact1, contact2, contact3]
    }
    
    // Appends all contacts to the alphabetized "names" dictionary.
    // Each contact is appended to the appropriate alphabet key-value pair.
    private func sortContacts(selectedContacts: [Contact]) {
        for (key, _) in names {
            names.updateValue([], forKey: key)
        }
        for (key, _) in names {
            for entry in selectedContacts {
                if key.prefix(1) == entry.lastName.prefix(1) {
                    names[key, default: []].append(entry)
                }
            }
        }
    }
    
    // Get path to the documents directory that the application uses on the phone.
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Load gifts found in the documents directory on the phone; does not occur if no gifts found.
    // Changes the giftCount for a given contact depending on how many gifts were found with the contact's unique identifier.
    // Does not return any gifts or gift lists.
    private func countGifts() {
        allGifts.removeAll()
        for entry in contacts {
            entry.giftCount = 0
        }
        
        let fullPath = getDocumentsDirectory().appendingPathComponent("gifts")
        
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                let data = Data(referencing: nsData)
                if let loadedGifts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Gift> {
                    for gift in loadedGifts {
                        allGifts.append(gift)
                        for entry in contacts {
                            if gift.contactID == entry.uniqueID {
                                entry.giftCount += 1
                            }
                        }
                    }

                }
            } catch {
                os_log("Couldn't read file.", log: OSLog.default, type: .debug)
            }
        }
    }
    
}


// UISearchBarDelegate
// Handles actions involving the search bar for the contact list screen.
extension ContactTableViewController: UISearchBarDelegate {
    // Filters contacts as text is being inputted in the search bar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedNames = contacts.filter({$0.contactName.lowercased().contains(searchText)})
        
        if searchText.isEmpty {
            sortContacts(selectedContacts: contacts)
        } else {
            sortContacts(selectedContacts: searchedNames)
        }
        
        self.tableView.reloadData()
    }
    
    // Filters contacts again after the "Search" button is clicked.
    // Nearly identical to searchBar function.
    // Dismisses the keyboard.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            fatalError("Cannot assign search bar text to searchText.")
        }
        searchedNames = contacts.filter({$0.contactName.lowercased().contains(searchText)})
        
        if searchText.isEmpty {
            sortContacts(selectedContacts: contacts)
        } else {
            sortContacts(selectedContacts: searchedNames)
        }
        
        searchBar.resignFirstResponder()
        
        self.tableView.reloadData()
    }
    
    // Erases all text if the "Cancel" button is clicked.
    // Returns contact list back to normal.
    // Dismisses the keyboard.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        
        sortContacts(selectedContacts: contacts)
        
        searchBar.resignFirstResponder()
        
        self.tableView.reloadData()
    }
}
