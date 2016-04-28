//
//  ScheduleViewController.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/25/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties (Private)
    private var resultsController: NSFetchedResultsController?
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let background = UIImageView(image: UIImage(named: "Background"))
        background.alpha = 0.5
        background.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.scheduleTableView.backgroundView = background
        
        let resultsControllerFetch = SafeRideDataService.sharedSafeRideDataService.rides()
        self.resultsController = resultsControllerFetch
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Properties (IBOutlet)

    @IBOutlet weak var scheduleTableView: UITableView!
    
    
    
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
        cell.ride = ride
        
        return cell
        
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
                rideDetailsViewController.ride = ride
            }
        default:
            super.prepareForSegue(segue, sender: sender)
        }
    }

}
