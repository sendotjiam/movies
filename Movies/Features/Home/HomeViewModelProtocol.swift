//
//  HomeViewModelProtocol.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelProtocol {
    var isRequestLoadMore: Bool { get }
    var showInitialLoadingSubject: BehaviorRelay<Bool> { get }
    var movieListSubject: PublishSubject<Void> { get }
    
    var displayData: [Movie] { get }
    
    func onViewDidLoad()
    func onLoadMore()
}
