//
//  AddContactVC.swift
//  ContactBook
//
//  Created by Andrian Yohanes on 8/6/17.
//  Copyright © 2017 episquare. All rights reserved.
//

import UIKit
import RealmSwift

class AddContactVC: UIViewController {
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type name here"
        tf.keyboardType = .default
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .groupTableViewBackground
        return tf
    }()
    
    let phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type phone number here"
        tf.keyboardType = .phonePad
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .groupTableViewBackground
        return tf
    }()
    
    let saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save contact", for: .normal)
        btn.addTarget(self, action: #selector(saveToRealm), for: .touchUpInside)
        return btn
    }()
    
    let realm = try! Realm()
    lazy var results = realm.objects(ContactBook.self)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        /// Setup title for UINavigationController
        title = "Add New Contact"
        
        /// Setup views for AddContactVC
        setupView()
        
        /// Setup textfield
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        
        /// Setup return key for textfield
        nameTextField.returnKeyType = .next
        
        /// Init UITapGesture
        let tapToCloseKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        /// Add tapGesture to the view so the keyboard will dismiss when user tap anywhere outside textfield
        view.addGestureRecognizer(tapToCloseKeyboard)
    }
    
    
    
    /// Setup views for AddContactVC
    func setupView() {
        view.addSubview(nameTextField)
        view.addSubview(phoneNumberTextField)
        view.addSubview(saveButton)
        
        nameTextField.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 128, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 44)
        
        phoneNumberTextField.anchor(nameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 44)
        
        saveButton.anchor(phoneNumberTextField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 44, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: saveButton.frame.height)
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        addToolbar(nil, textField: phoneNumberTextField, doneSelector: #selector(toolBarDoneTapped), cancelSelector: #selector(toolBarCancelTapped))
    }
    
    
    
    /// Save new contact to realm database
    @objc func saveToRealm() {
        guard let nameField = nameTextField.text else { return }
        guard let phoneField = phoneNumberTextField.text else { return }

        guard !nameField.isEmpty, !phoneField.isEmpty else { return }
        
        /// Check for the same name
        guard checkBeforeSave(name: nameField, phone: phoneField) else {
            DispatchQueue.main.async {
                self.reusableAlert(alertTitle: "Error", alertMessage: "\(nameField) already exist", viewController: self)
            }
            return
        }
        
        /// Sava new contact to realm database
        let newContact = ContactBook(name: nameField, phoneNumber: phoneField)
        do {
            try realm.write {
                realm.add(newContact)
                nameTextField.text = ""
                phoneNumberTextField.text = ""
                navigationController?.popViewController(animated: true)
            }
        } catch let error {
            print("Failed to add Contact", error)
        }
    }
    
    
    
    /// Check for the same name before save
    @objc func checkBeforeSave(name: String, phone: String) -> Bool {
        for savedContact in results {
            guard savedContact.name?.lowercased() == name.lowercased()  else { return true }
            print("\(savedContact.name!)'s already in your contact")
            return false
        }
        return true
    }
    
    
    
    /// Add custom toolbar to textfield
    fileprivate func addToolbar(_ textView: UITextView?, textField: UITextField?, doneSelector: Selector, cancelSelector: Selector) {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: doneSelector)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: cancelSelector)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.sizeToFit()
        
        if let tf = textField {
            tf.inputAccessoryView = toolBar
        }
        
        if let tv = textView {
            tv.inputAccessoryView = toolBar
        }
    }
    
    
    
    /// dismissKeyboard
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    /// donePressed
    @objc fileprivate func toolBarDoneTapped() {
        view.endEditing(true)
    }
    
    
    
    /// cancelPressed
    @objc fileprivate func toolBarCancelTapped() {
        view.endEditing(true)
    }
    
}





// MARK: - UITextFieldDelegate
extension AddContactVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            phoneNumberTextField.becomeFirstResponder()
        default:
            break
        }
        return false
    }
}
