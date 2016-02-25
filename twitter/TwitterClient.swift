//
//  TwitterClient.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let baseUrl = "https://api.twitter.com"
    static let consumerKey = "RXq7WuE5mbKUq6GZ06mzp6VvX"
    static let consumerSecret = "lxiuL63ahhftZnEmwHpZr0XgEcAb5Zh6hjK2yBOW0ysgZAmOP9"
    static let fetchRequestTokenPath = "oauth/authorize"
    static let accessTokenPath = "oauth/access_token"
    static let callBackUrlScheme = "twitterephiphanies://oauth"

    static let accountVerifyCredentialsPath = "1.1/account/verify_credentials.json"
    static let statusesHomeTimelinePath = "1.1/statuses/home_timeline.json"
    static let statusesUpdatePath = "1.1/statuses/update.json"
    static func statusesRetweetPathWithId (statusId: String) -> (String) {
        return "1.1/statuses/retweet/:id.json".stringByReplacingOccurrencesOfString("%id%", withString: statusId)
    }
    static func statusesUnretweetPathWithId (retweetStatusId: String) -> (String) {
        return "1.1/statuses/unretweet/:id.json".stringByReplacingOccurrencesOfString("%id%", withString: retweetStatusId)
    }
    static let favoriteCreatePath = "1.1/favorites/create.json"
    static let favoriteDestroyPath = "1.1/favorites/destroy.json"

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: TwitterClient.baseUrl)!, consumerKey: TwitterClient.consumerKey, consumerSecret: TwitterClient.consumerSecret)

    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?

    func login(success: () -> (), failure: (NSError) -> ()) {
        self.loginSuccess = success
        self.loginFailure = failure

        let client = TwitterClient.sharedInstance
        client.deauthorize()
        client.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: TwitterClient.callBackUrlScheme)!, scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "\(TwitterClient.baseUrl)/\(TwitterClient.fetchRequestTokenPath)?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }, failure: { (error: NSError!) -> Void in
            self.loginFailure?(error)
        })
    }

    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.notificationEventUserDidLogout, object: nil)
    }

    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        let client = TwitterClient.sharedInstance
        client.fetchAccessTokenWithPath(TwitterClient.accessTokenPath, method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
        }, failure: { (error: NSError!) -> Void in
            self.loginFailure?(error)
        })
    }

    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET(TwitterClient.statusesHomeTimelinePath, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(tweetDictionaries)
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET(TwitterClient.accountVerifyCredentialsPath, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }

    func statusUpdate(status: String, replyStatusId: String? = nil, success: ((Tweet) -> ())?, failure: ((NSError) -> ())?) {

        var data = [
            "status": status
        ]
        if let replyStatusId = replyStatusId {
            data["in_reply_to_status_id"] = replyStatusId
        }

        POST(TwitterClient.statusesUpdatePath, parameters: data, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success?(tweet)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure?(error)
        })
    }

    func favoriteCreate(statusId: String, success: ((Tweet) -> ())?, failure: ((NSError) -> ())?) {

        let data = [
            "id": statusId
        ]

        POST(TwitterClient.favoriteCreatePath, parameters: data, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success?(tweet)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure?(error)
        })
    }
}
