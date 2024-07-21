//
//  Service .swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import Foundation

extension Service {
    
    private static let session = URLSession(configuration: .default)
    
    func request<M: Decodable>(_ route: Route) async throws -> M {
        
        let properties = route.requestProperties
        
        guard let url = URL(string: properties.path, relativeTo: serverConfig.apiBaseUrl as URL) else {
            fatalError(
              "URL(string: \(properties.path), relativeToURL: \(serverConfig.apiBaseUrl)) == nil"
            )
        }
        
        monitor.didCreateRequest(path: properties.path)
        
        do {
            let (data, _) = try await Service.session.data(from: url)
            monitor.didReceive(responseData: data)
            return try decode(data)
        } catch {
            monitor.didReceive(error: error)
            throw error
        }
    }
    
    func decode<T: Decodable>(_ jsonData: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
}
