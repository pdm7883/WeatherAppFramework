//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mukunda Dhirendrachar on 4/11/17.
//

import UIKit
import WeatherAppModelFramework

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate  {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    var searchKey: String? = nil
    var weatherData = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ideally these should go in localization file to support different geos
        self.title = "Weather App"
        self.textField.delegate = self

        // call framewok methods
        let obj = WeatherAppManager()
        obj.getWeatherReport(city: "Cupertino",
                             success: { (response) in
                                print("View controller received success response : \(response)")
                            },
                             failure: { (error) in
                                print("View controller received error response : \(error)")
                            })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textField.placeholder = WeatherAppDefaults.searchKey
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table View Data Source/ Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.medium
        let dateString = formatter.string(from: date)
        
        return "Forecast : \(dateString)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! WeatherCell
        let city = self.weatherData[indexPath.row].city
        let description = self.weatherData[indexPath.row].description
        let imageId = self.weatherData[indexPath.row].icon
        let humidity = self.weatherData[indexPath.row].humidity
        let pressure = self.weatherData[indexPath.row].pressure
        let clouds = self.weatherData[indexPath.row].clouds
        let sunrise = self.weatherData[indexPath.row].sunRise
        let sunset = self.weatherData[indexPath.row].sunSet
        
        // default showing celcius, but have an option to ask the user(C/F) and display accordingly and have those conversion methods and util methods
        let tempAsCelcius = self.convertKelvinToCelcius(tempValue: self.weatherData[indexPath.row].temp)
        let minTempAsCelcius = self.convertKelvinToCelcius(tempValue: self.weatherData[indexPath.row].minTemp)
        let maxTempAsCelcius = self.convertKelvinToCelcius(tempValue: self.weatherData[indexPath.row].maxTemp)
        
        cell.city?.text = city
        cell.weatherDescription?.text = description
        cell.currentTemperature?.text = tempAsCelcius   // highlighting the current temp with a roundeed rectangle, since this is what most users want to know. Its done on storyboard by setting a cornerRadius and drawing a border. Just some design concept...
        cell.currentTemperature?.startBlink()
        
        cell.minTemperature?.text = minTempAsCelcius
        cell.maxTemperature?.text = maxTempAsCelcius
        cell.humidity?.text = String(describing: humidity!)
        cell.pressure?.text = String(describing: pressure!)
        cell.clouds?.text = String(describing: clouds!)
        cell.sunRise?.text = WeatherAppUtils.convertUnixTimeToTimeAndReturn(time: sunrise)
        cell.sunSet?.text = WeatherAppUtils.convertUnixTimeToTimeAndReturn(time: sunset)
        
        // sample animating sunrise/set image
        cell.sunRiseSetImage.frame = CGRect(x: 0.0, y: 210.0, width: 20.0, height: 20.0)
        cell.sunRiseSetImage.moveLeftToRight()
        
        //get image
        self.fetchWeatherImage(imageId!, atIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: Methods
    func fetchWeatherImage(_ icon: String, atIndexPath indexPath: IndexPath) {
        // check if the image is cached
        let obj = WeatherAppManager()

        obj.getWeatherImage(imageID: icon,
                            success: { image in
                                guard let cell = self.tableView.cellForRow(at: indexPath) as? WeatherCell, let image = image else {
                                    return
                                }
                                cell.weatherImage.image = image
                            },
                            failure: { error in
                                DispatchQueue.main.async {
                                    self.alert(title: "Error", message: error as! String)
                                }
                            }
            )
    }
    
    func convertKelvinToCelcius(tempValue: Float?) -> String? {
        if let temp = tempValue {
            let tempWithSymbol = String(format:"%.2f" + "\u{00B0}", temp - 273.15)
            return tempWithSymbol
        }
        
        return nil
    }
    
    // MARK: UITextField delegates
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        searchKey = textFieldText.replacingCharacters(in: range, with: string)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: Action methods
    @IBAction func searchButtonAction(_: Any? = nil) {
        guard searchKey != nil else {
            return
        }
        
        guard let key = searchKey, key.characters.count > 2  else {
            // NOTE: All error message should be localized to support different geos: Please it in a localized file
            // we can also have utility alert methods to display differnet type of errors and have different buttons to act on them.
            self.alert(title: "Error", message: "Search should not be nil and must have min 3 characters")
            return
        }
        
        guard searchKey != "<Enter City>" else {
            return
        }
        
        WeatherAppDefaults.searchKey = searchKey
        print("Fetching weather report for city : \(searchKey)")
        
        WeatherAppDefaults.searchKey = searchKey
        
        let obj = WeatherAppManager()
        obj.getWeatherReport(city: searchKey!,
                              success: { weather in
                                self.weatherData = weather as! [Weather]
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    self.textField.resignFirstResponder()
                                }
                            },
                              failure: { errorMessage in
                                // on error, should we clear the previous data?
                                DispatchQueue.main.async {
                                    self.alert(title: "Error", message: errorMessage as! String)
                                }
        })
    }
}

