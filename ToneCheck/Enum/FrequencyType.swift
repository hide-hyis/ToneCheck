//
//  FrequencyType.swift
//  ToneCheck
//
//  Created by HIDEYASU ISHII on 2025/03/21.
//

import Foundation

internal enum FrequencyType {
    case low
    case heigh
    
    var isLow: Bool {
        return self == .low
    }
}
