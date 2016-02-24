//
//  Tweet.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var createdAt: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User?
    var idStr: String?

    init(dictionary: NSDictionary) {
        self.text = dictionary["text"] as? String
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        self.idStr = dictionary["id_str"] as? String
        if let userDictionary = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: userDictionary)
        }
        let createdAtString = dictionary["created_at"] as? String
        if let createdAtString = createdAtString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM HH:mm:ss Z y"
            self.createdAt = formatter.dateFromString(createdAtString)
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }

    func getCreatedAtString() -> String {
        return ""
    }
}
