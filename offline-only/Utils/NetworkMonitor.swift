//
//  NetworkMonitor.swift
//  offline-only
//
//  Created by marc on 17.04.25.
//

import Foundation
import Network

@MainActor
final class NetworkMonitor: ObservableObject {
    @Published private(set) var isConnected = false

    private let monitor = NWPathMonitor()
    private let queue   = DispatchQueue(label: "NetworkMonitor")

    init() {
        // Set the initial value synchronously
        isConnected = monitor.currentPath.status == .satisfied

        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }

    deinit { monitor.cancel() }
}
