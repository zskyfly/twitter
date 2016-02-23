//
//  TwitterDateFormatter.swift
//  twitter
//
//  Created by Zachary Matthews on 2/23/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class TwitterDateFormatter: NSDateFormatter {
    static let sharedInstance = TwitterDateFormatter()

    func getHoursBeforeNowString(date: NSDate) -> String {
        // let dateFormatter = TwitterDateFormatter.sharedInstance
        // TODO: return string for number of hours before now
        return "5h"
    }

    func getHoursBeforeNow(date: NSDate) -> Int {
        // TODO: calculate num hours earlier than current time
        return 10
    }
}
