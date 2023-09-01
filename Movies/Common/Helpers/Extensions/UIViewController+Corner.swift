//
//  UIViewController+Corner.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit

extension UIView {
    func addBorder(with width: CGFloat, color: CGColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color
    }
    
    func roundCorner(with radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
