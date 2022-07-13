//
//  BaseNavigationViewController.swift
//  movieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    var isLightStatus = Bool()

    func makeLightStatus() {
        isLightStatus = true
        setNeedsStatusBarAppearanceUpdate()
    }

    func makeDefaultStatus() {
        isLightStatus = false
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isLightStatus {
            return .lightContent
        } else {
            return .darkContent
        }
    }
    
    fileprivate func transparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        transparentNavigationBar()
    }
}

