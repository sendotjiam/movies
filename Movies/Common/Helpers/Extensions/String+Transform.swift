//
//  String+Currency.swift
//  Movies
//
//  Created by Sendo Tjiam on 02/09/23.
//

import Foundation

extension String {
    func toCurrency(_ locale: String) -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: locale)
            formatter.groupingSeparator = "."
            formatter.numberStyle = .decimal
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    func getDateString(separator: Character) -> String {
        if self == "" || self.isEmpty {
            return ""
        }
        let splitString = self.split(separator: separator)
        var month = ""
        switch splitString[1] {
        case "01":
            month = "January"
        case "02":
            month = "February"
        case "03":
            month = "March"
        case "04":
            month = "April"
        case "05":
            month = "May"
        case "06":
            month = "June"
        case "07":
            month = "July"
        case "08":
            month = "August"
        case "09":
            month = "September"
        case "10":
            month = "October"
        case "11":
            month = "November"
        case "12":
            month = "December"
        default:
            month = ""
        }
        return "\(splitString[2]) \(month) \(splitString[0])"
    }
}
