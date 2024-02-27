//
//  UIViewController + Extension.swift
//  FavDog
//
//  Created by Manjunath Anawal on 24/02/24.
//

import SwiftUI

extension UIViewController {
    var visibleViewController: UIViewController? {
        if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        }
        return self
    }
}
