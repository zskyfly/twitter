//
//  ImageHelper.swift
//  twitter
//
//  Created by Zachary Matthews on 2/23/16.
//  Copyright © 2016 zskyfly productions. All rights reserved.
//

import Foundation
import AFNetworking

class ImageHelper {

    static let defaultBackgroundImage = UIImage(named: "default_background")
    static let defaultUserImage = UIImage(named: "missing_user")

    static func setImageForView(url: NSURL?, placeholder: UIImage?, imageView: UIImageView, success: (() -> Void)?, failure: ((error: NSError) -> Void)?) {

        if let url = url {

            let urlRequest = NSURLRequest(URL: url)

            imageView.setImageWithURLRequest(urlRequest, placeholderImage: placeholder, success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) -> Void in
                imageView.image = image
                success?()
                }, failure: { (request: NSURLRequest, response: NSHTTPURLResponse?, error:NSError) -> Void in
                    failure?(error: error)
            })
        } else {
            imageView.image = placeholder
        }
    }

    static func stylizeUserImageView(view: UIImageView) {
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
    }
}
