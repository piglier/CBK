//
//  ServiceMonitor.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation
import os.log

protocol ServiceMonitorProtocol {
    
    var queue: DispatchQueue { get }
    
    func didCreateRequest(path: String)
    func didReceive(responseData: Data)
    func didReceive(error: Error)
}

extension ServiceMonitorProtocol {
    
    func didCreateRequest(path: String) {}
    func didReceive(responseData: Data) {}
    func didReceive(error: Error) {}
}

final class CompositeServiceMonitor: ServiceMonitorProtocol {
    
    let queue: DispatchQueue = DispatchQueue(label: "com.piglier.CathayBKHK.ServiceMonitor", qos: .utility)
    
    let monitors: [ServiceMonitorProtocol]
    
    init(monitors: [ServiceMonitorProtocol]) {
        self.monitors = monitors
    }
    
    func performEvent(_ event: @escaping (ServiceMonitorProtocol) -> Void) {
        queue.async {
            for monitor in self.monitors {
                monitor.queue.async { event(monitor) }
            }
        }
    }
    
    func didCreateRequest(path: String) {
        performEvent { $0.didCreateRequest(path: path) }
    }
    
    func didReceive(responseData: Data) {
        performEvent { $0.didReceive(responseData: responseData) }
    }
    
    func didReceive(error: Error) {
        performEvent { $0.didReceive(error: error) }
    }
}

final class ServiceMonitor: ServiceMonitorProtocol {
    
    let queue: DispatchQueue = DispatchQueue(label: "com.piglier.CathayBKHK.ServiceMonitor", qos: .utility)
    let pointOfInterest = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: .pointsOfInterest)
    
    init() {}
    
    func didCreateRequest(path: String) {
        log("Creating request. path: \(path)")
        os_signpost(.begin, log: pointOfInterest, name: "service", signpostID: OSSignpostID(log: pointOfInterest))
    }
    
    func didReceive(responseData: Data) {
        os_signpost(.end, log: pointOfInterest, name: "service", signpostID: OSSignpostID(log: pointOfInterest))
        let string = String(data: responseData, encoding: .utf8)
        log(string ?? "response")
    }
    
    func didReceive(error: Error) {
        os_signpost(.end, log: pointOfInterest, name: "service", signpostID: OSSignpostID(log: pointOfInterest))
        log(error.localizedDescription)
    }
    
    func log(_ message: String) {
        #if DEBUG
        print("[Service] \(message)")
        #endif
    }
}

