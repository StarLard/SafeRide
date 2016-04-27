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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        SafeRideDataService.sharedSafeRideDataService.loadRidesFromMeteor()
        performSegueWithIdentifier("scheduleSegue", sender: nil)
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
