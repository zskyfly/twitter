//
//  LoginViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/22/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.setTitleColor(MiscHelper.getUIColor(MiscHelper.twitterWhite), forState: UIControlState.Normal)
        self.loginButton.layer.borderColor = MiscHelper.getCGColor(MiscHelper.twitterWhite)
        self.loginButton.layer.borderWidth = 1.0
        self.loginButton.layer.cornerRadius = 3.0
        self.loginButton.titleEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        TwitterClient.sharedInstance.login({ () -> () in
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }, failure:
        { (error: NSError) -> () in
                print("Failure logging in \(error.localizedDescription)")
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
