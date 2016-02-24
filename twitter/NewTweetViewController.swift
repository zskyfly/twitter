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
        let urlRequest = NSURLRequest(URL: self.user.profileUrl!)
        let placeHolder = UIImage(named: User.placeholderProfileImage)
        
//        userImageView.setImageWithURLRequest(urlRequest, placeholderImage: placeHolder, success: nil) {
//            (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) -> Void in
//                print("\(error.localizedDescription)")
//        }
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
