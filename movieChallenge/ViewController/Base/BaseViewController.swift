//
//  BaseViewController.swift
//  movieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setProfileBarButton() {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "defaultProfilePicture")
        button.setImage(image?.resizeImage(35, opaque: false), for: .normal)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
    }
}
