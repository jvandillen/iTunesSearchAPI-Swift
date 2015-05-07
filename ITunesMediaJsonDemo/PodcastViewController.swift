//
//  PodcastViewController.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 4/27/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import UIKit

class PodcastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ITunesAPIControllerProtocol {

    
    @IBOutlet weak var podTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ascDesc(sender: UIBarButtonItem) {
    }
    
    @IBAction func searchItunesBtn(sender: UIBarButtonItem) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("podCell", forIndexPath: indexPath) as! UITableViewCell
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    // MARK: - Custom API Protocol
    // Take the JSON results, create Collection objects via JSON, store in an array
    func didReceiveITunesData(results: NSDictionary) {
//        let resultsArray = results["results"] as! NSArray
//        println("resultsARRAY = \(resultsArray)")
//        
//        // Code to execute on the main thread (asynchronously)
//        dispatch_async(dispatch_get_main_queue(), {
//            // Delegate creation of the array of Collection objects to the Collection class
//            self.collections = Collection.createCollectionsWithJSON(resultsArray)
//            // Reload the table view with newly created objects
//            self.videoTableView!.reloadData()
        
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        })
    }

}
