//
//  ApiRouter.swift
//  WeatherApp
//
//  Created by Bamidele Oguntuga.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    //The endpoint name we'll call later
    case getWeatherResult(lat: Double, lon: Double, appid: String, units: String)
    case getGeoCode(cityName: String, appid: String)
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        //Http method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.acceptType.rawValue)
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HttpHeaderField.contentType.rawValue)
        
        //Encoding
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    //MARK: - HttpMethod
    //This returns the HttpMethod type. It's used to determine the type if several endpoints are peresent
    private var method: HTTPMethod {
        switch self {
        case .getWeatherResult:
            return .get
        case .getGeoCode:
            return .get
        }
    }
    
    //MARK: - Path
    //The path is the part following the base url
    private var path: String {
        switch self {
        case .getWeatherResult:
            return "weather"
        case .getGeoCode:
            return "direct"
        }
    }
    
    //MARK: - Parameters
    //This is the queries part, it's optional because an endpoint can be without parameters
    private var parameters: Parameters? {
        switch self {
        case .getWeatherResult(let lat, let lon, let appid, let units):
            //A dictionary of the key (From the constants file) and its value is returned
            return [Constants.Parameters.lat : lat, Constants.Parameters.lon : lon, Constants.Parameters.appid : appid, Constants.Parameters.units : units]
        case .getGeoCode(cityName: let cityName, appid: let appid):
            
            return [Constants.Parameters.q : cityName, Constants.Parameters.appid : appid]
        }
    }
}
