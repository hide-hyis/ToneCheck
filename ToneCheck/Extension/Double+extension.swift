//
//  Double+extension.swift
//  ToneCheck
//
//  Created by HIDEYASU ISHII on 2025/04/14.
//

import Foundation

extension Double {
    
    /// デシベル (dB) を 振幅 (0.0~1.0) に変換
    func decibelsToAmplitude() -> Self {
        return pow(10, self / 20)
    }
}
