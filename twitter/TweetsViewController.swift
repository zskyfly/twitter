//
//  TweetsViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit
import SVPullToRefresh

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!
    let estimated_row_height: CGFloat = 100.0

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.reloadTweets()
            self.tableView.pullToRefreshView.stopAnimating()
        }

        self.reloadTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier!

        switch identifier {
        case "DetailViewSegue":
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            let row = indexPath!.row
            let tweet = self.tweets[row]
            let vc = segue.destinationViewController as! TweetDetailViewController
            vc.tweet = tweet
        case "NewTweetSegue":
            let vc = segue.destinationViewController as! NewTweetViewController
            vc.user = User._currentUser
        default:
            return
        }


    }

    func reloadTweets() {
        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) -> () in
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = self.estimated_row_height
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) -> () in
            print("\(error.localizedDescription)")
        }
    }

}

extension TweetsViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = self.tweets[indexPath.row]
        cell.tweet = tweet
        return cell
    }
}

extension TweetsViewController: UITableViewDelegate {}


