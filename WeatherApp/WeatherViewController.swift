//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Bamidele Oguntuga.
//

import UIKit
import PKHUD
import RxSwift

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    var objects = [String]()
    let cellMarginSize :CGFloat  = 4.0

    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        overrideUserInterfaceStyle = .dark
        if traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.backgroundColor = UIColor.black
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        self.objects.append("Delhi")
        self.objects.append("Berlin")
        self.objects.append("Toronto")
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    
    }
    
    private func setLoadingHud(visible: Bool) {
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.titleLabel.text = self.objects[indexPath.row]

        let chevron = UIImage(named: "chevron.png")
               cell.accessoryType = .disclosureIndicator
               cell.accessoryView = UIImageView(image: chevron!)
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return self.objects.count
    }
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegue(withIdentifier: "showView", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "showView")
        {
            let weatherDetail: WeatherDetailViewController = segue.destination as! WeatherDetailViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let titleString = self.objects[indexPath.row]
            
            weatherDetail.cityName = titleString
            
            
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if (segue.identifier == "showBtn") {
            let lat = latitudeTextField.text ?? ""
            let lon = longitudeTextField.text ?? ""
            let city = cityNameTextField.text ?? ""
            // pass data to next view controller
            let vc : WeatherDetailViewController = segue.destination as! WeatherDetailViewController
                vc.cityName = city
                vc.latitudeSegue = lat
                vc.longitudeSegue = lon
            }
        
    }
    
    
    func tableView(_ tableView: UITableView,
                            estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
       // Choose an appropriate default cell size.
    
       var cellSize = UITableView.automaticDimension
            
       // The first cell is always a title cell. Other cells use the Basic style.
       if indexPath.row == 0 {
          //Title cells consist of one large title row and two body text rows.
          let largeTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
          let bodyFont = UIFont.preferredFont(forTextStyle: .body)
                
          // Get the height of a single line of text in each font.
          let largeTitleHeight = largeTitleFont.lineHeight + largeTitleFont.leading
          let bodyHeight = bodyFont.lineHeight + bodyFont.leading
                
          // Sum the line heights plus top and bottom margins to get the final height.
          let titleCellSize = largeTitleHeight + (bodyHeight * 2.0) + (cellMarginSize * 2)

          // Update the estimated cell size.
          cellSize = titleCellSize
       }
            
       return cellSize
    }
    
    func resetForm() {
        searchBtn.isEnabled = false
        
        latitudeTextField.text = ""
        longitudeTextField.text = ""
        cityNameTextField.text = ""
    }
    
    @IBAction func latEditing(_ sender: Any) {
        
    }
    
    @IBAction func lonEditing(_ sender: Any) {
        
    }
    
    @IBAction func cityEditing(_ sender: Any) {
        
    }
    
    @IBAction func submit(_ sender: Any) {
        let lat = latitudeTextField.text ?? ""
        let lon = longitudeTextField.text ?? ""
        let city = cityNameTextField.text ?? ""
        
        if (!(city.isEmpty)) {
            performSegue(withIdentifier: "showBtn", sender: sender)
        } else if(lat.isEmpty) {
            showAlert(withTitle: "Required field", withMessage: "Latitude is required")
        } else if(lon.isEmpty) {
            showAlert(withTitle: "Required field", withMessage: "Longitude is required")
        } else {
            resetForm()
        }
         
    }
    
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


