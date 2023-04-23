//
//  Constants.swift
//  WeatherApp
//
//  Created by Touch and Pay Technologies on 22/04/2023.
//

import UIKit

struct Constants {
    
    //The API's base URL
    static var baseUrl = ""
    static let geoCodeUrl = "http://api.openweathermap.org/geo/1.0"
    static let API_KEY = "edbb4b34f94bc7481fc8bed648b91f18"
   
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let lat = "lat"
        static let lon = "lon"
        static let appid = "appid"
        static let q = "q"
        static let units = "units"
    }
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
}
