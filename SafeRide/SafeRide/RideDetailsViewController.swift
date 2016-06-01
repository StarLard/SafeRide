//
//  RideDetailsViewController.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/25/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class RideDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties (Public)
    var ride: Ride?
    var username: String?
    var password: String?
    
    // MARK: Properties (Private)
    private let headerTitles = ["Ride Information", "Rider Information"]
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.rideDetailsTableView.backgroundColor = UIColor.init(red: 231/255, green: 236/255, blue: 208/255, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Properties (IBAction)
    
    @IBAction func completePressed(sender: AnyObject) {
        if let unwrappedRide = ride {
            SafeRideDataService.sharedSafeRideDataService.removeSheduled(unwrappedRide.meteorID!) { success in
                if success {
                    // Reload updated meteor data
                    SafeRideDataService.sharedSafeRideDataService.loadRidesFromMeteor(self.username!, pass: self.password!) { success in
                        if success {
                            let alert = UIAlertController(title: "Ride Completed!", message: "Dispatch has been notified.",preferredStyle: .Alert)
                            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {(_)in
                                self.performSegueWithIdentifier("unwindToSchedule", sender: self)
                            })
                            alert.addAction(OKAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                        else {
                            print("Error: Unable to reload meteor data")
                        }
                    }
                }
                else {
                    print("Error: Unable to delete scheduled ride")
                }
            }
        }
        else {
            print("Error: ride not set")
        }
    }
    
    // MARK: Properties (IBOutlet)

    @IBOutlet weak var rideDetailsTableView: UITableView!
    
    // MARK: UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 4
        }
        else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) || indexPath == NSIndexPath(forRow: 1, inSection: 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("RouteAddressCell", forIndexPath: indexPath) as! RouteAddressCell
            cell.addressLabel.text = "Pick Up Address"
            cell.addressField.text = self.ride?.pickup
            if indexPath == NSIndexPath(forRow: 1, inSection: 0) {
                cell.addressLabel.text = "Drop Off Address"
                cell.addressField.text = self.ride?.dropoff
            }
            let borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
            
            cell.parentViewController = self
            cell.addressField.layer.borderColor = borderColor
            cell.addressField.layer.borderWidth = 1.0
            cell.addressField.layer.cornerRadius = 5.0
            cell.addressField.userInteractionEnabled = false
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else if indexPath == NSIndexPath(forRow: 2, inSection: 0) || indexPath == NSIndexPath(forRow: 3, inSection: 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "Number of Riders"
            if indexPath == NSIndexPath(forRow: 3, inSection: 0) {
                cell.infoLabel.text = "Ride Time"
                cell.infoField.text = self.ride?.time
            }
            else {
                cell.infoField.text = self.ride?.numberOfRiders
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.infoField.userInteractionEnabled = false
            return cell
        }
        else if indexPath == NSIndexPath(forRow: 0, inSection: 1) || indexPath == NSIndexPath(forRow: 1, inSection: 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "UO ID Number"
            
            cell.infoField.text = self.ride?.uoid
            if indexPath == NSIndexPath(forRow: 0, inSection: 1){
                
                cell.infoField.text = self.ride?.phone
                cell.infoLabel.text = "Phone Number"
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.infoField.userInteractionEnabled = false
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath) as! InfoCell
            cell.infoLabel.text = "Rider Name"
            
            cell.infoField.text = self.ride?.rider
            cell.infoField.userInteractionEnabled = false
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath == NSIndexPath(forRow: 0, inSection: 0) || indexPath == NSIndexPath(forRow: 1, inSection: 0)){
            return 165
        }
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
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
