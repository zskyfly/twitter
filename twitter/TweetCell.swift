//
//  TweetCell.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    var tweet: Tweet! {
        didSet {
            if let user = tweet.user {
                userImageView.setImageWithURL(user.profileUrl!)
                print("Setting image to url: \(user.profileUrl!)")
                userNameLabel.text = user.name as? String
                userHandleLabel.text = "@\(user.screenName!)"
            }
            tweetTextLabel.text = tweet.text as? String
//            createdAtLabel.text = tweet.createdAt as! String
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 3
        userImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
