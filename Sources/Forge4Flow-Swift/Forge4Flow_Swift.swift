//
//  Forge4Flow_Swift.swift
//  Forge4Flow-Swift
//
//  Created by BoiseITGuru on 8/5/23.
//

import Foundation
import FCL
import Combine

public let forge4FlowClient = Forge4FlowClient.shared

protocol Routable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var httpMethod: String { get }
}

public class NetworkManager {
    enum NetworkManagerError: Error {
        case invalidURL
        case invalidResponse
        case invalidStatusCode(Int)
    }
    
    public var baseURL: String?
    public var clientKey: String?
    public var sessionToken: String?
    
    init() {

    }
    
    func sendRequest<D: Decodable>(route: Routable, decodeTo: D.Type) async throws -> D? {
        guard var baseURL = URL(string: self.baseURL ?? "") else {
            throw NetworkManagerError.invalidURL
        }
        
        baseURL.append(path: route.path)
        
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw NetworkManagerError.invalidURL
        }
        
        components.queryItems = route.queryItems
        
        guard let endpointURL = components.url else {
            throw NetworkManagerError.invalidURL
        }
        
        var request = URLRequest(url: endpointURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = route.httpMethod
        request.httpBody = route.body
        
        if let sessionToken = self.sessionToken {
            request.addValue("Bearer \(sessionToken)", forHTTPHeaderField: "Authorization")
        } else {
            request.addValue("None None", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkManagerError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            throw NetworkManagerError.invalidStatusCode(httpResponse.statusCode)
        }
        
        let result = try JSONDecoder().decode(D.self, from: data)
        
        return result
    }
}

public class Forge4FlowClient: NSObject, ObservableObject {
    public static let shared: Forge4FlowClient = Forge4FlowClient()
    
    public let manager: NetworkManager = NetworkManager()
    
    @Published public var isLoading = false
    @Published public var isAuthenticated = false
    
    private var userSub: AnyCancellable?
    
    public func config(baseUrl: String, clientKey: String) {
        forge4FlowClient.manager.baseURL = baseUrl
        forge4FlowClient.manager.clientKey = clientKey
    }
}
