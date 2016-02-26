//
//  Tweet.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    static let placeHolderText = "What's happening?"
    static let maxLength = 140
    static let acceptableLength = 1...maxLength

    var text: String?
    var createdAt: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User?
    var idStr: String?
    var id: Int?

    init(dictionary: NSDictionary) {
        self.text = dictionary["text"] as? String
        self.text = text?.stringByRemovingPercentEncoding
        self.retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        self.favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        self.idStr = dictionary["id_str"] as? String
        self.id = dictionary["id"] as? Int
        if let userDictionary = dictionary["user"] as? NSDictionary {
            self.user = User(dictionary: userDictionary)
        }
        if let createdAtString = dictionary["created_at"] as? String {
            self.createdAt = DateTimeHelper.sharedInstance.convertStringToDate(createdAtString)
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

    func getCreatedAtForDetail() -> String {
        return DateTimeHelper.sharedInstance.getDateStringForDetailView(self.createdAt)
    }

    func getCreatedAtForList() -> String {
        return DateTimeHelper.sharedInstance.getDateStringForListView(self.createdAt)
    }
}
