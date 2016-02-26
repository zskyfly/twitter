//
//  ContentControllerManager.swift
//  twitter
//
//  Created by Zachary Matthews on 2/25/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import Foundation
import UIKit

class ContentControllerManager {

    static let loginTransitionDuration = 0.5

    // MARK: - Hamburger Menu Configuration

    struct ContentProperties {
        var menuLabel: String!
        var navControllerIdentifier: String!

        init(menuLabel: String, identifier: String) {
            self.menuLabel = menuLabel
            self.navControllerIdentifier = identifier
        }
    }

    static let contentItems: [ContentProperties] = [
        ContentProperties(menuLabel: "Profile", identifier: "ProfileNavigationController"),        
        ContentProperties(menuLabel: "Home", identifier: "HomeTimelineNavigationController"),
        ContentProperties(menuLabel: "Mentions", identifier: "MentionsTimelineNavigationController"),
    ]

    class func initContentNavigationControllers(storyboard: UIStoryboard) -> [ContentNavigationController] {
        var navigationControllers: [ContentNavigationController] = []

        for contentItem in contentItems {
            let navigationController = storyboard.instantiateViewControllerWithIdentifier(contentItem.navControllerIdentifier) as! ContentNavigationController
            navigationController.contentProperties = contentItem
            navigationControllers.append(navigationController)
        }
        return navigationControllers
    }

    class func initHamburger() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = appDelegate.window

        let hamburgerViewController = storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController") as! HamburgerViewController
        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController

        menuViewController.hamburgerViewController = hamburgerViewController
        hamburgerViewController.menuViewController = menuViewController

        UIView.transitionWithView(
            window!,
            duration: ContentControllerManager.loginTransitionDuration,
            options: UIViewAnimationOptions.TransitionFlipFromRight,
            animations: {
                () -> Void in
                window?.rootViewController = hamburgerViewController
            },
            completion: nil
        )
    }

    /*
    // MARK: - Reusable TweetsViewController
    */

    enum TweetsControllerType: String {
        case Home = "HomeTimelineViewController"
        case Mentions = "MentionsTimelineViewController"
    }

    struct TweetsViewControllerProperties {
        var navTitle: String!
        var apiCall: (oldestTweet: Tweet?, success: ([Tweet]) -> (), failure: (NSError) -> ()) -> ()
        var storyboardId: String!
        var navBarColor: UIColor!

        // properties shared by all TweetsViewControllers
        let estimatedRowHight: CGFloat = 100.0

        init(navTitle: String,
            apiCall: (oldestTweet: Tweet?, success: ([Tweet]) -> (), failure: (NSError) -> ()) -> (),
            storyboardId: String,
            navBarColor: UIColor? = nil
        ) {
            self.navTitle = navTitle
            self.apiCall = apiCall
            self.storyboardId = storyboardId
            self.navBarColor = MiscHelper.getUIColor(MiscHelper.twitterBlue)
            if let navBarColor = navBarColor {
                self.navBarColor = navBarColor
            }
        }
    }

    static let homeTimelineProperties = TweetsViewControllerProperties(
        navTitle: "Home",
        apiCall: TwitterClient.sharedInstance.homeTimeline,
        storyboardId: "HomeTimelineViewController"
    )

    static let mentionsTimelineProperties = TweetsViewControllerProperties(
        navTitle: "Mentions",
        apiCall: TwitterClient.sharedInstance.mentionsTimeline,
        storyboardId: "MentionsTimelineViewController",
        navBarColor: MiscHelper.getUIColor(MiscHelper.twitterMediumGrey)
    )

    static func getTweetsControllerProperties(controllerType: TweetsControllerType) -> TweetsViewControllerProperties {
        switch controllerType {
        case .Home:
            return homeTimelineProperties

        case .Mentions:
            return mentionsTimelineProperties
        }
    }

    /*
    // MARK: - Instantiate and return view controllers
    */

    static func initTweetDetailViewController() -> TweetDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("TweetDetailViewController") as! TweetDetailViewController
    }

    static func initNewTweetViewController() -> NewTweetViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("NewTweetViewController") as! NewTweetViewController
    }
}
