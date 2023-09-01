//
//  HomeWireframe.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation

final class HomeWireframe {
    
    init() {}
    
    func create() -> HomeViewController {
        let vm = HomeViewModel()
        let vc = HomeViewController(with: vm)
        return vc
    }
    
}
