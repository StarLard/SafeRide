//
//  SettingsViewController.swift
//  SafeRide
//
//  Created by Caleb Friden on 3/30/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    
    // MARK: Properties (Private)
    private var observationTokens = Array<AnyObject>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: CoreData Variables
    
    var First:String = "John";
    var Last:String = "Smith";
    var Phone:String = "5553995652";
    var UOID:String = "951555444";
    
    


    // MARK: Properties (IBOutlet)
    @IBOutlet weak var settingsTableView: UITableView!
    
    //MARK: Table View Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath) as! SettingsCell
        
        if indexPath == NSIndexPath(forRow: 0, inSection: 0){
            cell.settingsLabel.text = First;
            cell.settingsField.placeholder = "ex. John"
            cell.settingsField.returnKeyType = UIReturnKeyType.Done
        }
        else if indexPath == NSIndexPath(forRow: 1, inSection: 0){
            cell.settingsLabel.text = Last;
            cell.settingsField.placeholder = "ex. Smith"
            cell.settingsField.returnKeyType = UIReturnKeyType.Done
        }
        else if indexPath == NSIndexPath(forRow: 2, inSection: 0){
            cell.settingsField.keyboardType = .NumberPad
            addToolBarToTextField(cell.settingsField)
            cell.settingsLabel.text = Phone;
            cell.settingsField.placeholder = "ex. 5553995652"
        }
        else if indexPath == NSIndexPath(forRow: 3, inSection: 0){
            cell.settingsField.keyboardType = .NumberPad
            addToolBarToTextField(cell.settingsField)
            cell.settingsLabel.text = UOID;
            cell.settingsField.placeholder = "ex. 951555444"
        }
        
        cell.settingsField.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
        
    }
    
    //MARK: Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Helper Functions
    
    func addToolBarToTextField(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ConfirmViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ConfirmViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    // MARK: Private (Notifications)
    private func registerForNotifications() {
        if !observationTokens.isEmpty {
            unregisterForNotifications()
        }
        observationTokens.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] (notification: NSNotification) -> Void in
            // Update the table view content and scroller insets
            self.settingsTableView.adjustInsetsForWillShowKeyboardNotification(notification)
            })
        observationTokens.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] (notification: NSNotification) -> Void in
            // Update the table view content and scroller insets
            self.settingsTableView.adjustInsetsForWillHideKeyboardNotification(notification)
            })
    }
    
    private func unregisterForNotifications() {
        for token in observationTokens {
            NSNotificationCenter.defaultCenter().removeObserver(token)
        }
        observationTokens.removeAll()
    }
    
}

