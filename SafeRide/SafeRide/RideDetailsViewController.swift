//
//  RideDetailsViewController.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/25/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class RideDetailsViewController: UIViewController {
    
    // MARK: Properties (Private)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let background = UIImageView(image: UIImage(named: "Background"))
        background.alpha = 0.5
        background.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.rideDetailsTableView.backgroundView = background
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Properties (IBOutlet)

    @IBOutlet weak var rideDetailsTableView: UITableView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
