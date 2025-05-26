//
//  TimeConverter.swift
//  Ed
//
//  Created by Beera Naveen on 26/05/25.
//

import Foundation

func convertToIST(from isoString: String) -> String {
    // Input formatter for ISO string (Z means UTC)
    let isoFormatter = ISO8601DateFormatter()
    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

    guard let date = isoFormatter.date(from: isoString) else {
        return isoString // return original if parsing fails
    }

    // Output formatter for desired IST format
    let displayFormatter = DateFormatter()
    displayFormatter.dateFormat = "dd-MM-yyyy"
    displayFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata") // IST

    return displayFormatter.string(from: date)
}
