//
//  AppDelegate.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("\(url.description)")
        let requestToken = BDBOAuth1Credential(queryString: url.query)

        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "RXq7WuE5mbKUq6GZ06mzp6VvX", consumerSecret: "lxiuL63ahhftZnEmwHpZr0XgEcAb5Zh6hjK2yBOW0ysgZAmOP9")

        twitterClient.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in

            twitterClient.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                print("response: \(response)")
                let user = response as! NSDictionary
                print ("\(user["name"])")
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("error \(error.localizedDescription)")
            })

            twitterClient.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = response as! [NSDictionary]
                for tweet in tweets {
                    print("\(tweet["text"])")
                }
                }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("error GET /1.1/statuses/home_timeline.json: \(error.localizedDescription)")
            })


            }) { (error: NSError!) -> Void in
                print("error receiving accessToken: \(error.localizedDescription)")
        }

        return true
    }
}

