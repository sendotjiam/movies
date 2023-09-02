//
//  HomeWireframe.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit

final class HomeWireframe {
    
    init() {}
    
    func create() -> HomeViewController {
        let vm = HomeViewModel()
        let vc = HomeViewController(with: vm)
        return vc
    }
    
    func showAlert(from: UIViewController, title: String, body: String) {
        let alert = from.createAlert(title, body, nil)
        from.present(alert, animated: true)
    }
}
