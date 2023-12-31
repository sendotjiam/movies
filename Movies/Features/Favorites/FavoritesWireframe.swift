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
    
    func showBottomSheet(from: UIViewController, type: BottomSheetType) {
        let vc = BottomSheetViewController()
        vc.configure(type: type)
        vc.modalPresentationStyle = .overCurrentContext
        from.present(vc, animated: false)
    }
    
    func showAlert(from: UIViewController, title: String, body: String) {
        let alert = from.createAlert(title, body, nil)
        from.present(alert, animated: true)
    }
}
