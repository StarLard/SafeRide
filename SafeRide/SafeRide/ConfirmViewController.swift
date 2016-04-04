//
//  ConfirmViewController.swift
//  SafeRide
//
//  Created by Caleb Friden on 4/2/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    // MARK: Properties
    var pickUpAddress: String = ""
    var dropOffAddress: String = ""
    
    // MARK: Properties (Private)
    private let pickerView = UIPickerView()
    let toolBar = UIToolbar()
    private let pickOptions = ["1", "2", "3", "4", "5", "6"]
    
    // MARK: Properties (IBOutlet)
    @IBOutlet weak var pickUpField: UITextView!
    @IBOutlet weak var dropOffField: UITextView!
    @IBOutlet weak var numberOfRidersField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var UOIDNumberField: UITextField!

    // MARK: View Management
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.pickUpField.text = pickUpAddress
        self.pickUpField.layer.borderWidth = 1
        self.dropOffField.text = dropOffAddress
        self.dropOffField.layer.borderWidth = 1
        
        phoneNumberField.keyboardType = .NumberPad
        UOIDNumberField.keyboardType = .NumberPad
        
        pickerView.delegate = self
        
        numberOfRidersField.inputView = pickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
