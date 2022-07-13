//
//  Helper.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import ZVProgressHUD

struct Helper {
    static func showLoading() {
        ZVProgressHUD.show()
    }
    
    static func dismissLoading() {
        ZVProgressHUD.dismiss()
    }
}
