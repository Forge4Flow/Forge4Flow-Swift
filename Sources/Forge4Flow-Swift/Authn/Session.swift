//
//  Session.swift
//  Forge4Flow-Swift
//
//  Created by BoiseITGuru on 8/5/23.
//

import FCL
import Flow
import Foundation

public extension Forge4FlowClient {
    func authenticate() throws {
        guard let baseUrl = forge4FlowClient.manager.baseURL else {
            throw ConfigErrors.NotConfigured
        }
        
        guard let clientKey = forge4FlowClient.manager.clientKey else {
            throw ConfigErrors.NotConfigured
        }
        
        Task {
            try? await fcl.unauthenticate()
            
            do {
                guard let accountProof = try await Forge4FlowClient.AuthnRoutes.getNonce() else {
                    throw AuthnErrors.UnableToGetNonce
                }
                
                fcl.config
                    .put(.nonce, value: accountProof.nonce)
                    .put(.appId, value: accountProof.appIdentifier)
            } catch {
                print(error)
                throw AuthnErrors.UnableToGetNonce
            }
        }
        
        fcl.openDiscovery()
    }
}
