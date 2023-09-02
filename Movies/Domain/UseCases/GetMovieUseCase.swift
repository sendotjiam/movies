//
//  GetMovieUseCase.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift

protocol GetMovieUseCaseProtocol {
    func execute(id: Int) -> Observable<MovieDetail>
}

final class GetMovieUseCase : GetMovieUseCaseProtocol{
    
    private let repository: MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.repository = repository
    }
    
    func execute(id: Int) -> Observable<MovieDetail>{
        return repository.getMovie(by: id).map({ responseModel -> MovieDetail in
            return responseModel.toDomain()
        })
    }
    
}
