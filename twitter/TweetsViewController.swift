//
//  TweetsViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90

        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) -> () in
                print("\(error.localizedDescription)")
        }

        // Do any additional setup after loading the view.
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
        let vc = segue.destinationViewController as! TweetDetailViewController
        let cell = sender as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        let row = indexPath!.row
        let tweet = self.tweets[row]
        print("found cell at \(row) and tweet \(tweet)")
        vc.tweet = tweet
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


