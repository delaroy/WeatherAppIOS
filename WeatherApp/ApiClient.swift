//
//  ApiClient.swift
//  WeatherApp
//
//  Created by Bamidele Oguntuga.
//

import Alamofire
import RxSwift

class ApiClient {
    
    static func getWeatherResult(lat: Double, lon: Double, appid: String, units: String) -> Observable<WeatherResponse> {
        Constants.baseUrl = "https://api.openweathermap.org/data/2.5"
        return request(ApiRouter.getWeatherResult(lat: lat, lon: lon, appid: appid, units: units))
    }
    
    static func getGeoCode(cityName: String, appid: String) -> Observable<[GeoCodeResponse]> {
        Constants.baseUrl = "http://api.openweathermap.org/geo/1.0"
        return request(ApiRouter.getGeoCode(cityName: cityName, appid: appid))
    }
    
    //-------------------------------------------------------------------------------------------------
    //MARK: - The request function to get results in an Observable
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        //Create an RxSwift observable, which will be the one to call the request when subscribed to
        return Observable<T>.create { observer in
            //Trigger the HttpRequest using AlamoFire (AF)
            let request = AF.request(urlConvertible).responseDecodable { (response: DataResponse<T>) in
                //Check the result from Alamofire's response and check if it's a success or a failure
                switch response.result {
                case .success(let value):
                    //Everything is fine, return the value in onNext
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    //Something went wrong, switch on the status code and return the error
                    switch response.response?.statusCode {
                    case 403:
                        observer.onError(ApiError.forbidden)
                    case 404:
                        observer.onError(ApiError.notFound)
                    case 409:
                        observer.onError(ApiError.conflict)
                    case 500:
                        observer.onError(ApiError.internalServerError)
                    default:
                        observer.onError(error)
                    }
                }
            }
            
            //Finally, we return a disposable to stop the request
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
