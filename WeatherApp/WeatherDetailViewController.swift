//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Bamidele Oguntuga.
//

import UIKit
import RxSwift
import Alamofire
import PKHUD

class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var tempSwitch: UISegmentedControl!
    @IBOutlet weak var weatherSummary: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var cloudCoverage: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var cityName: String =  ""
    var latitudeSegue: String = ""
    var longitudeSegue: String = ""
    
    var weatherLat = 0.0
    var weatherLon = 0.0
    var metricValue = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        if traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.backgroundColor = UIColor.black
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
        print("List of posts:", self.cityName)
        if (!(cityName.isEmpty)) {
            getGeoCode(cityName: cityName)
        }
        
        if (!(latitudeSegue.isEmpty)) {
            self.loadWeather(lat: Double(latitudeSegue) ?? 0.0, lon: Double(longitudeSegue) ?? 0.0)
        }
        
    }
    
    private func getGeoCode(cityName: String) {
        setLoadingHud(visible: true)
        ApiClient.getGeoCode(cityName: cityName.lowercased(), appid: Constants.API_KEY)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { postsList in
                        let value = postsList
                        self.weatherLat = value[0].lat
                        self.weatherLon = value[0].lon
                        print("List of posts:", self.weatherLat)
                        //weatherDetail.latitudeSegue = latitude
                        //weatherDetail.longitudeSegue = longitude
                        self.loadWeather(lat: self.weatherLat, lon: self.weatherLon)
                        self.setLoadingHud(visible: false)
                    }, onError: { error in
                        switch error {
                        case ApiError.conflict:
                            print("Conflict error")
                        case ApiError.forbidden:
                            print("Forbidden error")
                        case ApiError.notFound:
                            print("Not found error")
                        default:
                            print("Unknown error:", error)
                        }
                        self.setLoadingHud(visible: false)
                    })
                    .disposed(by: disposeBag)
    }
    
    private func loadWeather(lat: Double, lon: Double, units: String = "metric")
    {
        setLoadingHud(visible: true)
        metricValue = units
        ApiClient.getWeatherResult(lat: lat, lon: lon, appid: Constants.API_KEY, units: units)
                    .observeOn(MainScheduler.instance)
                    .subscribe(onNext: { weatherRes in
                        self.title = weatherRes.name
                        self.weatherSummary.text = weatherRes.weather[0].main
                        let degree = NSString(format:"23%@", "\u{00B0}") as String
                        if units == "metric" {
                            self.temperature.text = String(weatherRes.main.temp) + degree + "C"
                        } else {
                            self.temperature.text = String(weatherRes.main.temp) + degree + "F"
                        }
                        self.minTemp.text = String(weatherRes.main.tempMin)
                        self.maxTemp.text = String(weatherRes.main.tempMax)
                        self.cloudCoverage.text = String(weatherRes.clouds.all)
                        self.latitude.text = String(weatherRes.coord.lat)
                        self.longitude.text = String(weatherRes.coord.lon)
                        self.sunrise.text = self.convertDate(value: weatherRes.sys.sunrise)
                        self.sunset.text = self.convertDate(value: weatherRes.sys.sunset)
                        
                        let image = weatherRes.weather[0].icon
                        let iconurl = "http://openweathermap.org/img/w/" + image + ".png"
                        self.weatherIcon.image = UIImage(url: URL(string: iconurl))
                        
                        self.setLoadingHud(visible: false)
                    }, onError: { error in
                        switch error {
                        case ApiError.conflict:
                            print("Conflict error")
                        case ApiError.forbidden:
                            print("Forbidden error")
                        case ApiError.notFound:
                            print("Not found error")
                        default:
                            print("Unknown error:", error)
                        }
                        self.setLoadingHud(visible: false)
                    })
                    .disposed(by: disposeBag)
    }
    
    private func setLoadingHud(visible: Bool) {
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
    }
    
    private func convertDate(value: Int) -> String {
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(value)/1000)
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dateVar)
    }

    @IBAction func switchUnits(_ sender: Any) {
        switch tempSwitch.selectedSegmentIndex {
                case 0:
                    loadWeather(lat: self.weatherLat, lon: self.weatherLon, units: "metric")
                case 1 :
                    loadWeather(lat: self.weatherLat, lon: self.weatherLon, units: "imperial")
                default:
                    break
                }
    }
}

extension UIImage {
  convenience init?(url: URL?) {
    guard let url = url else { return nil }
            
    do {
      self.init(data: try Data(contentsOf: url))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}
