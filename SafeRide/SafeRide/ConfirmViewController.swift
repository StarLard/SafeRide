//
//  ConfirmViewController.swift
//  SafeRide
//
//  Created by Caleb Friden on 4/2/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    // MARK: Properties
    var pickUpAddress: String = ""
    var dropOffAddress: String = ""
    
    // MARK: Properties (IBOutlet)
    
    @IBOutlet weak var pickUpField: UITextField!
    @IBOutlet weak var dropOffField: UITextField!

    // MARK: View Management
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickUpField.text = pickUpAddress
        dropOffField.text = dropOffAddress
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
