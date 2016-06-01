//
//  ConfirmViewController.swift
//  SafeRide
//
//  Created by Caleb Friden on 4/2/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import CoreData

class ConfirmViewController: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    var pickUpAddress: String = ""
    var dropOffAddress: String = ""
    
    // MARK: Properties (Private)
    private var resultsController : NSFetchedResultsController?
    private var user : User?
    private var observationTokens = Array<AnyObject>()
    private var numberOfRidersField = UITextField()
    private var timeField = UITextField()
    private let riderPickerView = UIPickerView()
    private let timePickerView = UIDatePicker()
    private let riderPickOptions = ["1", "2", "3"]
    let headerTitles = ["Ride Information", "Your Information"]
    
    private var numberOfRiders = ""
    private var phoneNumber = ""
    private var UOID = ""
    private var rideTime = ""
    private var firstName = ""
    private var lastName = ""
    
    // MARK: Properties (IBAction)
    @IBAction func sendButtonPressed(sender: AnyObject) {
        let fullName = firstName + " " + lastName
        SafeRideDataService.sharedSafeRideDataService.insertPending(fullName, universityID: UOID, phoneNumber: phoneNumber, pickupAddress: pickUpAddress, dropoffAddress: dropOffAddress, numberofRiders: numberOfRiders, timeOfRide: rideTime) { success in
            if success {
                self.performSegueWithIdentifier("confirmSegue", sender: nil)
            }
            else {
                print("Error: Unable to send ride request")
            }
        }
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        infoTableView.reloadData()
    }

    
    @IBAction func textFieldChanged(sender: UITextField) {
        // Called whenever a text field changes
        // phone field has tag 1, UO ID has tag 2, time has tag 3, first name has tag 4, last name has tag 5
        if sender.tag == 1 {
            self.phoneNumber = sender.text!
        }
        else {
            self.UOID = sender.text!
        }
        readyToRequest()
    }
    // MARK: Properties (IBOutlet)
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var sendRequestButton: UIBarButtonItem!
    
    // MARK: Private (Notifications)
    private func registerForNotifications() {
        if !observationTokens.isEmpty {
            unregisterForNotifications()
        }
        observationTokens.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] (notification: NSNotification) -> Void in
            // Update the table view content and scroller insets
            self.infoTableView.adjustInsetsForWillShowKeyboardNotification(notification)
            })
        observationTokens.append(NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [unowned self] (notification: NSNotification) -> Void in
            // Update the table view content and scroller insets
            self.infoTableView.adjustInsetsForWillHideKeyboardNotification(notification)
            })
    }
    
    private func unregisterForNotifications() {
        for token in observationTokens {
            NSNotificationCenter.defaultCenter().removeObserver(token)
        }
        observationTokens.removeAll()
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoTableView.backgroundColor = UIColor.init(red: 231/255, green: 236/255, blue: 208/255, alpha: 1)
        
        let resultsController = SafeRideDataService.sharedSafeRideDataService.user()
        
        try! resultsController.performFetch()
        
        self.resultsController = resultsController
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        
        self.user = self.resultsController!.objectAtIndexPath(indexPath) as? User

        // Do any additional setup after loading the view.
        
        riderPickerView.delegate = self
        
        
        // Listen for keyboard show/hide notifications
        registerForNotifications()
    }
    deinit {
        unregisterForNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 4
        }
        else {
            return 4
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) || indexPath == NSIndexPath(forRow: 1, inSection: 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! AddressCell
            cell.addressLabel.text = "Pick Up Address"
            cell.addressField.text = pickUpAddress
            cell.addressField.tag = 1
            if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
                cell.addressLabel.text = "Drop Off Address"
                cell.addressField.text = dropOffAddress
                cell.addressField.tag = 2
            }
            let borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
            
            cell.addressField.layer.borderColor = borderColor
            cell.addressField.layer.borderWidth = 1.0
            cell.addressField.layer.cornerRadius = 5.0
            addToolBarToTextView(cell.addressField)
            cell.addressField.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else if indexPath == NSIndexPath(forRow: 2, inSection: 0) || indexPath == NSIndexPath(forRow: 3, inSection: 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "Number of Riders"
            cell.infoField.inputView = riderPickerView
            cell.infoField.delegate = self
            addToolBarToTextField(cell.infoField)
            if indexPath == NSIndexPath(forRow: 3, inSection: 0) {
                cell.infoLabel.text = "Ride Time"
                timePickerView.datePickerMode = UIDatePickerMode.Time
                timePickerView.addTarget(self, action: #selector(ConfirmViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
                cell.infoField.inputView = timePickerView
                cell.infoField.tag = 3
                let dateFormatter = NSDateFormatter()
                
                dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                cell.infoField.text = dateFormatter.stringFromDate(timePickerView.date)
                rideTime = cell.infoField.text!
                
                self.timeField = cell.infoField
            }
            else {
                cell.infoField.text = "1"
                numberOfRiders = cell.infoField.text!
                self.numberOfRidersField = cell.infoField
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else if indexPath == NSIndexPath(forRow: 0, inSection: 1) || indexPath == NSIndexPath(forRow: 1, inSection: 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "UO ID Number"

            cell.infoField.text = user?.uoid
            self.UOID = (user?.uoid)!
            cell.infoField.tag = 2
            if indexPath == NSIndexPath(forRow: 0, inSection: 1){

                cell.infoField.text = user?.phoneNumber
                self.phoneNumber = (user?.phoneNumber)!
                readyToRequest()
                cell.infoLabel.text = "Phone Number"
                cell.infoField.tag = 1
            }
            cell.infoField.keyboardType = .NumberPad
            addToolBarToTextField(cell.infoField)
            cell.infoField.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "First Name"
            
            cell.infoField.text = user?.firstName
            self.firstName = (user?.firstName)!
            cell.infoField.tag = 4
            if indexPath == NSIndexPath(forRow: 3, inSection: 1){
                
                cell.infoField.text = user?.lastName
                self.lastName = (user?.lastName)!
                readyToRequest()
                cell.infoLabel.text = "Last Name"
                cell.infoField.tag = 5
            }
            addToolBarToTextField(cell.infoField)
            cell.infoField.delegate = self
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath == NSIndexPath(forRow: 0, inSection: 0) || indexPath == NSIndexPath(forRow: 1, inSection: 0)){
            return 90
        }
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
    }

    
    // MARK: UIPickerViewDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return riderPickOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return riderPickOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberOfRidersField.text = riderPickOptions[row]
        self.numberOfRiders = numberOfRidersField.text!
        self.view.endEditing(true)
    }
    
    // MARK: UITextViewDelegate
    func textViewDidEndEditing(textView: UITextView) {
        if textView.tag == 1 {
            pickUpAddress = textView.text
        }
        else {
            dropOffAddress = textView.text
        }
    }
    
    // MARK: UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Ensures Only Valid characters have been entered in numerical fields
        var invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        
        if (textField.tag == 4 || textField.tag == 5){
            invalidCharacters = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").invertedSet
        }
        return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Methods (Private)
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        timeField.text = dateFormatter.stringFromDate(sender.date)
        rideTime = timeField.text!
        
    }
    
    func readyToRequest(){
        // Checks if all required info has been filled out before enable request button
        let requiredInformation = [self.pickUpAddress,
                                   self.dropOffAddress,
                                   self.numberOfRiders,
                                   self.phoneNumber,
                                   self.UOID,
                                   self.rideTime,
                                   self.firstName,
                                   self.lastName]
        for info in requiredInformation {
            if info == "" {
                self.sendRequestButton.enabled = false
                return
            }
            // Valid Phone numbers must be either 10 (or 11 with country code) digits
            else if info == self.phoneNumber && (info.characters.count < 10 || info.characters.count > 11) {
                self.sendRequestButton.enabled = false
                return
            }
        }
        self.sendRequestButton.enabled = true
    }
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
    func addToolBarToTextView(textField: UITextView){
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
