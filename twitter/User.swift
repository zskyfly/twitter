//
//  User.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: NSString?
    var screenName: NSString?
    var profileUrl: NSURL?
    var tagLine: NSString?

    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as? String
        self.screenName = dictionary["screen_name"] as? String
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            self.profileUrl = NSURL(string: profileUrlString)
        }
        self.tagLine = dictionary["description"] as? String
    }
}
