//
//  ViewController.swift
//  The Weather App
//
//  Created by Ram Sri Charan on 8/23/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        
        // Setting up the Navigation Bar
        self.navigationItem.title = "The Weather App"
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }
    
    
    ////////////////// My Variables and Stuff  ///////////////////
    let GET_COUNTRY_CODE_URL = "http://dataservice.accuweather.com/locations/v1/cities/US/search?apikey=iuRzrbwQAPZiMTSG3rqy8yvvmxd6GtRT&q="
    
    // JSON Object
    struct cityDetails : Decodable {
        var LocalizedName : String
        var Key : String
    }
    
    
    
    
    
    
    ////////////////// Action Handlers  ///////////////////
    @objc func submitPressed() {
        let userInput = cityNameInputView.text!
        
        // Check if user input is valid
        if(userInput.isEmpty)
        {
            showAlertWith(AlertTitle: "City Name Empty", AlertMessage: "City name cannot be empty. Please enter a valid city name in US")
        }
        
        else
        {
            let userInput_URLencoded = userInput.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
            
            guard let sessionURL = URL(string: GET_COUNTRY_CODE_URL + userInput_URLencoded) else {return}
            
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
                        let city_details = try JSONDecoder().decode([cityDetails].self, from: data)
                        
                        if(city_details.isEmpty)
                        {
                            DispatchQueue.main.async {
                                self.showAlertWith(AlertTitle: "Invalid City Name", AlertMessage: "Please enter a valid US City Name to get the weather info.")
                            }
                        }
                        else {
                            // Launching the Master View Controller to Show Weather Data
                            DispatchQueue.main.async {
                                let MasterView = MasterViewController()
                                MasterView.CityName = city_details[0].LocalizedName
                                MasterView.CityKey = city_details[0].Key
                                self.navigationController?.pushViewController(MasterView, animated: true)
                            }
                        }
                        
                    } catch let jsonError {
                        print("Error with JSON parsing: ", jsonError)
                    }
                }
            }.resume()
        }
    }
    
    
    
    ////////////////// Helper Methods  ///////////////////
    func showAlertWith(AlertTitle : String, AlertMessage : String)
    {
        let alert = UIAlertController(title: AlertTitle, message: AlertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    

    ////////////////// My View Components  ///////////////////
    
    //Background Image Container
    let backgroundImageView : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "bg")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()
    
    
    // Base Container
    let baseView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // Content Stack View
    let contentStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = UIColor.orange
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    // User Prompt Text View
    let userPromptLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Enter the City Name"
        return label
    }()
    
    // User Input View
    let cityNameInputView : UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "City Name"
        textField.backgroundColor = UIColor.white
        textField.textAlignment = .center
        textField.layer.cornerRadius = 15
        textField.layer.masksToBounds = true
        
        return textField
    }()
    
    
    // Submit Button
    let submitButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Weather", for: UIControlState.normal)
        button.addTarget(self, action: #selector(submitPressed), for: .touchUpInside)
        
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.green.cgColor
        button.setTitleColor(UIColor.green, for: .normal)
        
        return button
    }()
    
    

    // Sets up all the view in the View Controller
    func makeViews()
    {
        // Setting background image
        view.addSubview(backgroundImageView)
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Setting up the Base Container
        view.addSubview(baseView)
        baseView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        baseView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        baseView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        baseView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        
        // Add StackView inside the Base View
        baseView.addSubview(contentStackView)
        contentStackView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        contentStackView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        contentStackView.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.95).isActive = true
        contentStackView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
        
        // Add all other sub View to the stackView
        contentStackView.addArrangedSubview(userPromptLabel)
        contentStackView.addArrangedSubview(cityNameInputView)
        cityNameInputView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        contentStackView.addArrangedSubview(submitButton)
    }

}

