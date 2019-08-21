//
//  GiftViewController.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/15/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit
import os.log
import Photos

class GiftViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var itemCodeLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var storeField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityStateField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var priceField: UITextField! {
        didSet { priceField?.addDoneCancelToolbar() }
    }
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var itemCodeField: UITextField!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var priorityControl: PriorityControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by 'GiftTableViewController' in
     'prepare(for:sender:)'
     or constructed as part of adding a new gift.
    */
    var gift: Gift?
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            self.giftImageView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            self.giftImageView.image = selectedImage
        }
    
        dismiss(animated: true)
    }
    
    fileprivate func presentPhotoPickerController() {
        let giftPickerController = UIImagePickerController()
        giftPickerController.allowsEditing = true
        giftPickerController.delegate = self
        giftPickerController.sourceType = .photoLibrary
        self.present(giftPickerController, animated: true)
    }
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
                
        let photo = giftImageView.image
        let name = nameField.text ?? ""
        let store = storeField.text ?? ""
        let address = addressField.text ?? ""
        let cityState = cityStateField.text ?? ""
        let url = urlField.text ?? ""
        let price = priceField.text ?? "0.00"
        let date = dateField.text ?? ""
        let itemCode = itemCodeField.text ?? ""
        let priority = priorityControl.priority
        
        // Set the gift to be passed to GiftTableViewController after the unwind segue.
        gift = Gift(photo: photo, name: name, store: store, address: address, cityState: cityState, url: url, price: price, date: date, itemCode: itemCode, priority: priority)
        
    }
    
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameField.resignFirstResponder()
        storeField.resignFirstResponder()
        addressField.resignFirstResponder()
        cityStateField.resignFirstResponder()
        urlField.resignFirstResponder()
        priceField.resignFirstResponder()
        dateField.resignFirstResponder()
        itemCodeField.resignFirstResponder()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    self.presentPhotoPickerController()
                default:
                    break
                }
            }
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        showRequiredFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nameField.delegate = self
        storeField.delegate = self
        addressField.delegate = self
        cityStateField.delegate = self
        urlField.delegate = self
        priceField.delegate = self
        dateField.delegate = self
        itemCodeField.delegate = self
        
        updateSaveButtonState()
        showRequiredFields()
    }
    
    // MARK: Private methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let nameText = nameField.text ?? ""
        saveButton.isEnabled = !nameText.isEmpty
        let storeText = storeField.text ?? ""
        saveButton.isEnabled = !storeText.isEmpty
        let priceText = priceField.text ?? ""
        saveButton.isEnabled = !priceText.isEmpty
    }
    
    private func showRequiredFields() {
        let nameText = nameField.text ?? ""
        if(nameText.isEmpty) {
            nameLabel.textColor = UIColor.red
        } else {
            nameLabel.textColor = UIColor.darkGray
        }
        
        let storeText = storeField.text ?? ""
        if(storeText.isEmpty) {
            storeLabel.textColor = UIColor.red
        } else {
            storeLabel.textColor = UIColor.darkGray
        }
        
        let priceText = priceField.text ?? ""
        if(priceText.isEmpty) {
            priceLabel.textColor = UIColor.red
        } else {
            priceLabel.textColor = UIColor.darkGray
        }
    }
    
}
