//
//  ForecastService.swift
//  AlamofireWeather
//
//  Created by Guilherme Crozariol on 2017-09-12.
//  Copyright © 2017 Guilherme Crozariol. All rights reserved.
//

import Foundation
import Alamofire

class ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: URL?
    
    init(APIKey: String) {
        self.forecastAPIKey = APIKey
        forecastBaseURL = URL(string: "https://api.darksky.net/forecast/\(APIKey)")
    }
    
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather?) -> Void) {
        
        if let forecastURL = URL(string: "\(forecastBaseURL!)/\(latitude),\(longitude)") {
            Alamofire.request(forecastURL).responseJSON(completionHandler: { (response) in
                
                if let jsonDictionary = response.result.value as? [String : Any] {
                    
                    if let currentWeatherDictionary = jsonDictionary["currently"] as? [String : Any] {
                        let currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
                        completion(currentWeather)
                    
                    } else {
                        completion(nil)
                    }
                }
            })
        }
    }
}
