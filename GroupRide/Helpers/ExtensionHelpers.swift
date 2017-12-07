//
//  ExtensionHelpers.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/5/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit


extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}
