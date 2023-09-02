//
//  BaseErrors.swift
//  Movies
//
//  Created by Sendo Tjiam on 01/09/23.
//

import Foundation

enum BaseErrors: Error, Equatable {
    case networkResponseError
    case decodeError
    case emptyDataError
    case httpError(_ code: Int)
    case anyError
    case noSelfError
    case urlError
    case notEmptyDataError
    
    static func == (lhs: BaseErrors, rhs: BaseErrors) -> Bool {
        switch (lhs, rhs) {
        case (.networkResponseError, .networkResponseError), (.decodeError, .decodeError), (.emptyDataError, .emptyDataError), (.httpError(_), .httpError(_)), (.anyError, .anyError), (.noSelfError, .noSelfError), (.urlError, .urlError), (.notEmptyDataError, .notEmptyDataError): return true
        default: return false
        }
    }
}
