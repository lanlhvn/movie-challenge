//
//  UIView+Extension.swift
//  MovieChallenge
//
//  Created by Tequilan on 14/07/2022.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: 0, height: 6)
            layer.shadowRadius = newValue
            layer.shadowColor = UIColor.black.cgColor
        }
    }
}
