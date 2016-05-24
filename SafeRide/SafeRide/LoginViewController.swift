//
//  LoginViewController.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/25/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addToolBarToTextField(usernameField)
        addToolBarToTextField(passwordField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Properties (IBOutlet)
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
        
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed(){
        view.endEditing(true)
    }
    func cancelPressed(){
        view.endEditing(true) // or do something
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
