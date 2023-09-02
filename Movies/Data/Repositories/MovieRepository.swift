//
//  MovieRepository.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import Alamofire
import RxSwift

final class MovieRepository {
    
    private let apiClient: ApiClient
    
    init(with apiClient: ApiClient = AFApiClient()) {
        self.apiClient = apiClient
    }
}

extension MovieRepository: MovieRepositoryProtocol {
    func fetchMovieList(page: Int) -> Observable<MovieListResponseModel> {
        let path = "/movie/popular?\(NetworkConstants.apiKeyPath)&page=\(page)"
        return apiClient.request(path, .get, nil, nil).map({ _, data in
            do {
                let movieList = try JSONDecoder().decode(MovieListResponseModel.self, from: data)
                return movieList
            } catch {
                throw BaseErrors.decodeError
            }
        })
    }
    
    func searchMovieList(query: String, page: Int) -> Observable<MovieListResponseModel> {
        let path = "/search/movie?\(NetworkConstants.apiKeyPath)&query=\(query)&page=\(page)"
        return apiClient.request(path, .get, nil, nil).map({ _, data in
            do {
                let movieList = try JSONDecoder().decode(MovieListResponseModel.self, from: data)
                return movieList
            } catch {
                throw BaseErrors.decodeError
            }
        })
    }
    
    func getMovie(by id: Int) -> Observable<MovieDetailResponseModel> {
        let path = "/movie/\(id)?\(NetworkConstants.apiKeyPath)"
        return apiClient.request(path, .get, nil, nil).map({ _, data in
            do {
                let movieDetail = try JSONDecoder().decode(MovieDetailResponseModel.self, from: data)
                return movieDetail
            } catch {
                throw BaseErrors.decodeError
            }
        })
    }
}
