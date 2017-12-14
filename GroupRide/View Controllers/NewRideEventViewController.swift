//
//  NewRideEventViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/24/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class NewRideEventViewController: UITableViewController, UITextViewDelegate, UITabBarControllerDelegate {
    
    var location = ""
    
    // MARK: - Properties
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextArea: UITextView!
    
    @IBOutlet weak var postRideButton: UIButton!
    
    
    @IBOutlet weak var saveButtonToTextAreaConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    
    @IBAction func postRideButtonTapped(_ sender: Any) {
        
        postRideButton.isEnabled = false
        
        guard let location = locationTextField.text, let description = descriptionTextArea.text else { return }
        let date = datePicker.date
        let currentDate = Date()
        
        if date > currentDate {
            
            RideEventController.shared.create(location: location, date: date, description: description) { (error) in
                if let error = error {
                    NSLog("error saving ride event to store \(error.localizedDescription)")
                    self.postRideButton.isEnabled = true
                    return
                }
                DispatchQueue.main.async {
                    self.postRideButton.isEnabled = true
                    self.datePicker.date = currentDate
                    self.locationTextField.text = ""
                    self.descriptionTextArea.text = "Enter description here..."
                    self.tabBarController?.selectedIndex = 0
                }
                
            }
        } else {
            // Present alert here to tell user not to make a event with the current date or sooner
            postRideButton.isEnabled = true
            let title = "Cannot save this ride!"
            let message = "Make sure the date is right, and fill in the description and location."
            
            presentAlertWith(title: title, message: message)
        }
    }
    
    // MARK: - Viewcontroller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        
        postRideButton.isEnabled = true
        
        descriptionTextArea.delegate = self
        
        datePicker.minimumDate = Date()
        descriptionTextArea.layer.cornerRadius = 10
        
        locationTextField.text = location
        
        locationTextField.isEnabled = true
        
        // Set up tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - TextView delegate funcs 
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter description here..." {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter description here..."
        }
    }
    
    func presentAlertWith(title: String, message: String, color: UIColor = UIColor.white) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = color
        alertContentView.layer.cornerRadius = 10.0
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}





