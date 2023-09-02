//
//  FavoritesViewModelProtocol.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxRelay
import RxSwift

protocol FavoritesViewModelProtocol {
    var loadingSubject: BehaviorRelay<Bool> { get }
    var movieListSubject: PublishSubject<Void> { get }
    
    var displayData: [Movie] { get }
    
    func onViewDidLoad()
    func onReload()
    func delete(by id: Int)
}
