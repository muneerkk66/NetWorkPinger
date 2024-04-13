//
//  File.swift
//
//
//  Created by Muneer K K on 13/04/2024.
//

import Foundation
import Combine
@testable import NetworkPinger

@available(iOS 15.0, *)
class MockPingProvider: PingProvider {
    var responsePublisher: AnyPublisher<(String, Double?), Error>!

    func startPinging(host: String, count: Int) -> AnyPublisher<(String, Double?), Error> {
        return responsePublisher
    }
}
