//
//  AuthnRoutes.swift
//  Forge4Flow-Swift
//
//  Created by BoiseITGuru on 8/5/23.
//

import Foundation
import Combine
import FCL

public extension Forge4FlowClient {
    enum AuthnRoutes: Routable {
        case nonce
        case session(FCL.FCLDataResponse)
        
        var path: String {
            switch self {
            case .nonce:
                return "/v1/nonce"
            case .session(_):
                return "/v1/session"
            }
        }
        
        var queryItems: [URLQueryItem]? {
            switch self {
            case .nonce:
                return nil
            case .session:
                return nil
            }
        }
        
        var body: Data? {
            switch self {
            case .nonce:
                return nil
            case .session(let accountProof):
                return try? JSONEncoder().encode(accountProof)
            }
        }
        
        var httpMethod: String {
            switch self {
            case .nonce:
                return "GET"
            case .session:
                return "POST"
            }
        }
        
        public static func getNonce() async throws -> NonceResponse? {
            return try await forge4FlowClient.manager.sendRequest(route: Forge4FlowClient.AuthnRoutes.nonce, decodeTo: NonceResponse.self)
        }
        
        public static func getSessionToken() async throws -> SessionResponse? {
            let accountProof = try await fcl.getAccountProof()
            
            return try await forge4FlowClient.manager.sendRequest(route: Forge4FlowClient.AuthnRoutes.session(accountProof), decodeTo: SessionResponse.self)
        }
    }
}
