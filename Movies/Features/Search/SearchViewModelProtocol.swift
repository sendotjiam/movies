//
//  SearchViewModelProtocol.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift
import RxRelay

protocol SearchViewModelProtocol {
    var isRequestLoadMore: Bool { get }
    var movieListSubject: PublishSubject<Void> { get }
    
    var displayData: [Movie] { get }
    
    func onSearch(keyword: String)
    func onLoadMore()
}
