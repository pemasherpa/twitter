//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Pema Sherpa on 2/16/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    var tweets: [Tweet]?
    var filteredTweets: [Tweet]?
    var favoriteStates = [Int:Bool]()
    
    @IBOutlet weak var tableView: UITableView!
    let favoritePressedImage = UIImage(named: "like-action-on.png")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil , completion: { (tweets,error) -> () in
            self.tweets = tweets
            self.filteredTweets = tweets
            self.tableView.reloadData()
        })
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredTweets != nil{
            return (filteredTweets?.count)!
            } else {
            return 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = filteredTweets?[indexPath.row]
        cell.favoriteButton.selected = favoriteStates[indexPath.row] ?? false
        
        return cell
    }
    
    func tweetCell(tweetCell: TweetCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(tweetCell)
        print("Got the event")
        favoriteStates[indexPath!.row] = value
        
    }

    @IBAction func retweetAction(sender: AnyObject) {
        print("Retweeted")
        
        let subviewPostion: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(subviewPostion)!
        
        let cell: UITableViewCell =  self.tableView.cellForRowAtIndexPath(indexPath)!
        
        print("Index Path: \(indexPath.row)")
        
        let tweet = tweets![indexPath.row]
        
        let tweetID = tweet.id
        
        TwitterClient.sharedInstance.retweetWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil) {
                print("")
                
                //self.tweets![indexPath.row].retweetCount = self.tweets![indexPath.row].retweetCount as! Int + 1
                
                var indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                
            }
            else {
                print("")
            }
        }
        
        
    }
    
    @IBAction func favoriteAction(sender: AnyObject) {
        print("Favorited/Liked the tweet")
        sender.setImage(favoritePressedImage, forState: UIControlState.Normal)
        
        let subviewPostion: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        
        let indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(subviewPostion)!
        
        let cell: UITableViewCell =  self.tableView.cellForRowAtIndexPath(indexPath)!
        
        let tweet = tweets![indexPath.row]
        
        let tweetID = tweet.id
        
        
        
        
        TwitterClient.sharedInstance.favoriteWithCompletion(["id": tweetID!]) { (tweet, error) -> () in
            
            if (tweet != nil) {
                print("")
                
                self.tweets![indexPath.row] = tweet!
                let indexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                
                
            }
            else {
                print("")
            }
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil , completion: { (tweets,error) -> () in
            self.tweets = tweets
            self.filteredTweets = tweets
            self.tableView.reloadData()
            
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        })
        
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets![indexPath!.row]
        
    }
    

}
