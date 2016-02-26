//
//  NewTweetViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/23/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit
import Foundation

@objc protocol NewTweetViewControllerDelegate {
    optional func newTweetViewController(newTweetViewController: NewTweetViewController, didPostStatusUpdate tweet: Tweet)
}

class NewTweetViewController: UIViewController {

    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var statusUpdateTextField: UITextView!
    
    var user: User?
    var replyTweet: Tweet?
    var delegate: NewTweetViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusUpdateTextField.delegate = self
        self.setViewProperties()
        self.initButton()
        self.initTextField()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTapTweet(sender: AnyObject) {
        self.postStatusUpdate()
    }

    func postStatusUpdate() {
        let statusText = statusUpdateTextField.text
        let replyStatusId = replyTweet?.idStr

        TwitterClient.sharedInstance.statusUpdate(statusText, replyStatusId: replyStatusId, success: { (tweet: Tweet) -> () in
            self.delegate?.newTweetViewController?(self, didPostStatusUpdate: tweet)
            self.navigationController?.popViewControllerAnimated(true)
            }) { (error: NSError) -> () in
                print("\(error.localizedDescription)")
        }
    }

    func setViewProperties() {
        ImageHelper.stylizeUserImageView(userImageView)

        if let name = self.user?.name as? String {
            self.userNameLabel.text = name
        }
        if let userHandle = self.user?.screenName as? String {
            self.userHandleLabel.text = "@" + userHandle
        }
        ImageHelper.setImageForView(self.user?.profileUrl, placeholder: User.placeholderProfileImage, imageView: self.userImageView, success: nil) { (error) -> Void in
            print("\(error.localizedDescription)")
        }
        setCharCountLabelOk()
    }

    func initButton() {
        self.tweetButton.setTitleColor(MiscHelper.getUIColor(MiscHelper.twitterLightGrey), forState: UIControlState.Disabled)
        self.tweetButton.setTitleColor(MiscHelper.getUIColor(MiscHelper.twitterBlue), forState: UIControlState.Normal)
        self.tweetButton.layer.borderWidth = 1.0
        self.tweetButton.layer.cornerRadius = 3.0
        self.tweetButton.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        setButtonDisabled()
    }

    func setButtonDisabled() {
        self.tweetButton.layer.borderColor = MiscHelper.getCGColor(MiscHelper.twitterLightGrey)
        self.tweetButton.enabled = false
    }

    func setButtonEnabled() {
        self.tweetButton.layer.borderColor = MiscHelper.getCGColor(MiscHelper.twitterBlue)
        self.tweetButton.enabled = true
    }

    func enableTextField() {
        if self.statusUpdateTextField.text == Tweet.placeHolderText {
            self.statusUpdateTextField.text = ""
        }
        self.statusUpdateTextField.textColor = MiscHelper.getUIColor(MiscHelper.twitterDarkGrey)
    }

    func disableTextField() {
        self.statusUpdateTextField.textColor = MiscHelper.getUIColor(MiscHelper.twitterDarkGrey)
        self.statusUpdateTextField.textColor = MiscHelper.getUIColor(MiscHelper.twitterMediumGrey)
    }

    func initTextField() {
        if let inReplyToUser = self.replyTweet?.user {
            self.statusUpdateTextField.text = "@\(inReplyToUser.screenName!)"
            enableTextField()
        } else {
            self.statusUpdateTextField.text = Tweet.placeHolderText
            disableTextField()
        }
    }

    func setCharCountLabelOk() {
        self.charCountLabel.textColor = MiscHelper.getUIColor(MiscHelper.twitterBlue)
    }

    func setCharCountLabelNotOk() {
        self.charCountLabel.textColor = UIColor.redColor()
    }
}

extension NewTweetViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        let textLength = self.statusUpdateTextField.text.characters.count
        self.setCharCountLabelOk()
        self.enableTextField()
        self.charCountLabel.text = "\(Tweet.maxLength - textLength)"
        if Tweet.acceptableLength ~= textLength {
            self.setButtonEnabled()
        } else if textLength == 0 {
            setButtonDisabled()
        } else {
            self.charCountLabel.text = "\(textLength - Tweet.maxLength)"
            self.disableTextField()
            self.setCharCountLabelNotOk()
            self.setButtonDisabled()
        }
    }

    func textViewDidBeginEditing(textView: UITextView) {
        self.enableTextField()
    }
}
