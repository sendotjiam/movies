//
//  ApiClient.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

protocol ApiClient {
    func request(
        _ path: String,
        _ method : HTTPMethod,
        _ parameters: Parameters?,
        _ headers: HTTPHeaders?
    ) -> Observable<(HTTPURLResponse, Data)>
}

final class AFApiClient : ApiClient {
    
    func request(
        _ path: String,
        _ method : HTTPMethod,
        _ parameters: Parameters?,
        _ headers: HTTPHeaders?
    ) -> Observable<(HTTPURLResponse, Data)> {
        return Observable.create({ observer in
            let urlString = NetworkConstants.baseUrl + path
            guard let urlComponents = URLComponents(string: urlString),
                  let url = urlComponents.url else {
                observer.onError(BaseErrors.urlError)
                return Disposables.create()
            }
            AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers,
                interceptor: nil
            ).response { response in
                switch response.result {
                case .success(_) :
                    guard let httpResponse = response.response else {
                        observer.onError(BaseErrors.networkResponseError)
                        return
                    }
                    let statusCode = httpResponse.statusCode
                    guard let data = response.data else {
                        observer.onError(BaseErrors.emptyDataError)
                        return
                    }
                    guard (200...299).contains(statusCode) else {
                        observer.onError(BaseErrors.httpError(statusCode))
                        return
                    }
                    observer.onNext((httpResponse, data))
                    observer.onCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(BaseErrors.anyError)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        })
    }
}
