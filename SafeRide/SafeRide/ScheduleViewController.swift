//
//  ScheduleViewController.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/25/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import CoreData
import SwiftDDP

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties (Public)
    var username: String?
    var password: String?
    
    // MARK: Properties (Private)
    private var resultsController: NSFetchedResultsController?
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scheduleTableView.backgroundColor = UIColor.init(red: 231/255, green: 236/255, blue: 208/255, alpha: 1)
        
        let resultsControllerFetch = SafeRideDataService.sharedSafeRideDataService.rides()
        try! resultsControllerFetch.performFetch()
        self.resultsController = resultsControllerFetch
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        try! resultsController!.performFetch()
        
        if let selectedIndexPath = scheduleTableView.indexPathForSelectedRow {
            scheduleTableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
        }
        
        scheduleTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            // Back button pressed
            Meteor.logout()
        }
    }

    
    // MARK: Properties (IBOutlet)

    @IBOutlet weak var scheduleTableView: UITableView!
    
    // MARK: Properties (IBAction)
    
    @IBAction func unwindToSchedule(segue: UIStoryboardSegue) {}
    
    //MARK: Table View Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController!.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("rideCell", forIndexPath: indexPath) as! RideCell
        
        let ride = resultsController!.objectAtIndexPath(indexPath) as! Ride
        
        cell.riderNameLabel.text = ride.rider
        cell.rideTimeLabel.text = ride.time
        if let pickup = ride.pickup, dropoff = ride.dropoff {
            if (pickup.characters.count > 20 && dropoff.characters.count > 20) {
                let pickupIndex: String.Index = pickup.startIndex.advancedBy(20)
                let dropoffIndex: String.Index = dropoff.startIndex.advancedBy(20)
                cell.detailLabel.text = pickup.substringToIndex(pickupIndex) + "... → " + dropoff.substringToIndex(dropoffIndex) + "..."
            }
            else if (pickup.characters.count > 20) {
                let pickupIndex: String.Index = pickup.startIndex.advancedBy(20)
                cell.detailLabel.text = pickup.substringToIndex(pickupIndex) + "... → " + dropoff
            }
            else if (dropoff.characters.count > 20) {
                let dropoffIndex: String.Index = dropoff.startIndex.advancedBy(20)
                cell.detailLabel.text = pickup + " → " + dropoff.substringToIndex(dropoffIndex) + "..."
            }
            else {
                cell.detailLabel.text = pickup + " → " + dropoff
            }
        }
        cell.ride = ride
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 55
    }
    
    
    // MARK: - Navigation
     
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case.Some("rideDetailsSegue"):
            if let row = scheduleTableView.indexPathForSelectedRow?.row {
                let indexPath = NSIndexPath(forRow: row, inSection: 0)
                let rideDetailsViewController = segue.destinationViewController as! RideDetailsViewController
                let ride = resultsController!.objectAtIndexPath(indexPath) as! Ride
                rideDetailsViewController.username = self.username
                rideDetailsViewController.password = self.password
                rideDetailsViewController.ride = ride
            }
        default:
            super.prepareForSegue(segue, sender: sender)
        }
    }

}
