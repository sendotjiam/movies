//
//  RemoteFetchMoviesUseCase.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift

protocol FetchMovieListUseCaseProtocol {
    func execute(page: Int) -> Observable<[Movie]>
}

final class FetchMovieListUseCase : FetchMovieListUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
    }
    
    func execute(page: Int) -> Observable<[Movie]>{
        return repository.fetchMovieList(page: page).map({ responseModel -> [Movie] in
            return responseModel.results.map({ $0.toDomain() })
        })
    }
}
