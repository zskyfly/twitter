//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/23/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true

        if let user = self.tweet.user {
            ImageHelper.setImageForView(user.profileUrl, placeholder: User.placeholderProfileImage, imageView: self.userImageView, success: nil, failure: nil)
            userNameLabel.text = user.name as? String
            userHandleLabel.text = "@\(user.screenName!)"
        }
        tweetTextLabel.text = self.tweet.text as? String
            //            createdAtLabel.text = tweet.createdAt as! String
        retweetCountLabel.text = "\(self.tweet.retweetCount)"
        likeCountLabel.text = "\(self.tweet.favoriteCount)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
