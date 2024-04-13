import Foundation
import Combine
import Network
import SwiftyPing


@available(iOS 15.0, *)
public class NetworkPingService {
	private var cancellables = Set<AnyCancellable>()

	// Using AnyPublisher to abstract details and allow usage in both Swift and Objective-C.
	public func ping(hosts: [String], count: Int) -> AnyPublisher<(String, Double?), Error> {
			let pingPublishers = hosts.map { host in
				self.ping(host: host, count: count)
					.catch { error -> AnyPublisher<(String, Double?), Error> in
						Just((host, nil))
							.setFailureType(to: Error.self)
							.eraseToAnyPublisher()
					}
			}
			return Publishers.MergeMany(pingPublishers)
				.eraseToAnyPublisher()
		}

	private func ping(host: String, count: Int) -> AnyPublisher<(String, Double?), Error> {
			let subject = PassthroughSubject<(String, Double?), Error>()

		guard let pinger = try? SwiftyPing(host: host, configuration: PingConfiguration(interval: 0.5, with: TimeInterval(count)), queue: DispatchQueue.global()) else {
				subject.send(completion: .failure(NetworkPingError.initializationFailed(host)))
				return subject.eraseToAnyPublisher()
			}
		pinger.targetCount = count
		pinger.observer = { response in
			subject.send((host, response.duration))
			subject.send(completion: .finished)
		}
		do {
			try pinger.startPinging()
		} catch {
			subject.send(completion: .failure(NetworkPingError.pingFailed(host, error)))
		}

		return subject.eraseToAnyPublisher()
	}
}


public enum NetworkPingError: Error, CustomStringConvertible {
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

