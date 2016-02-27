//
//  MenuCell.swift
//  twitter
//
//  Created by Zachary Matthews on 2/25/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var navImageView: UIImageView!
    @IBOutlet weak var menuItemLabel: UILabel!


    var contentProperties: ContentControllerManager.ContentProperties! {
        didSet {
            menuItemLabel.text = contentProperties.menuLabel
            navImageView.image = contentProperties.navImage
        }
    }



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}