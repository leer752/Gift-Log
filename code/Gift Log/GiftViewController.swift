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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    /*
     This value is either passed by 'GiftTableViewController' in
     'prepare(for:sender:)'
     or constructed as part of adding a new gift.
    */
    var gift: Gift?
    var activeID: String?
    
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
        // The view controller needs to be dismissed in two different ways depending on how it's presented (push or modal).
        let isPresentingInAddGiftMode = presentingViewController is UINavigationController
        
        if isPresentingInAddGiftMode {
            dismiss(animated: true, completion: nil)
        }
            
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
            
        else {
            fatalError("The GiftViewController is not inside a navigation controller.")
        }
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
        gift = Gift(photo: photo, name: name, store: store, address: address, cityState: cityState, url: url, price: price, date: date, itemCode: itemCode, priority: priority, contactID: activeID ?? "unknown")
        
    }
    
    // Handling keyboard for bottom text fields.
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardSize = rect.size
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
        
        // If active text fields is hidden by the keyboard, scroll so it's visible.
        var activeRect = self.view.frame;
        activeRect.size.height -= keyboardSize.height;
        
        let activeField: UITextField? = [nameField, storeField, addressField, cityStateField, urlField, priceField, dateField, itemCodeField].first { $0.isFirstResponder }
        if let activeField = activeField {
            if activeRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-keyboardSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
        
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set content size of scroll view so scrolling is enabled.
        scrollView.contentSize = contentView.frame.size
        
        // Handle all text fields' user input through delegate callbacks.
        nameField.delegate = self
        storeField.delegate = self
        addressField.delegate = self
        cityStateField.delegate = self
        urlField.delegate = self
        priceField.delegate = self
        dateField.delegate = self
        itemCodeField.delegate = self
        
        // Set up detail if editing an existing gift.
        if let gift = gift {
            navigationItem.title = gift.name
            giftImageView.image = gift.photo
            nameField.text = gift.name
            storeField.text = gift.store
            addressField.text = gift.address
            cityStateField.text = gift.cityState
            urlField.text = gift.url
            priceField.text = gift.price
            dateField.text = gift.date
            itemCodeField.text = gift.itemCode
            priorityControl.priority = gift.priority
        }
        
        // Enable the save button if all required fields are entered. If some not entered, highlight required field titles in red.
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
            nameLabel.textColor = UIColor.black
        }
        
        let storeText = storeField.text ?? ""
        if(storeText.isEmpty) {
            storeLabel.textColor = UIColor.red
        } else {
            storeLabel.textColor = UIColor.black
        }
        
        let priceText = priceField.text ?? ""
        if(priceText.isEmpty) {
            priceLabel.textColor = UIColor.red
        } else {
            priceLabel.textColor = UIColor.black
        }
    }
    
}
