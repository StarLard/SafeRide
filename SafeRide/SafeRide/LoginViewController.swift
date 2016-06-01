//
//  LoginViewController.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/25/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import Locksmith

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        usernameField.returnKeyType = UIReturnKeyType.Done
        usernameField.autocorrectionType = UITextAutocorrectionType.No
        passwordField.returnKeyType = UIReturnKeyType.Done
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let defualts = NSUserDefaults.standardUserDefaults()
        if let isRemembered = defualts.objectForKey("isRemembered") {
            if (isRemembered as! NSObject == true) {
                if let username = defualts.objectForKey("username") {
                    let userInfo = Locksmith.loadDataForUserAccount(username as! String)
                    passwordField.text = userInfo!["password"] as? String
                    usernameField.text = username as? String
                    rememberMeSwitch.on = true
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    // MARK: Properties (IBOutlet)
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var rememberMeSwitch: UISwitch!
    
    // MARK: Properties (IBAction)
    
    @IBAction func goHomeButton(sender: AnyObject) {
        // delete the user's role
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("userRole")
        
        
        // go back to home page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyboard.instantiateViewControllerWithIdentifier("homeViewController") as! HomeViewController
        presentViewController(home, animated: true, completion: nil)
    }

    @IBAction func loginButton(sender: AnyObject) {
        if let username = usernameField.text where (username != ""), let password = passwordField.text where (password != ""){
            SafeRideDataService.sharedSafeRideDataService.loadRidesFromMeteor(username, pass: password) { success in
                if success {
                    self.remember(username, password: password)
                    self.performSegueWithIdentifier("scheduleSegue", sender: self)
                }
                else {
                    let alert = UIAlertController(title: "Unable to login!", message: "Please check that you have entered your username and password correctly.",preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(_)in
                    })
                    alert.addAction(OKAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Private (Methods)
    private func remember(username: String, password pass: String) -> Void {
        let defualts = NSUserDefaults.standardUserDefaults()
        // Triggers only after first load
        if let isRemembered = defualts.objectForKey("isRemembered") {
            if (isRemembered as! NSObject == true) {
                if (self.rememberMeSwitch.on) {
                    // User previously had switch on and it is still on
                    do {
                        try Locksmith.updateData(["password": pass], forUserAccount: username)
                        defualts.setObject(username, forKey: "username")
                        defualts.setObject(true, forKey: "isRemembered")
                    }
                    catch {
                        print("Could not update username & password in keychain")
                    }
                }
                else {
                    // User previously had switch on, but has turned it off
                    do {
                        try Locksmith.deleteDataForUserAccount(username)
                        defualts.setObject(false, forKey: "isRemembered")
                        defualts.removeObjectForKey("username")
                    }
                    catch {
                        print("Could not remove username & password from keychain")
                    }
                    
                }
            }
            else {
                if (!self.rememberMeSwitch.on) {
                    // User previously had switch off and it is still off
                    defualts.setObject(false, forKey: "isRemembered")
                }
                else {
                    // User previously had switch off, but has turned it on
                    do {
                        try Locksmith.saveData(["password": pass], forUserAccount: username)
                        defualts.setObject(true, forKey: "isRemembered")
                        defualts.setObject(username, forKey: "username")
                    }
                    catch {
                        print("Could not save username & password to keychain")
                    }
                    
                }
            }
        }
        // Triggers on first load
        else {
            if (self.rememberMeSwitch.on) {
                do {
                    try Locksmith.saveData(["password": pass], forUserAccount: username)
                    defualts.setObject(true, forKey: "isRemembered")
                    defualts.setObject(username, forKey: "username")
                }
                catch {
                    print("Could not save username & password to keychain")
                }
            }
            else {
                print("User did not turn switch on")
                defualts.setObject(false, forKey: "isRemembered")
            }
        }
    }
    
    // MARK: UITextfieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Keyboard Handling
    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        // Keyboard is about to be showed
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        }
        // Keyboard size is about to change, i.e. autocomplete bar is being hidden
        else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height
            })
        }
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case.Some("scheduleSegue"):
            let scheduleViewController = segue.destinationViewController as! ScheduleViewController
            scheduleViewController.username = usernameField.text
            scheduleViewController.password = passwordField.text
        default:
            super.prepareForSegue(segue, sender: sender)
        }
    }

}
