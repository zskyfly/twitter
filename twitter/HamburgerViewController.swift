//
//  HamburgerViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/25/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    let MENU_ANIMATION_DURATION = 0.3

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var originalLeftMargin: CGFloat!

    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }

    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()

            if oldContentViewController != nil {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }

            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)

            hideMenu()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Menu Movement

    // Recognize gestures related to moving the menu
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)

        switch sender.state {
        case .Began:
            self.originalLeftMargin = self.leftMarginConstraint.constant

        case .Changed:
            slideContentWithTranslation(translation)

        case .Ended:
            handleMenuVisibility(velocity)

        default:
            return
        }
    }

    // Manually move the menu
    private func slideContentWithTranslation(translation: CGPoint) {
        self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x
    }

    // Animate menu movements
    private func handleMenuVisibility(velocity: CGPoint) {
        if velocity.x > 0 {
            showMenu()
        } else {
            hideMenu()
        }
    }

    private func hideMenu() {
        let hideX = CGFloat(0)
        animateContentWithPosition(hideX)
    }

    private func showMenu() {
        let showX = CGFloat(self.view.frame.size.width - 50.0)
        animateContentWithPosition(showX)
    }

    private func animateContentWithPosition(xCoordinate: CGFloat) {
        UIView.animateWithDuration(self.MENU_ANIMATION_DURATION) {
            self.leftMarginConstraint.constant = xCoordinate
            self.view.layoutIfNeeded()
        }
    }
}
