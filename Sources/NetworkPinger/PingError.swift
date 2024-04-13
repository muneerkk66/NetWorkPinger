//
//  File.swift
//
//
//  Created by Muneer K K on 13/04/2024.
//

import Foundation

public enum PingError: Error, CustomStringConvertible {
    case initializationFailed(String)
    case pingFailed(String, Error)
    case unknownHost(String)

    public var description: String {
        switch self {
        case .initializationFailed(let host):
            return "Failed to initialize pinger for \(host)."
        case .pingFailed(let host, let error):
            return "Failed to ping \(host): \(error.localizedDescription)"
        case .unknownHost(let host):
            return "Unknown host \(host)."
        }
    }
}
