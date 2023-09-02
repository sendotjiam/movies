//
//  FavoritesWireframe.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit

final class FavoritesWireframe {
    
    init() {}
    
    func create() -> FavoritesViewController {
        let vm = FavoritesViewModel()
        let vc = FavoritesViewController(with: vm)
        return vc
    }
    
    func show(from: UIViewController) {
        let vc = create()
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
}
