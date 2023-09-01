//
//  UIView+Gradients.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit

extension UIView {
    func addVerticalGradient(topColor: UIColor, bottomColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [bottomColor.cgColor, topColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
