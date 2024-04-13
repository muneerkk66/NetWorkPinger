import XCTest
import Combine
@testable import NetworkPinger

@available(iOS 15.0, *)
final class NetworkPingerTests: XCTestCase {
    private var provider: MockPingProvider!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        provider = MockPingProvider()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        provider = nil
        super.tearDown()
    }

    func testPingSuccess() {
        let host = "example.com"
        let expectedDuration = 0.035
        provider.responsePublisher = Just((host, expectedDuration))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        provider.startPinging(host: host, count: 1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Test failed with error: \(error)")
                }
            }, receiveValue: { (hostReceived, duration) in
                XCTAssertEqual(hostReceived, host, "Host should match")
                XCTAssertEqual(duration, expectedDuration, "Duration should match the expected value")
            })
            .store(in: &cancellables)
    }

    func testPingFailure() {
        let host = "nonexistent.host"
        let error = PingError.unknownHost(host)
        provider.responsePublisher = Fail(outputType: (String, Double?).self, failure: error)
            .eraseToAnyPublisher()
        let expectation = XCTestExpectation(description: "Ping should fail")
        // Execution
        provider.startPinging(host: host, count: 1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Test should not finish successfully for a nonexistent host")
                case .failure(let receivedError):
                    if let pingError = receivedError as? PingError,
                       case .unknownHost(let hostname) = pingError,
                       hostname == host {
                        expectation.fulfill()
                    } else {
                        XCTFail("Received error is not as expected: \(receivedError)")
                    }
                }
            }, receiveValue: { _, _ in
                XCTFail("Should not receive a value on failure")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
