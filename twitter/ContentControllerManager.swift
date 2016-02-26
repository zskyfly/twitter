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

    struct ContentProperties {

        init(menuLabel: String, identifier: String) {
            self.menuLabel = menuLabel
            self.navControllerIdentifier = identifier
        }

        var menuLabel: String!
        var navControllerIdentifier: String!
    }

    static let contentItems: [ContentProperties] = [
        ContentProperties(menuLabel: "Home Timeline", identifier: "TweetsNavigationController"),
        ContentProperties(menuLabel: "Red", identifier: "RedNavigationController"),
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

    class func initHamburger() -> (HamburgerViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let hamburgerViewController = storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController") as! HamburgerViewController
        //        let hamburgerViewController = window!.rootViewController as! HamburgerViewController

        let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuViewController.hamburgerViewController = hamburgerViewController
        hamburgerViewController.menuViewController = menuViewController
        return hamburgerViewController
    }
}
