//
//  DetailViewController.swift
//  The Weather App
//
//  Created by Ram Sri Charan on 8/23/18.
//  Copyright © 2018 Ram Sri Charan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeViews()
        populateData()
//        print(day, "\n", minTemp,"\n", maxTemp ,"\n", minFeelTemp,"\n", maxFeelTemp,"\n", dayDescription,"\n",nightDescription)

    }

    ////////////////// My Variables  ///////////////////
    var day : String?
    var minTemp : String?
    var maxTemp : String?
    var minFeelTemp : String?
    var maxFeelTemp : String?
    var dayDescription : String?
    var nightDescription : String?
    
    
    
    
    
    ////////////////// Helper Methods  ///////////////////

    func populateData() {
        self.navigationItem.title = day
        
        minTempLabel.text = minTemp
        maxTempLabel.text = maxTemp
        
        feelsLikeMinTemp.text = minFeelTemp
        feelsLikeMaxTemp.text = maxFeelTemp
        
        dayDescContentLabel.text = dayDescription
        nightDescContentLabel.text = nightDescription
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
    
    
    // Base View
    let baseView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // Temp Label holder view
    let tempLabelsHolderView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.layer.masksToBounds = true
        return view
    }()
    
    // Temp Heading label
    let tempHeadingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Temperatures"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    // Min Temp Label
    let minTempLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 40)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    // Max Temp Label
    let maxTempLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 40)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    // Feels Like Labels holder view
    let feelsLikeHolderView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.layer.masksToBounds = true
        return view
    }()
    
    // Feels Like Heading label
    let feelsLikeHeadingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Feels Like Temperature"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // Feels Like Min Temp Label
    let feelsLikeMinTemp : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    // Feels Like Max Temp Label
    let feelsLikeMaxTemp : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    // Day Description Heading Label
    let dayDescHeadingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Daytime Weather Description"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    // Day Description Content Label
    let dayDescContentLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    // Night Description Heading Label
    let nightDescHeadingLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Night Weather Description"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    // Night Description Content Label
    let nightDescContentLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    
    
    // Setup VIew
    func makeViews()
    {
        // Setting background image
        view.addSubview(backgroundImageView)
        backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        // Adding Base View
        view.addSubview(baseView)
        baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        baseView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        baseView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        // Make Temperature View
        baseView.addSubview(tempLabelsHolderView)
        tempLabelsHolderView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 8).isActive = true
        tempLabelsHolderView.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.9).isActive = true
        tempLabelsHolderView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        makeTempViews(BaseHolderView: tempLabelsHolderView, HeadingLabel: tempHeadingLabel, MinTempLabel: minTempLabel, MaxTempLabel: maxTempLabel)
        
        
        // Make Feels Like Temperature Views
        baseView.addSubview(feelsLikeHolderView)
        feelsLikeHolderView.topAnchor.constraint(equalTo: tempLabelsHolderView.bottomAnchor, constant: 8).isActive = true
        feelsLikeHolderView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        feelsLikeHolderView.widthAnchor.constraint(equalTo: baseView.widthAnchor, multiplier: 0.9).isActive = true
        makeTempViews(BaseHolderView: feelsLikeHolderView, HeadingLabel: feelsLikeHeadingLabel, MinTempLabel: feelsLikeMinTemp, MaxTempLabel: feelsLikeMaxTemp)
        
        
        // Make Day Description View
        baseView.addSubview(dayDescHeadingLabel)
        dayDescHeadingLabel.topAnchor.constraint(equalTo: feelsLikeHolderView.bottomAnchor, constant: 16).isActive = true
        dayDescHeadingLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
        baseView.addSubview(dayDescContentLabel)
        dayDescContentLabel.topAnchor.constraint(equalTo: dayDescHeadingLabel.bottomAnchor, constant: 8).isActive = true
        dayDescContentLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
        
        
        // Make Night Descripion View
        baseView.addSubview(nightDescHeadingLabel)
        nightDescHeadingLabel.topAnchor.constraint(equalTo: dayDescContentLabel.bottomAnchor, constant: 16).isActive = true
        nightDescHeadingLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
        baseView.addSubview(nightDescContentLabel)
        nightDescContentLabel.topAnchor.constraint(equalTo: nightDescHeadingLabel.bottomAnchor, constant: 8).isActive = true
        nightDescContentLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        
    }
    
    
    // Fucntion to arrange multiple Similar View Structures
    func makeTempViews(BaseHolderView : UIView, HeadingLabel : UILabel, MinTempLabel : UILabel, MaxTempLabel : UILabel)
    {
        // Adding the temperature heading
        BaseHolderView.heightAnchor.constraint(equalTo: baseView.heightAnchor, multiplier: 0.2).isActive = true
        BaseHolderView.addSubview(HeadingLabel)
        HeadingLabel.centerYAnchor.constraint(equalTo: BaseHolderView.centerYAnchor, constant: -16).isActive = true
        HeadingLabel.centerXAnchor.constraint(equalTo: BaseHolderView.centerXAnchor).isActive = true
        
        // Adding the Min Temp label
        BaseHolderView.addSubview(MinTempLabel)
        MinTempLabel.centerYAnchor.constraint(equalTo: BaseHolderView.centerYAnchor, constant: 16).isActive = true
        MinTempLabel.leftAnchor.constraint(equalTo: BaseHolderView.leftAnchor, constant: 8).isActive = true
        MinTempLabel.rightAnchor.constraint(equalTo: BaseHolderView.centerXAnchor, constant: -4).isActive = true
        
        // Adding the Max Temp Label
        BaseHolderView.addSubview(MaxTempLabel)
        MaxTempLabel.centerYAnchor.constraint(equalTo: BaseHolderView.centerYAnchor, constant: 16).isActive = true
        MaxTempLabel.leftAnchor.constraint(equalTo: BaseHolderView.centerXAnchor, constant: 4).isActive = true
        MaxTempLabel.rightAnchor.constraint(equalTo: BaseHolderView.rightAnchor, constant: -4).isActive = true
    }
    
}
