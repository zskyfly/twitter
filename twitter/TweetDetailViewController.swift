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

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    var tweet: Tweet!
    var likeInFlight: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        ImageHelper.stylizeUserImageView(self.userImageView)

        if let user = self.tweet.user {
            ImageHelper.setImageForView(user.profileUrl, placeholder: User.placeholderProfileImage, imageView: self.userImageView, success: nil, failure: nil)
            userNameLabel.text = user.name as? String
            userHandleLabel.text = "@\(user.screenName!)"
        }
        if let text = self.tweet.text {
            tweetTextLabel.text = text
        }
        createdAtLabel.text = tweet.getCreatedAtForDetail()
        retweetCountLabel.text = "\(self.tweet.retweetCount)"
        likeCountLabel.text = "\(self.tweet.favoriteCount)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let identifier = segue.identifier!

        switch identifier {

        case "ReplySegue":
            let vc = segue.destinationViewController as! NewTweetViewController
            vc.user = User._currentUser
            vc.replyTweet = tweet
        default:
            return
        }
    }
    
    @IBAction func onTapLike(sender: AnyObject) {
        let statusId = self.tweet.idStr!
        if !self.likeInFlight {
            // self.toggleLikeButton()
            TwitterClient.sharedInstance.favoriteCreate(statusId, success: { (tweet: Tweet) -> () in
                print("favorite success")
                }) { (error: NSError) -> () in
                    print("\(error.localizedDescription)")
            }
        }
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
