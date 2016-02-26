//
//  UserProfileView.swift
//  twitter
//
//  Created by Zachary Matthews on 2/26/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class UserProfileView: UIView {

    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!

    @IBOutlet weak var followingCountLabel: UILabel!
    var user: User! {
        didSet {
            if let backgroundImageUrl = user.profileBackgroundImageUrl {
                ImageHelper.setImageForView(backgroundImageUrl, placeholder: UIImage(named: "missing_user"), imageView: self.backgroundImageView, success: nil) { (error) -> Void in
                    print("\(error.localizedDescription)")
                }
            }

            if let userImageUrl = user.profileUrl {
                ImageHelper.setImageForView(userImageUrl, placeholder: UIImage(named: "missing_user"), imageView: self.userImageView, success: nil) { (error) -> Void in
                    print("\(error.localizedDescription)")
                }
            }
            self.userNameLabel.text = user.name as? String
            self.userHandleLabel.text = "@" + (user.screenName as?String)!
            self.followerCountLabel.text = "\(user.followersCount)"
            self.followingCountLabel.text = "\(user.friendsCount)"
            self.tweetCountLabel.text = "\(user.tweetCount)"
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        let nib = UINib(nibName: "UserProfileView", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        self.contentView.frame = bounds
        self.userImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.userImageView.clipsToBounds = true
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroundImageView.clipsToBounds = true
        ImageHelper.stylizeUserImageView(self.userImageView)
        addSubview(contentView)
    }
}
