//
//  File.swift
//
//
//  Created by Muneer K K on 13/04/2024.
//

import Foundation
import Combine
import Network
import SwiftyPing

@available(iOS 15.0, *)
public protocol PingProvider {
    func startPinging(host: String, count: Int) -> AnyPublisher<(String, Double?), Error>
}
