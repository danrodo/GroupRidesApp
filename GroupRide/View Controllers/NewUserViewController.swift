//
//  NewUserViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import CloudKit

class NewUserViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var keyboardHeight: CGFloat = 0
    var imageViewHeight: CGFloat = 0
    var textFieldsSpacing: CGFloat = 0.0
    
    // MARK: - Properties
    
    let picker = UIImagePickerController()
    
    var profilePicture = UIImage()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blockActionView: UIView!
    
    @IBOutlet weak var viewToBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastNameToFirstNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewToTopConstraint: NSLayoutConstraint!
    
    // MARK: - View Controller life cycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()

    }
    
    // MARK: - Actions
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        presentPicker()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        saveButton.isEnabled = false
        
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text else {
            self.presentSimpleAlert(title: "Unable to save your info", message: "Please check that you filled everything in correctly")
            return
        }
        
        if firstName == "" || lastName == "" || firstName == "Enter first name here..." || lastName == "Enter last name here..." {
            self.presentSimpleAlert(title: "Unable to save your info", message: "Please check that you filled everything in correctly")
            return
        }
        
        if profilePictureImageView.image != nil {
            profilePicture = profilePictureImageView.image!
        } else {
            profilePicture = #imageLiteral(resourceName: "bike_icon")
        }
        
        
        let photoData = UIImagePNGRepresentation(profilePicture)
        
        let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let feedTableViewController = myStoryboard.instantiateViewController(withIdentifier: "FeedTableViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        blockActionView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        UserController.shared.createUser(firstName: firstName, lastName: lastName, photoData: photoData, attendingRides: [CKReference]()) { (success) in
            DispatchQueue.main.async {
                if !success {
                    self.blockActionView.isHidden = true
                    self.presentSimpleAlert(title: "Unable to save your info", message: "There was an issue connecting to GroupRide's data store, try again when you have service")
                }
                appDelegate.window?.rootViewController = feedTableViewController
                self.blockActionView.isHidden = true
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                RideEventController.shared.refreshData()
            }
        }
    }
    
    // MARK: - image picker private settup
    
    func presentPicker() {
        
        let pickerAlert = UIAlertController(title: "Image selection options.", message: "Choose a photo from your library or take one now", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (camera) in
            self.picker.allowsEditing = false
            self.picker.sourceType = .camera
            self.picker.cameraCaptureMode = .photo
            self.present(self.picker, animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Library.", style: .default) { (photoLibrary) in
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerAlert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            pickerAlert.addAction(photoLibraryAction)
        }
        pickerAlert.addAction(cancelAction)
        present(pickerAlert, animated: true, completion: nil)
    }
    
    // MARK: - image picker Delegate functions
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profilePicture = chosenImage
        profilePictureImageView.image = chosenImage
        DispatchQueue.main.async {
            self.profilePictureImageView.alpha = 1.0
            self.selectPhotoButton.setTitle("", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextField delegate functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Enter first name here..." || textField.text == "Enter last name here..." {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            if textField == firstNameTextField {
                textField.text = "Enter first name here..."
            } else {
                textField.text = "Enter last name here..."
            }
        }
    }
    
    // MARK: - Error handeling views
    
    func presentSimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
        self.firstNameTextField.text = "Enter first name here..."
        self.lastNameTextField.text = "Enter last name here..."
        
        self.saveButton.isEnabled = true
    }
    
    // MARK: - Handle keyboard interaction
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // FIXME: - implement
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurveRaw = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRaw),
            let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if keyboardSize.height != 0 {
            self.keyboardHeight = keyboardSize.height
        }
        
        self.view.layoutIfNeeded()
        self.viewToBottomConstraint.constant += self.keyboardHeight
        
        self.imageViewToTopConstraint.constant -= self.imageViewHeight
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurveRaw = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? Int,
            let animationCurve = UIViewAnimationCurve(rawValue: animationCurveRaw) else { return }
        
        
        self.view.layoutIfNeeded()
        self.viewToBottomConstraint.constant = 0
        
        self.imageViewToTopConstraint.constant = 30
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        UIView.setAnimationCurve(animationCurve)
        UIView.setAnimationBeginsFromCurrentState(true)
        
        self.view.layoutIfNeeded()
        UIView.commitAnimations()
        
        
    }
    
    func setUpView() {
        imageViewHeight = profilePictureImageView.frame.height
        textFieldsSpacing = lastNameToFirstNameConstraint.constant
        
        // Set up tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
        blockActionView.isHidden = true
        
        saveButton.isEnabled = true
        activityIndicator.isHidden = true
        
        // textField setup
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        firstNameTextField.layer.cornerRadius = 15
        lastNameTextField.layer.cornerRadius = 15
        
        // ImagePicker settup
        picker.delegate = self
        
        // create notification observers for when keyboard is shown and when it is dismissed
        // to adjust constraints
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: .UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: .UIKeyboardWillHide, object: nil)
    }
}


























