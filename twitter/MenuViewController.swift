//
//  MenuViewController.swift
//  twitter
//
//  Created by Zachary Matthews on 2/25/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!

    var navigationControllers: [ContentNavigationController] = []
    var hamburgerViewController: HamburgerViewController!
    var user: User! = User.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        initMenuFields()
        tableView.delegate = self
        tableView.dataSource = self

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigationControllers = ContentControllerManager.initContentNavigationControllers(storyboard)
        hamburgerViewController.contentViewController = navigationControllers[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func initMenuFields() {
        ImageHelper.stylizeUserImageView(userImageView)
        self.bgImageView.image = ImageHelper.defaultBackgroundImage
        if let profileImageUrl = user.profileUrl {
            ImageHelper.setImageForView(profileImageUrl, placeholder: ImageHelper.defaultUserImage, imageView: self.userImageView, success: nil, failure: { (error) -> Void in
                print("\(error.localizedDescription)")
            })
        }
        self.userNameLabel.text = user.name as? String
        self.userHandleLabel.text = "@\(user.screenName!)"

    }

    @IBAction func onTapUserImage(sender: UITapGestureRecognizer) {
        print("tapped")
    }

}

extension MenuViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.navigationControllers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        let navigationController = navigationControllers[indexPath.row]
        cell.contentProperties = navigationController.contentProperties
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.hamburgerViewController.contentViewController = navigationControllers[indexPath.row]
    }
}

extension MenuViewController: UITableViewDelegate {}
