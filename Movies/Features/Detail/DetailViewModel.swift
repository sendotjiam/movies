//
//  DetailViewModel.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel {
    
    var loadingSubject = BehaviorRelay<Bool>(value: false)
    var addFavoriteSubject = PublishSubject<Void>()
    var movieDetailSubject = PublishSubject<Void>()
    
    var displayData : MovieDetail?
    
    private let bag = DisposeBag()
    
    private let fetchUseCase : GetMovieUseCaseProtocol
    private let addFavoriteUseCase : AddFavoriteUseCaseProtocol
    private let movieId: Int
    
    init(with fetchUseCase: GetMovieUseCaseProtocol = GetMovieUseCase(),
         addFavoriteUseCase: AddFavoriteUseCaseProtocol = AddFavoriteUseCase(),
         id: Int) {
        self.fetchUseCase = fetchUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.movieId = id
    }
    
}

extension DetailViewModel: DetailViewModelProtocol {
    func onViewDidLoad() {
        loadingSubject.accept(true)
        fetchUseCase.execute(id: movieId).subscribe({ [weak self] event in
            switch event {
            case .next(let model):
                self?.displayData = model
                self?.movieDetailSubject.onNext(())
            case .error(let error):
                self?.movieDetailSubject.onError(error)
            case .completed: return
            }
            self?.loadingSubject.accept(false)
        }).disposed(by: bag)
    }
    
    func addToFavorite() {
        if let model = displayData {
            loadingSubject.accept(true)
            let movie = Movie(id: model.id, posterPath: model.posterPath, releaseDate: model.releaseDate, title: model.title, popularity: model.popularity, originalLanguage: model.originalLanguage)
            addFavoriteUseCase.execute(model: movie).subscribe({ [weak self] event in
                switch event {
                case .next(_):
                    self?.addFavoriteSubject.onNext(())
                case .error(let error):
                    self?.addFavoriteSubject.onError(error)
                case .completed: return
                }
                self?.loadingSubject.accept(false)
            }).disposed(by: bag)
        }
    }
}
