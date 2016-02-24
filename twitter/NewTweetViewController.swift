//
//  NewTweetViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/23/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {

    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewProperties()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setViewProperties() {
        if let name = self.user.name as? String {
            self.userNameLabel.text = name
        }
        if let userHandle = self.user.screenName as? String {
            self.userHandleLabel.text = userHandle
        }



        //        let urlRequest = NSURLRequest(URL: self.user.profileUrl!)
        //        let placeHolderImage = UIImage(named: User.placeholderProfileImage)
        
    }

}
