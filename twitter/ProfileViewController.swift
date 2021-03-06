//
//  ProfileViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/26/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: User?
    @IBOutlet weak var userProfileView: UserProfileView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewContent()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        UIView.animateWithDuration(3.0, animations: { () -> Void in
//            self.navigationController?.navigationBarHidden = true
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        }, completion: nil)

    }

//    override func prefersStatusBarHidden() -> Bool {
//        return navigationController?.navigationBarHidden == true
//    }
//
//    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
//        return UIStatusBarAnimation.Slide
//    }

    func configureViewContent() {
        if let user = self.user {
            userProfileView.user = user
//            navigationController?.hidesBarsOnTap = true
        } else {
            userProfileView.user = User._currentUser
        }
    }
}
