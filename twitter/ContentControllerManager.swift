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

    struct ContentProperties {

        init(menuLabel: String, identifier: String) {
            self.menuLabel = menuLabel
            self.navControllerIdentifier = identifier
        }

        var menuLabel: String!
        var navControllerIdentifier: String!
    }

    static let contentItems: [ContentProperties] = [
        ContentProperties(menuLabel: "Home Timeline", identifier: "HomeTimelineNavigationController"),
        ContentProperties(menuLabel: "Mentions Timeline", identifier: "MentionsTimelineNavigationController"),
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
            animations: { () -> Void in
                window?.rootViewController = hamburgerViewController
            },
            completion: nil
        )

    }
}