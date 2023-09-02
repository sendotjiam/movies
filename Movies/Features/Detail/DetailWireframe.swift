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
        from.navigationController?.present(vc, animated: true)
    }

}
