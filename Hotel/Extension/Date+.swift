//
//  Date+.swift
//  Hotel
//
//  Created by yc on 2022/06/24.
//

import Foundation

extension Date {
    /// convert Date to  String
    var toString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "YY.MM.dd(E) HH:mm에 등록"
        return dateFormatter.string(from: self)
    }
}
