//
//  WeatherDetailsViewModel.swift
//  Weather
//
//  Created by Mikael Galliot on 26/08/21.
//

import Foundation


enum WeatherForCastType: String {
    case hourly = "hourly"
    case daily = "daily"
}

struct DailyForCastDetails {
    let date:String
    let tempHigh:String
    let tempLow:String
}

struct HourlyForCastDetails {
    let date:String
    let temp:String
}


protocol WeatherDetailsViewModelType {
    var dailyItemCount:Int{ get }
    var hourlyItemCount:Int{ get }
    var weatherDetails:WeatherDetails { get }
    var filterOptions:[WeatherForCastType] { get }
    var weatherForCastBinding: Published<WeatherForcast?>.Publisher { get }
    func fetchWeatherForCastFor()
    func getDailyForcast(for index:Int)-> DailyForCastDetails?
    func getHourlyForcast()-> [HourlyForCastDetails]

}

class WeatherDetailsViewModel: WeatherDetailsViewModelType {
    
    
    var filterOptions: [WeatherForCastType] {
        return [.hourly, .daily]
    }
    var dailyItemCount: Int {
        return weatherForcast?.daily?.count ?? 0
    }
    var hourlyItemCount: Int {
        return 1
    }
    var weatherForCastBinding: Published<WeatherForcast?>.Publisher{ $weatherForcast }

    var errorBinding: Published<String?>.Publisher { $errorMessage }
    

    // MARK: - private properties
    @Published private var weatherForcast:WeatherForcast?
    @Published private var errorMessage:String?

    
    private var repository:WeatherRepositoryService
    var weatherDetails:WeatherDetails
    
    var forCast:[WeatherForCastType] = []
    
    init(repository:WeatherRepositoryService = WeatherRepository(), weatherDetails:WeatherDetails) {
        self.repository = repository
        self.weatherDetails = weatherDetails
    }
    
    func fetchWeatherForCastFor() {
       
        repository.searchWeatherForcast(lat:"\(weatherDetails.lat)", long: "\(weatherDetails.long)", exclude:"", modelType:WeatherForcast.self) { result in
            
            switch result {
            case .success(let response):
                print(response)
                self.weatherForcast = response
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDailyForcast(for index: Int)-> DailyForCastDetails? {
        
        guard  let dailyForCasts = weatherForcast?.daily else {
            return nil
        }
        let daily = dailyForCasts[index]
        
        let date = Date().getDate(milliSec:(daily.dt!))
        
        return  DailyForCastDetails(date:date, tempHigh:String(format:"%0.2f\u{00B0}",daily.temp.max.KelvinToDegreeCelcius()), tempLow: String(format:"%0.2f\u{00B0}",daily.temp.min.KelvinToDegreeCelcius()))
    }
    
    func getHourlyForcast() -> [HourlyForCastDetails] {
        guard  let hourlyForCasts = weatherForcast?.hourly else {
            return []
        }
        return hourlyForCasts.map { HourlyForCastDetails(date: Date().getHr(milliSec:($0.dt!)), temp: String(format:"%0.2f\u{00B0}",$0.temp.KelvinToDegreeCelcius()))}
        
    }
    
}
 
extension Double {
    func KelvinToDegreeCelcius()-> Double {
        return (self -  273.15)
    }
}

extension Date {
    func getDate(milliSec:Int)-> String {
        let date = Date(timeIntervalSince1970: (Double(milliSec) ))
        return date.getString()
    }
    func getHr(milliSec:Int)-> String {
        let date = Date(timeIntervalSince1970: (Double(milliSec) ))
        return date.getHrString()
    }
    
    func getString()->String {

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "EEEE-MM/dd/YYYY"

        // Convert Date to String
      return dateFormatter.string(from: self)
    }
    func getHrString()->String {

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "hh:mm"

        // Convert Date to String
      return dateFormatter.string(from: self)
    }
}
