//
//  UIScrollView+Reload.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit

extension UICollectionView {
    func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
}
