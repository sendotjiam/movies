//
//  DetailWireframe.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import UIKit

final class DetailWireframe {
    
    init() {}
    
    func create(id: Int) -> DetailViewController {
        let vm = DetailViewModel(id: id)
        let vc = DetailViewController(with: vm)
        return vc
    }
    
    func show(from: UIViewController, with id: Int, isFromFavorite: Bool = false) {
        let vc = create(id: id)
        vc.isFromFavorite = isFromFavorite
        from.navigationController?.pushViewController(vc, animated: true)
    }

    func showBottomSheet(from: UIViewController, type: BottomSheetType) {
        let vc = BottomSheetViewController()
        vc.configure(type: type)
        vc.modalPresentationStyle = .overCurrentContext
        from.present(vc, animated: false)
    }
    
    func showAlert(from: UIViewController, title: String, body: String, handler : ((UIAlertAction) -> Void)?) {
        let alert = from.createAlert(title, body, handler)
        from.present(alert, animated: true)
    }
}
