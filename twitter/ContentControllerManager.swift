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

    static let homeMenuImage = UIImage(named: "home")
    static let mentionsMenuImage = UIImage(named: "megaphone")
    static let profileMenuImage = UIImage(named: "profile")

    // MARK: - Hamburger Menu Configuration

    struct ContentProperties {
        var menuLabel: String!
        var navControllerIdentifier: String!
        var navBarColor: UIColor!
        var navImage: UIImage?

        init(menuLabel: String, identifier: String, navBarColor: UIColor? = nil, navImage: UIImage? = nil) {
            self.menuLabel = menuLabel
            self.navControllerIdentifier = identifier
            if let navBarColor = navBarColor {
                self.navBarColor = navBarColor
            }
            if let navImage = navImage {
                self.navImage = navImage
            }
        }
    }

    static let contentItems: [ContentProperties] = [
        ContentProperties(menuLabel: "Home", identifier: "HomeTimelineNavigationController", navBarColor: nil, navImage: ContentControllerManager.homeMenuImage),
        ContentProperties(menuLabel: "Mentions", identifier: "MentionsTimelineNavigationController", navBarColor: nil, navImage: ContentControllerManager.mentionsMenuImage),
        ContentProperties(menuLabel: "Profile", identifier: "ProfileNavigationController", navBarColor: MiscHelper.getUIColor(MiscHelper.twitterDarkGrey), navImage: ContentControllerManager.profileMenuImage),
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
        navBarColor: MiscHelper.getUIColor(MiscHelper.twitterDarkGrey)
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

    static func initNewProfileViewController() -> ProfileViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
    }
}
