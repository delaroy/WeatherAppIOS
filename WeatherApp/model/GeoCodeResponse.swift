//
//  ViewController.swift
//  WeatherApp
//
//  Created by Bamidele Oguntuga.
//

import Foundation

struct GeoCodeResponse: Codable{
    let name: String
    let lat, lon: Double
    let country: String
    let state: String?
}
