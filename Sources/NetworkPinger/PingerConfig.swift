//
//  File.swift
//
//
//  Created by Muneer K K on 13/04/2024.
//

import Foundation

public struct PingerConfig {
    let interval: TimeInterval
    let timeout: TimeInterval

    public init(interval: TimeInterval, timeout: TimeInterval) {
        self.interval = interval
        self.timeout = timeout
    }
}
