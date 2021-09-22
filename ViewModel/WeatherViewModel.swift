//
//  WeatherViewModel.swift
//  Weather
//
//  Created by MAC on 25/08/21.
//

import Foundation

protocol WeatherViewModelType {
    var numberOfItems:Int { get }
    var weatherBinding: Published<WeatherResponse?>.Publisher { get }
    func getWeather(_ location:String?)
    func getWeatherDetails(for index:Int)-> WeatherDetails?
}

class WeatherViewModel: WeatherViewModelType {
        
    var weatherBinding: Published<WeatherResponse?>.Publisher { $weatherResponse }
    var errorBinding: Published<String?>.Publisher { $errorMessage }
    
    var numberOfItems: Int {
        return searchResults.count
    }

    // MARK: - private properties
    @Published private var weatherResponse:WeatherResponse?
    @Published private var errorMessage:String?
    @Published private var searchResults:[WeatherResponse] = []

    private var repository:WeatherRepositoryService
   
    init(repository:WeatherRepositoryService = WeatherRepository()) {
        self.repository = repository
    }
    
    
    func getWeather(_ location:String?) {
        
        guard  let location = location else {
            return
        }
        
        repository.search(location:location, modelType:WeatherResponse.self) { result in
            
            switch result {
            case .success(let response):
                print(response)
                self.weatherResponse = response
                self.searchResults.append(response)
                
            case .failure(let error):
                print(error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getWeatherDetails(for index:Int)-> WeatherDetails? {
        
        guard index >= 0 , index < searchResults.count else {
            return nil
        }
        
        let weatherResponse = searchResults[index]
        return WeatherDetails(cityName:weatherResponse.name, type:weatherResponse.weather?.first?.main, descripton:weatherResponse.weather?.first?.weatherDescription ?? "",
            temprature: weatherResponse.main.temp,
            tempMax: weatherResponse.main.tempMax,
            tempMin: weatherResponse.main.tempMin,
            imageName: weatherImageName(type: weatherResponse.weather?.first?.main ?? ""),
            lat: weatherResponse.coord.lat,
            long: weatherResponse.coord.lon)
    }
    
    private func weatherImageName(type:String)-> String {
        
        print(type)
        switch type {
        case "clear" :
            return "ClearAndSunny"
        case "a" :
            return "CloudyOverNight"
        case "Haze" :
            return "GustyWinds"
        case "c" :
            return "HailStorms"
        case "d" :
            return "HeavyRain"
        case "Clouds" :
            return "PartlyCloudy"
        default:
            return "ClearAndSunny"
        }
    }
}


struct WeatherDetails {
    let cityName:String
    let type:String?
    let descripton:String
    let temprature:Double
    let tempMax:Double
    let tempMin:Double
    let imageName:String
    let lat:Double
    let long:Double
}
