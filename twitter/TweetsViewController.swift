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

    var controllerProperties: ContentControllerManager.TweetsViewControllerProperties!
    var tweets: [Tweet]!

    let estimated_row_height: CGFloat = 100.0


    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initControllerProperties()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.reloadTweets()
            self.tableView.pullToRefreshView.stopAnimating()
        }

        print("\(self.restorationIdentifier)")
        self.reloadTweets()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        case "NewTweetSegue":
            let vc = segue.destinationViewController as! NewTweetViewController
            vc.user = User._currentUser
            vc.delegate = self
        default:
            return
        }


    }

    func reloadTweets() {
        self.controllerProperties.apiCall(success: reloadSuccessClosure,
            failure: reloadFailureClosure)
    }

    func reloadSuccessClosure(tweets:[Tweet]) -> () {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = self.estimated_row_height
        self.tweets = tweets
        self.tableView.reloadData()
    }

    func reloadFailureClosure(error: NSError) -> () {
        print("\(error.localizedDescription)")
    }

    func initControllerProperties() {
        if let storyboardId = self.restorationIdentifier {
            let controllerType = ContentControllerManager.TweetsControllerType(rawValue: storyboardId)
            self.controllerProperties = ContentControllerManager.getTweetsControllerProperties(controllerType!)
        }
        self.navigationItem.title = self.controllerProperties.navTitle
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

extension TweetsViewController: NewTweetViewControllerDelegate {
    func newTweetViewController(newTweetViewController: NewTweetViewController, didPostStatusUpdate tweet: Tweet) {
        self.tweets.insert(tweet, atIndex: 0)
        self.tableView.reloadData()
    }

}


