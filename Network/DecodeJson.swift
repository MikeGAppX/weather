//
//  DecodeJson.swift
//  Weather
//
//  Created by Mikael Galliot on 25/08/21.
//

import Foundation

protocol DecodeJson {
    func decodeObject<T:Decodable>(input:Data, type:T.Type)-> T?
    func decodeArray<T:Decodable>(input:Data, type:T.Type)-> [T]?
}

extension DecodeJson {
    func decodeObject<T:Decodable>(input:Data, type:T.Type)-> T? {
        
        do {
            try JSONDecoder().decode(T.self, from: input)
        }catch {
            print(error.localizedDescription)
        }
        return  try? JSONDecoder().decode(T.self, from: input)
    }
    func decodeArray<T:Decodable>(input:Data, type:T.Type)-> [T]? {
        return  try? JSONDecoder().decode([T].self, from: input)
    }
}
