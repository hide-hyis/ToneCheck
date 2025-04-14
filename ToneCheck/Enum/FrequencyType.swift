//
//  FrequencyType.swift
//  ToneCheck
//
//  Created by HIDEYASU ISHII on 2025/03/21.
//

import Foundation

internal enum FrequencyType: Double {
    case low = 1000
    case heigh = 2000
    
    var isLow: Bool {
        return self == .low
    }
}
