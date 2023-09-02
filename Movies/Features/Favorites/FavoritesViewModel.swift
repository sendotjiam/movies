//
//  FavoritesViewModel.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift
import RxRelay

final class FavoritesViewModel {
    
    var loadingSubject = BehaviorRelay<Bool>(value: false)
    var movieListSubject = PublishSubject<Void>()
    
    var displayData = [Movie]()
    
    private let bag = DisposeBag()
    
    private let fetchUseCase: FetchFavoriteMovieListUseCaseProtocol
    private let deleteUseCase: DeleteFavoriteUseCaseProtocol
    
    init(fetchUseCase: FetchFavoriteMovieListUseCaseProtocol = FetchFavoriteMovieListUseCase(),
         deleteUseCase: DeleteFavoriteUseCaseProtocol = DeleteFavoriteUseCase()) {
        self.fetchUseCase = fetchUseCase
        self.deleteUseCase = deleteUseCase
    }
    
}

extension FavoritesViewModel: FavoritesViewModelProtocol {
    func onViewDidLoad() {
        fetchFavoriteMovies()
    }
    
    func onReload() {
        fetchFavoriteMovies()
    }
    
    func delete(by id: Int) {
        deleteMovie(by: id)
    }
}

extension FavoritesViewModel {
    private func fetchFavoriteMovies() {
        loadingSubject.accept(true)
        fetchUseCase.execute().subscribe({ [weak self] event in
            guard let self else { return }
            switch event {
            case .next(let models):
                self.displayData = models
                self.movieListSubject.onNext(())
            case .error(let error):
                self.movieListSubject.onError(error)
            case .completed: return
            }
            self.loadingSubject.accept(false)
        }).disposed(by: bag)
    }
    
    private func deleteMovie(by id: Int) {
        loadingSubject.accept(true)
        deleteUseCase.execute(by: id).subscribe({ [weak self] event in
            guard let self else { return }
            switch event {
            case .next(_):
                self.fetchFavoriteMovies()
            case .error(let error):
                self.movieListSubject.onError(error)
            case .completed: return
            }
            self.loadingSubject.accept(false)
        }).disposed(by: bag)
    }
}
