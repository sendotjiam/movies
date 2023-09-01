//
//  SearchMovieListUseCase.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift

protocol SearchMovieListUseCaseProtocol {
    func execute(keyword: String, page: Int) -> Observable<[Movie]>
}

final class SearchMovieListUseCase : SearchMovieListUseCaseProtocol {
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
    }
    
    func execute(keyword: String, page: Int) -> Observable<[Movie]>{
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines)
        return repository.searchMovieList(query: keyword, page: page).map({ responseModel -> [Movie] in
            return responseModel.results.map({ $0.toDomain() })
        })
    }
}
