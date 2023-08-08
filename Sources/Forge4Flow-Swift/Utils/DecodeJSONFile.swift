//
//  DecodeJSONFile.swift
//  Forge4Flow-Swift
//
//  Created by BoiseITGuru on 8/5/23.
//


import Foundation

func decodeJsonFromFile<T: Decodable>(url: URL, type: T.Type) -> T? {
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(type, from: data)
        return jsonData
    } catch {
        print("Error decoding JSON from file: \(error)")
        return nil
    }
}
