//
//  AuthnModels.swift
//  Forge4Flow-Swift
//
//  Created by BoiseITGuru on 8/5/23.
//

public struct NonceResponse: Codable {
    public let appIdentifier: String
    public let nonce: String
}

public struct SessionResponse: Codable {
    public let sessionId: String
}
