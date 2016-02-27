//
//  TweetCell.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit


@objc protocol TweetCellDelegate {
    optional func tweetCell(tweetCell: TweetCell, didSelectTweet tweet: Tweet)
    optional func tweetCell(tweetCell: TweetCell, didTapUser user: User)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                ImageHelper.setImageForView(user.profileUrl, placeholder: User.placeholderProfileImage, imageView: self.userImageView, success: nil, failure: nil)
                userNameLabel.text = user.name as? String
                userHandleLabel.text = "@\(user.screenName!)"
            }
            if let text = tweet.text {
                tweetTextLabel.text = text
            }

            createdAtLabel.text = tweet.getCreatedAtForList()
        }
    }

    var delegate: TweetCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func configureCell() {
        ImageHelper.stylizeUserImageView(self.userImageView)
        addCellTapGestureRecognizer()
        addUserTapGestureRecognizer()
    }

    private func stylizeCell() {
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
    }

    private func addCellTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("onTapCell:"))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    private func addUserTapGestureRecognizer() {
        self.userImageView.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("onTapUser:"))
        tapGestureRecognizer.delegate = self
        self.userImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    func onTapCell(sender: UITapGestureRecognizer? = nil) {
        self.delegate?.tweetCell!(self, didSelectTweet: self.tweet)
    }

    func onTapUser(sender: UITapGestureRecognizer? = nil) {
        self.delegate?.tweetCell!(self, didTapUser: (self.tweet?.user)!)
    }

}
