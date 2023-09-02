//
//  DetailViewModelProtocol.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift
import RxRelay

protocol DetailViewModelProtocol {
    var loadingSubject: BehaviorRelay<Bool> { get }
    var addFavoriteSubject: PublishSubject<Void> { get }
    var movieDetailSubject: PublishSubject<Void> { get }
    
    var displayData: MovieDetail? { get }
    
    func onViewDidLoad()
    func addToFavorite()
}
