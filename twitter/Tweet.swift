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
        if let createdAtString = dictionary["created_at"] as? String {
            self.createdAt = DateTimeHelper.sharedInstance.convertStringToDate(createdAtString)
            let newString = DateTimeHelper.sharedInstance.convertDateToString(self.createdAt!, formatString: nil, formatStyle: DateTimeHelper.detailViewFormat)
            print("converting \(createdAtString) to \(self.createdAt) and back to \(newString)")
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
