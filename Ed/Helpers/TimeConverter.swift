//
//  TimeConverter.swift
//  Ed
//
//  Created by Beera Naveen on 26/05/25.
//

import Foundation

func convertToIST(from isoString: String) -> String {
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    guard let date = isoFormatter.date(from: isoString) else {
        return isoString
    }

    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "dd-MM-yyyy"
    displayFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata") 

    return displayFormatter.string(from: date)
}
