//
//  BookPlayerViewController.swift
//  ITunesMediaJsonDemo
//
//  Created by James Van Dillen on 5/4/15.
//  Copyright (c) 2015 James Van Dillen. All rights reserved.
//

import UIKit

import UIKit
import QuartzCore
import AVFoundation
import AVKit

class BookPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var collection: Collection?
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var bookDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let collectionTest = self.collection?.collectionId {
            thumbnailImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.collection!.thumbnailUrl100)!)!)
            bookDescription.text = collection?.description
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource Functions (required)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell") as! UITableViewCell
        
        if indexPath.row == 0 {
            cell.textLabel?.text = collection?.name
            cell.detailTextLabel?.text = collection?.artistName
        }
        if indexPath.row == 1 {
            cell.textLabel?.text = collection?.price
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAudioBook" {
            let playerViewController = segue.destinationViewController as! AVPlayerViewController
            
            var urlString = collection?.previewUrl
            var audioBookPreviewUrl = NSURL(string: urlString!)
            let player = AVPlayer(URL: audioBookPreviewUrl)
            
            playerViewController.player = player
        }
    }
}
