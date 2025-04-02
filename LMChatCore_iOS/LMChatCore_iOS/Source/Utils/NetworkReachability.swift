import Network

/// A class to monitor network connectivity status
class NetworkReachability {
    private static let monitor = NWPathMonitor()
    private static var isConnectedToNetwork = false
    
    static var isConnected: Bool {
        return isConnectedToNetwork
    }
    
    static func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            isConnectedToNetwork = path.status == .satisfied
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    static func stopMonitoring() {
        monitor.cancel()
    }
} 
