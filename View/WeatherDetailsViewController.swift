//
//  WeatherDetailsViewController.swift
//  Weather
//
//  Created by Mikael Galliot on 26/08/21.
//

import UIKit
import Combine

class WeatherDetailsViewController: UIViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var LowTempLabel: UILabel!
    @IBOutlet weak var HighTempLabel: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel:WeatherDetailsViewModelType!
    private var cancellabel = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataBinding()
        
        locationLabel.text = viewModel.weatherDetails.cityName
        weatherDesc.text = viewModel.weatherDetails.descripton
        currentTemp.text = String(format:"%0.2f\u{00B0}",viewModel.weatherDetails.temprature.KelvinToDegreeCelcius())

        HighTempLabel.text = String(format:"H:%0.2f\u{00B0}",viewModel.weatherDetails.tempMax.KelvinToDegreeCelcius())

        LowTempLabel.text = String(format:"L:%0.2f\u{00B0}",viewModel.weatherDetails.tempMin.KelvinToDegreeCelcius())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchWeatherForCastFor()
    }
    
    private func configureDataBinding() {
        viewModel
            .weatherForCastBinding
            .dropFirst()
            .receive(on: RunLoop.main).sink {[weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &cancellabel)
    }
}

extension WeatherDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.filterOptions[section] {
           case WeatherForCastType.daily:
            return viewModel.dailyItemCount
           case WeatherForCastType.hourly:
            return viewModel.hourlyItemCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.filterOptions[indexPath.section] {
           case WeatherForCastType.daily:
            guard  let cell = tableView.dequeueReusableCell(withIdentifier:"DailyTableViewCell", for: indexPath) as? DailyTableViewCell else {
                return UITableViewCell()
            }
            
            if  let dailyForCast = viewModel?.getDailyForcast(for: indexPath.row) {
                cell.dayDate.text = dailyForCast.date
                cell.temp.text = dailyForCast.tempLow
                cell.pressure.text = dailyForCast.tempHigh
            }
                    
            return cell
           case WeatherForCastType.hourly:
            guard  let cell = tableView.dequeueReusableCell(withIdentifier:"HourlyTableViewCell", for: indexPath) as? HourlyTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureData(hourlyForCast: viewModel.getHourlyForcast())
            return cell
        }
       
    }
    
    
}

extension WeatherDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
}



