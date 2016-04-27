//
//  HomeViewController.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/25/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Properties (Private)
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
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

    @IBAction func riderPressed(sender: AnyObject) {
        defaults.setObject("rider", forKey: "userRole")
        performSegueWithIdentifier("riderSegue", sender: nil)
    }
    
    @IBAction func employeePressed(sender: AnyObject) {
        defaults.setObject("employee", forKey: "userRole")
        performSegueWithIdentifier("employeeSegue", sender: nil)
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
