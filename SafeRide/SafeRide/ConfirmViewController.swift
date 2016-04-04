//
//  ConfirmViewController.swift
//  SafeRide
//
//  Created by Caleb Friden on 4/2/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    var pickUpAddress: String = ""
    var dropOffAddress: String = ""
    
    // MARK: Properties (Private)
    private var numberOfRidersField = UITextField()
    private let pickerView = UIPickerView()
    let toolBar = UIToolbar()
    private let pickOptions = ["1", "2", "3", "4", "5", "6"]
    let headerTitles = ["Ride Information", "Your Information"]
    
    // MARK: Properties (IBOutlet)
    @IBOutlet weak var infoTableView: UITableView!

    // MARK: View Management
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 3
        }
        else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! AddressCell
            cell.addressLabel.text = "Pick Up Address"
            cell.addressField.text = pickUpAddress
            return cell
        }
        else if indexPath == NSIndexPath(forRow: 1, inSection: 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! AddressCell
            cell.addressLabel.text = "Drop Off Address"
            cell.addressField.text = dropOffAddress
            return cell
        }
        else if indexPath == NSIndexPath(forRow: 2, inSection: 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "Number of Riders"
            cell.infoField.inputView = pickerView
            self.numberOfRidersField = cell.infoField
            return cell
        }
        else if indexPath == NSIndexPath(forRow: 0, inSection: 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "Phone Number"
            cell.infoField.keyboardType = .NumberPad
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "UO ID Number"
            cell.infoField.keyboardType = .NumberPad
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
        return pickOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberOfRidersField.text = pickOptions[row]
        self.view.endEditing(true)
    }
    
    // MARK: UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.becomeFirstResponder()
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
