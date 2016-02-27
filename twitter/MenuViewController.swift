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

    var navigationControllers: [ContentNavigationController] = []
    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

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
