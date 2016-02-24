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

    static let statusesUpdate = "1.1/statuses/update.json"
    static let statusesHomeTimeline = "1.1/statuses/home_timeline.json"
    static let accountVerifyCredentials = "1.1/account/verify_credentials.json"

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
        GET(TwitterClient.statusesHomeTimeline, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(tweetDictionaries)
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET(TwitterClient.accountVerifyCredentials, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }

    func statusUpdate(status: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        let data = [
            "status": status
        ]

        POST(TwitterClient.statusesUpdate, parameters: data, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
}
