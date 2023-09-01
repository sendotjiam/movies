//
//  Constants.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation

struct LocalConstants {
    static let itemManagedObject = ""
}

struct NetworkConstants {
    fileprivate static let apiKey = "b09b3146ed7f80b5c88403245c10a1e0"
    static let apiKeyPath = "api_key=\(NetworkConstants.apiKey)"
    static let baseUrl = "https://api.themoviedb.org/3"
}
