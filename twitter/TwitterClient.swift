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

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "RXq7WuE5mbKUq6GZ06mzp6VvX", consumerSecret: "lxiuL63ahhftZnEmwHpZr0XgEcAb5Zh6hjK2yBOW0ysgZAmOP9")

    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?

    func login(success: () -> (), failure: (NSError) -> ()) {
        self.loginSuccess = success
        self.loginFailure = failure

        let client = TwitterClient.sharedInstance
        client.deauthorize()
        client.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterephiphanies://oauth")!, scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Success fetchRequestTokenWithPath")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }, failure: { (error: NSError!) -> Void in
            self.loginFailure?(error)
        })
    }

    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        let client = TwitterClient.sharedInstance
        client.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Success fetchAccessTokenWithPath")
            self.loginSuccess?()

//            client.getHomeTimeline({ (tweets: [Tweet]) -> () in
//                print("Success getHomeTimeline: \(tweets.count) results")
//                for tweet in tweets {
//                    print("\(tweet.text)")
//                }
//                }, failure: { (error: NSError) -> () in
//                    print("Error getHomeTimeline: \(error.localizedDescription)")
//            })
//
//            client.getCurrentAccount({ (user: User) -> () in
//                print("Success getCurrentAccount")
//                print("\(user.name)")
//                print("\(user.tagLine)")
//                print("\(user.screenName)")
//                print("\(user.profileUrl)")
//                }, failure: { (error: NSError) -> () in
//                    print("Failure getCurrentAccount: \(error.localizedDescription)")
//            })

            }, failure: { (error: NSError!) -> Void in
                self.loginFailure?(error)
        })
    }

    func getHomeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.getTweetsFromArray(tweetDictionaries)
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }

    func getCurrentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    }
}
