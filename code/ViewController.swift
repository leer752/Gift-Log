//
//  ViewController.swift
//  Gift Log
//
//  Created by Lee Rhodes on 8/15/19.
//  Copyright © 2019 Lee Rhodes. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var imageView: UIImageView!
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
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var itemCodeField: UITextField!
    @IBOutlet weak var priorityLabel: UILabel!
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            self.imageView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            self.imageView.image = selectedImage
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
    }


}
