//
//  User.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let defaultsKeyCurrentUserData = "current_user_data"
    static let notificationEventUserDidLogout = "user_did_logout"
    static let placeholderProfileImage = "missing_user"

    static var _currentUser: User?

    var dictionary: NSDictionary?
    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var tagLine: NSString?

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        self.name = dictionary["name"] as? String
        self.screenName = dictionary["screen_name"] as? String
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            self.profileUrl = NSURL(string: profileUrlString)
        }
        self.tagLine = dictionary["description"] as? String
    }

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey(User.defaultsKeyCurrentUserData) as? NSData
                if let userData = userData {
                let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        } set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let userData = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(userData, forKey: User.defaultsKeyCurrentUserData)
            } else {
                defaults.setObject(nil, forKey: User.defaultsKeyCurrentUserData)
            }
        }
    }
}
