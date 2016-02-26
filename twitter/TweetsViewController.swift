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
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initControllerProperties()
        self.reloadTweets()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    /*
    // MARK: - Navigation
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

    private func reloadTweets() {
        self.controllerProperties.apiCall(success: reloadSuccessClosure,
            failure: reloadFailureClosure)
    }

    private func reloadSuccessClosure(tweets:[Tweet]) -> () {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = self.controllerProperties.estimatedRowHight
        self.tweets = tweets
        tableView.reloadData()
    }

    private func reloadFailureClosure(error: NSError) -> () {
        print("\(error.localizedDescription)")
    }

    private func initControllerProperties() {
        let storyboardId = self.restorationIdentifier!
        let controllerType = ContentControllerManager.TweetsControllerType(rawValue: storyboardId)
        self.controllerProperties = ContentControllerManager.getTweetsControllerProperties(controllerType!)

        navigationItem.title = self.controllerProperties.navTitle
        self.navigationController?.navigationBar.backgroundColor = self.controllerProperties.navBarColor

        tableView.addPullToRefreshWithActionHandler { () -> Void in
            self.reloadTweets()
            self.tableView.pullToRefreshView.stopAnimating()
        }
        tableView.delegate = self
        tableView.dataSource = self
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
        tableView.reloadData()
    }

}


