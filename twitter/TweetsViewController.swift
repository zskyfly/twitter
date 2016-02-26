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
        self.loadTweets()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    /*
    // MARK: - Navigation
    */

    func onTapLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    func onTapNew(sender: AnyObject) {
        let newVc = ContentControllerManager.initNewTweetViewController()
        newVc.user = User._currentUser
        newVc.delegate = self
        showViewController(newVc, sender: self)
    }

    /*
    // MARK: - Load Tweets Functionality
    */

    private func loadTweets(beforeOldestTweet: Tweet? = nil) {
        var successClosure = reloadSuccessClosure

        if beforeOldestTweet != nil {
            successClosure = appendSuccessClosure
        }

        self.controllerProperties.apiCall(oldestTweet: beforeOldestTweet, success: successClosure,
            failure: loadFailureClosure)
    }

    private func reloadSuccessClosure(tweets:[Tweet]) -> () {
        self.tweets = tweets
        loadSuccess()
        tableView.pullToRefreshView.stopAnimating()
    }

    private func appendSuccessClosure(tweets:[Tweet]) -> () {
        self.tweets.appendContentsOf(tweets)
        loadSuccess()
        tableView.infiniteScrollingView.stopAnimating()
    }

    private func loadSuccess() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = self.controllerProperties.estimatedRowHight
        tableView.reloadData()
    }

    private func loadFailureClosure(error: NSError) -> () {
        print("\(error.localizedDescription)")
        tableView.infiniteScrollingView.stopAnimating()
        tableView.pullToRefreshView.stopAnimating()
    }

    /*
    // MARK: - Controller Setup
    */

    private func initControllerProperties() {
        let storyboardId = self.restorationIdentifier!
        let controllerType = ContentControllerManager.TweetsControllerType(rawValue: storyboardId)
        self.controllerProperties = ContentControllerManager.getTweetsControllerProperties(controllerType!)

        navigationItem.title = self.controllerProperties.navTitle
        self.navigationController?.navigationBar.barTintColor = self.controllerProperties.navBarColor

        tableView.addPullToRefreshWithActionHandler(pullToRefreshActionHandler)
        tableView.addInfiniteScrollingWithActionHandler(infiniteScrollingActionHandler)
        tableView.delegate = self
        tableView.dataSource = self

        initNavButtons()
    }

    private func initNavButtons() {
        let newButton = UIBarButtonItem(title: "New", style: .Plain, target: self, action: Selector("onTapNew:"))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: Selector("onTapLogout:"))
        self.navigationItem.rightBarButtonItem = newButton
        self.navigationItem.leftBarButtonItem = logoutButton
    }

    private func pullToRefreshActionHandler() {
        loadTweets()
    }

    private func infiniteScrollingActionHandler() {
        loadTweets(getOldestTweet())
    }

    private func getOldestTweet() -> Tweet? {
        return self.tweets?.last
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
        cell.delegate = self
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

extension TweetsViewController: TweetCellDelegate {
    func tweetCell(tweetCell: TweetCell, didSelectTweet tweet: Tweet) {
        let detailViewController = ContentControllerManager.initTweetDetailViewController()
        detailViewController.tweet = tweet
        showViewController(detailViewController, sender: self)
    }
}
