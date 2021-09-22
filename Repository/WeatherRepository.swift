//
//  WeatherRepository.swift
//  Weather
//
//  Created by Mikael Galliot on 25/08/21.
//

import Foundation


protocol WeatherRepositoryService {
    func search<T:Decodable>(location:String, modelType:T.Type, completionHandler:@escaping Completion<T> )
    
    func searchWeatherForcast<T:Decodable>(lat:String, long:String, exclude:String,  modelType:T.Type, completionHandler:@escaping Completion<T> )

}

class WeatherRepository:BaseRepository, WeatherRepositoryService, DecodeJson {
    
    func searchWeatherForcast<T>(lat: String, long: String, exclude: String, modelType: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        
        networkManager.run(baseUrl: EndPoint.baseUrl, path: APIPath.onecall.rawValue, params: ["lat":lat, "lon":long,"exclude":exclude, "appid":EndPoint.appId], requestType:RequestType.get) {[weak self] data, error in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder
            
            if let result = self?.decodeObject(input:data, type:modelType.self) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
    }
    
    func search<T>(location: String, modelType: T.Type, completionHandler: @escaping Completion<T>) where T : Decodable {
        
        networkManager.run(baseUrl: EndPoint.baseUrl, path: APIPath.weather.rawValue, params: ["q":location, "appid":EndPoint.appId], requestType:RequestType.get) {[weak self] data, error in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.errorWith(message: error!.localizedDescription)))
                return
            }
            // Parsing data using JsonDecoder
            
            if let result = self?.decodeObject(input:data, type:modelType.self) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.parsinFailed(message:"")))
            }
        }
    }

}
