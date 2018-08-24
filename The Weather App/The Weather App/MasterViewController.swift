//
//  MasterViewController.swift
//  The Weather App
//
//  Created by Ram Sri Charan on 8/23/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeatherInfo()
        makeViews()
        cityNameLabel.text = CityName
    }
    
    
    
    /////////////////// My Variables //////////////////
    let GET_WEATHER_URL = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/"
    let GET_WEATHER_APIKEY = "?apikey=iuRzrbwQAPZiMTSG3rqy8yvvmxd6GtRT&details=true"
    var CityName = ""
    var CityKey = ""
    var WeatherInformation : WeatherInfo?
    
    // Root JSON Node
    struct WeatherInfo : Decodable {
        var Headline : Headline?
        var DailyForecasts : [DailyForecasts]?
    }
    
    // Helper JSON Nodes
    struct Headline : Decodable {
        var Text : String?
    }
    struct DailyForecasts : Decodable {
        var Date : String?
        var EpochDate : Int?
        var Temperature : Temperature?
        var RealFeelTemperature : RealFeelTemperature?
        var Day : Day?
        var Night : Night?
    }
    
    
    struct Temperature : Decodable {
        var Minimum : Minimum?
        var Maximum : Maximum?
    }
    struct RealFeelTemperature : Decodable {
        var Minimum : Minimum?
        var Maximum : Maximum?
    }
    struct Minimum : Decodable {
        var Value : Int?
        var Unit : String?
    }
    struct Maximum : Decodable {
        var Value : Int?
        var Unit : String?
    }
    struct Day : Decodable {
        var LongPhrase : String?
    }
    struct Night : Decodable {
        var LongPhrase : String?
    }
    

    
    
    
    
    
    
    
    
    ////////////////// Helper Methods  ///////////////////
    
    func showAlertWith(AlertTitle : String, AlertMessage : String)
    {
        let alert = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Fetch data from API
    func fetchWeatherInfo()
    {
        guard let sessionURL = URL(string: GET_WEATHER_URL + CityKey + GET_WEATHER_APIKEY) else {return}
        
        URLSession.shared.dataTask(with: sessionURL) { (data, response, error) in

            let status = (response as! HTTPURLResponse).statusCode
            if(status == 503)
            {
                print("Max API calls made")
                DispatchQueue.main.async {
                    self.showAlertWith(AlertTitle: "Loading Data Failed" , AlertMessage: "The allowed number of requests has been exceeded. Please Try again Later.")
                }
            }
                
            else
            {
                guard let data = data else { return }
                do {
                    // Converting JSON data into my decodable Object
                    self.WeatherInformation = try JSONDecoder().decode(WeatherInfo.self, from: data)
                
                    DispatchQueue.main.async {
                        self.weatherDescLabel.text = self.WeatherInformation?.Headline?.Text ?? "-"
                        self.forecastTableView.reloadData()
                    }
                } catch let jsonError {
                    print("Error with JSON parsing: ", jsonError)
                }
            }
        }.resume()
    }
    
    
    // Get the day from Epoch
    func getDayString(Epoch : Int) -> String
    {
        let date = NSDate(timeIntervalSince1970: TimeInterval(Epoch))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    
    
    
    
    
    
    
    ////////////////// TableView Methods  ///////////////////

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Data is not yet loaded from API
        if(WeatherInformation?.DailyForecasts == nil)
        {
            return 1
        }
        return 5

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! MyCustomForecastCell
        
        if(WeatherInformation?.DailyForecasts != nil)
        {
            let index = indexPath.row
            let minTemp = String (WeatherInformation!.DailyForecasts![index].Temperature?.Minimum?.Value ?? 0)
            let maxTemp = String (WeatherInformation!.DailyForecasts![index].Temperature?.Maximum?.Value ?? 0)
            let epochTime = WeatherInformation?.DailyForecasts![index].EpochDate
            
            cell.minTempLabel.text = minTemp + " F"
            cell.dateLabel.text = getDayString(Epoch: epochTime!)
            cell.maxTempLabel.text = maxTemp + " F"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let detailsView = DetailViewController()
       
        let cell = tableView.cellForRow(at: indexPath) as! MyCustomForecastCell
        
        
        detailsView.day = cell.dateLabel.text
        
        detailsView.minTemp = String (WeatherInformation!.DailyForecasts![indexPath.row].Temperature?.Minimum?.Value ?? 0) + " F"
        detailsView.maxTemp = String (WeatherInformation!.DailyForecasts![indexPath.row].Temperature?.Maximum?.Value ?? 0) + " F"
        detailsView.minFeelTemp = String (WeatherInformation!.DailyForecasts![indexPath.row].RealFeelTemperature?.Minimum?.Value ?? 0) + " F"
        detailsView.maxFeelTemp = String (WeatherInformation!.DailyForecasts![indexPath.row].RealFeelTemperature?.Maximum?.Value ?? 0) + " F"
        
        detailsView.dayDescription = WeatherInformation!.DailyForecasts![indexPath.row].Day?.LongPhrase ?? "None" 
        detailsView.nightDescription = WeatherInformation!.DailyForecasts![indexPath.row].Night?.LongPhrase ?? "None"
        
 
        /*
        // Testing Data
        detailsView.day = "24 August"
        detailsView.minTemp = "83 F"
        detailsView.maxTemp = "91 F"
        detailsView.minFeelTemp = "76 F"
        detailsView.maxFeelTemp = "88 F"
        
        detailsView.dayDescription = "The Weather is Mostly Sunny"
        detailsView.nightDescription = "It is likely to rain. Mostly Cloudy"
        */
        
        
        self.navigationController?.pushViewController(detailsView, animated: true)
    }
    
    
    
    
    
    
    // Custom Table View Cell
    class MyCustomForecastCell: UITableViewCell
    {
        // Base View
        let cellBaseView : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        // Stack View
        let cellStackView : UIStackView = {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            return stackView
        }()
        
        // Min temp label
        let minTempLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 30)
            label.textColor = UIColor.blue
            return label
        }()
        
        // Max Temp label
        let maxTempLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 30)
            label.textColor = UIColor.red
            return label
        }()
        
        // Data label
        let dateLabel : UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 10)
            return label
        }()
        
        // Arranging the view into Custom Cell
        override init(style: UITableViewCellStyle, reuseIdentifier: String?)
        {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            // Add base View to the cell
            addSubview(cellBaseView)
            cellBaseView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9).isActive = true
            cellBaseView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
            cellBaseView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            cellBaseView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            // Adding the stack View to the base View
            cellBaseView.addSubview(cellStackView)
            cellStackView.widthAnchor.constraint(equalTo: cellBaseView.widthAnchor, multiplier: 0.95).isActive = true
            cellStackView.heightAnchor.constraint(equalTo: cellBaseView.heightAnchor, multiplier: 0.98).isActive = true
            cellStackView.centerXAnchor.constraint(equalTo: cellBaseView.centerXAnchor).isActive = true
            cellStackView.centerYAnchor.constraint(equalTo: cellBaseView.centerYAnchor).isActive = true
            
            // Adding all other view into the stack View
            cellStackView.addArrangedSubview(minTempLabel)
            cellStackView.addArrangedSubview(dateLabel)
            cellStackView.addArrangedSubview(maxTempLabel)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    
    
    
    
    
    
    
    ////////////////// View Components  ///////////////////

    //Background Image Container
    let backgroundImageView : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "bg")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    // City Details View
    let cityDetailsView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    // City Name Label
    let cityNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor.white
        return label
    }()
    
    // Weather Description
    let weatherDescLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24)
        label.text = "Weather is good today"
        label.textColor = UIColor.white
        return label
    }()
    
    // Table View to Display 5 Day Forecast
    var forecastTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        tableView.layer.masksToBounds = true
        return tableView
    }()
    
    
    // Arrange all the Views
    func makeViews()
    {
        // Setting background image
        view.addSubview(backgroundImageView)
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
        
        // Adding the City Details View
        view.addSubview(cityDetailsView)
        cityDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cityDetailsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        cityDetailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityDetailsView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        
        // Adding City Name Label & Weather Description
        cityDetailsView.addSubview(cityNameLabel)
        cityNameLabel.centerXAnchor.constraint(equalTo: cityDetailsView.centerXAnchor).isActive = true
        cityNameLabel.centerYAnchor.constraint(equalTo: cityDetailsView.centerYAnchor, constant: -16).isActive = true
        
        cityDetailsView.addSubview(weatherDescLabel)
        weatherDescLabel.centerXAnchor.constraint(equalTo: cityDetailsView.centerXAnchor).isActive = true
        weatherDescLabel.centerYAnchor.constraint(equalTo: cityDetailsView.centerYAnchor, constant: 16).isActive = true
        
        
        // Adding the Forecast TableView
        view.addSubview(forecastTableView)
        forecastTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.67).isActive = true
        forecastTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        forecastTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forecastTableView.topAnchor.constraint(lessThanOrEqualTo: cityDetailsView.bottomAnchor, constant: 8).isActive = true
        forecastTableView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -8).isActive = true
        
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastTableView.separatorStyle = .none
        forecastTableView.register(MyCustomForecastCell.self, forCellReuseIdentifier: "forecastCell")
    }
    
}
