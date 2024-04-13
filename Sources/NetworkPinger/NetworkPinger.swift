import Foundation
import Combine
import Network
import SwiftyPing

@available(iOS 15.0, *)
public class NetworkPinger {
    private var cancellables = Set<AnyCancellable>()

    private let config: PingerConfig
    /// - Parameter configuration: A configuration object which can be used to customize pinging behavior.
    public init(config: PingerConfig) {
        self.config = config
    }

    public func ping(hosts: [String], count: Int) -> AnyPublisher<(String, Double?), Error> {
        let pingPublishers = hosts.map { host in
            self.startPinging(host: host, count: count)
                .catch { _ -> AnyPublisher<(String, Double?), Error> in
                    Just((host, nil))
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
        }
        return Publishers.MergeMany(pingPublishers)
            .eraseToAnyPublisher()
    }
}

@available(iOS 15.0, *)
extension NetworkPinger: PingProvider {
    public func startPinging(host: String, count: Int) -> AnyPublisher<(String, Double?), Error> {
        let subject = PassthroughSubject<(String, Double?), Error>()
        do {
            let pinger = try SwiftyPing(host: host, configuration: PingConfiguration(interval: config.interval, with: config.timeout), queue: DispatchQueue.global())
            pinger.targetCount = count
            pinger.observer = { response in
                subject.send((host, response.duration))
                if response.sequenceNumber == count {
                    subject.send(completion: .finished)
                }
            }
            try pinger.startPinging()
            return subject
                .handleEvents(receiveCancel: {
                    pinger.stopPinging()
                })
                .eraseToAnyPublisher()
        } catch {
            subject.send(completion: .failure(PingError.initializationFailed(host)))
            return subject.eraseToAnyPublisher()
        }
    }

}
