//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Mamdouh El Nakeeb on 7/22/17.
//  Copyright © 2017 Mamdouh El Nakeeb. All rights reserved.
//

import UIKit
import Alamofire

class Home: UIViewController, SearchVCDelegate {

    @IBOutlet weak var dayWeatherIcon: UIImageView!
    @IBOutlet weak var minMaxV: UIView!
    @IBOutlet weak var minV: UIView!
    @IBOutlet weak var maxV: UIView!
    @IBOutlet weak var minTempL: UILabel!
    @IBOutlet weak var maxTempL: UILabel!
    @IBOutlet weak var currentTempL: UILabel!
    @IBOutlet weak var cityL: UILabel!
    @IBOutlet weak var countryL: UILabel!
    @IBOutlet weak var dayNoL: UILabel!
    @IBOutlet weak var dayNameL: UILabel!
    @IBOutlet weak var monthNameL: UILabel!
    
    
    var cityData = [City]()
    
    var selectedCityID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initDate()
        initViews()
        
        getWeatherByCityID()
        _ = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(getWeatherByCityID), userInfo: nil, repeats: true)
        
        let image = UIImage(named:"cloudy")?.withRenderingMode(.alwaysTemplate)
    
        dayWeatherIcon.tintColor = UIColor.white
        dayWeatherIcon.image = image
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readJson()
    }
    
    func initViews (){
        
        self.currentTempL.center = self.view.center
        
        self.minMaxV.frame = CGRect(x: 0, y: self.currentTempL.frame.minY - self.minV.frame.height - 10, width: self.view.frame.width, height: 50)
        self.minV.frame = CGRect(x: (self.view.frame.width / 2) - 60, y: 0, width: 50, height: self.minMaxV.frame.height)
        self.maxV.frame = CGRect(x: (self.view.frame.width / 2) + 10, y: 0, width: 50, height: self.minMaxV.frame.height)
    }
    
    func initDate(){
        
        let dateFormat: DateFormat = DateFormat()
        
        let dateArr = dateFormat.getDateStr(dateMilli: (Int(NSDate().timeIntervalSince1970))).characters.split{$0 == ","}.map(String.init)
        
        print("date is")
        print(dateArr)
        self.dayNoL.text = dateArr[1]
        self.dayNameL.text = dateArr[0]
        self.monthNameL.text = dateArr[2]
    }
    
    func addWeeklyForecastView(scrollable: Bool? = true){
        let days7Forecast = scrollable! ? Days7ForecastVC() : UIViewController()
        
        self.addChildViewController(days7Forecast)
        self.view.addSubview(days7Forecast.view)
        days7Forecast.didMove(toParentViewController: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        days7Forecast.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    
    private func readJson() {
        
        if cityData.count == 0{
        
            DispatchQueue.global().async {
                do {
                    if let file = Bundle.main.url(forResource: "city", withExtension: "json") {
                        let data = try Data(contentsOf: file)
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let citiesData = json as? NSArray {
                            // json is an array
                            
                            
                            for cityItem in citiesData{
                                
                                
                                let id = (cityItem as AnyObject).value(forKey: "id") as! Int
                                let city = (cityItem as AnyObject).value(forKey: "name") as! String
                                let country = (cityItem as AnyObject).value(forKey: "country") as! String
                                
                                print(city + ", " + country)
                                
                                self.cityData.append(City.init(id: id, name: city, country: country))
                                
                            }
                            
                            //tblSearch.reloadData()
                            
                        } else {
                            print("JSON is invalid")
                        }
                    } else {
                        print("no file")
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
        }
        
        
    }
    

    
    func getWeatherByCityID(){
     
        let utils: Utils = Utils()
        
        if !utils.isConnectedToNetwork(){
            let alert = UIAlertController(title: "Alert", message: "There's problem connecting the internet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try again later", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let userDefaults = UserDefaults.standard
        var cityID: Int = 0
        
        if self.selectedCityID == 0 {
            cityID = userDefaults.value(forKey: "cityID") as! Int
        }
        else{
            cityID = self.selectedCityID
        }
        
        
        let url = "http://api.openweathermap.org/data/2.5/weather?"
            + "id=" + "\(cityID)"
            + "&appid=e5b66a0e0cf10b283e6845a11a0d6628"
        
        
        Alamofire.request(url)
            .responseString{
                
                response in
                
                print(url)
                print(response)
                //return
                let data = response.value?.data(using: .utf8)!
                
                
                //getting the json value from the server
                if let result = try? JSONSerialization.jsonObject(with: data!) as! [String:Any] {
                    
                    //converting it as NSDictionary
                    let jsonData = result as NSDictionary
                    let code = jsonData.value(forKey: "cod") as! Int
                    print(code)
                    
                    if code == 500{

                        let alert = UIAlertController(title: "Error", message: "An error occurred", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    else if code == 200{
                        
                        
                        let tempObj = jsonData.value(forKey: "main") as? NSDictionary
                        let countryObj = jsonData.value(forKey: "sys") as? NSDictionary
                        let weatherDescArr = jsonData.value(forKey: "weather") as? NSArray
                        let wetherDescObj = weatherDescArr?.firstObject as? NSDictionary
        
                        let cityName = jsonData.value(forKey: "name") as? String
                        let cityID = jsonData.value(forKey: "id") as? Int
                        
                        self.cityL.text = cityName! + ", " + (countryObj?.value(forKey: "country") as? String)!
                        self.currentTempL.text = "\((tempObj?.value(forKey: "temp") as?  Int)! - 273)" + "º"
                        self.minTempL.text = "\((tempObj?.value(forKey: "temp_min") as?  Int)! - 273)" + "º"
                        self.maxTempL.text = "\((tempObj?.value(forKey: "temp_max") as?  Int)! - 273)" + "º"
                        
                        
                        switch ((wetherDescObj?.value(forKey: "description") as? String)!){
                            
                        case "light rain":
                            let image = UIImage(named:"rainysunny")?.withRenderingMode(.alwaysTemplate)
                            
                            self.dayWeatherIcon.tintColor = UIColor.white
                            self.dayWeatherIcon.image = image
                            break
                            
                        case "few clouds":
                            let image = UIImage(named:"cloudysunny")?.withRenderingMode(.alwaysTemplate)
                            
                            self.dayWeatherIcon.tintColor = UIColor.white
                            self.dayWeatherIcon.image = image
                            break
                            
                        case "clear sky":
                            let image = UIImage(named:"sunny")?.withRenderingMode(.alwaysTemplate)
                            
                            self.dayWeatherIcon.tintColor = UIColor.white
                            self.dayWeatherIcon.image = image
                            break
                            
                        case "scattered clouds":
                            let image = UIImage(named:"cloudy")?.withRenderingMode(.alwaysTemplate)
                            
                            self.dayWeatherIcon.tintColor = UIColor.white
                            self.dayWeatherIcon.image = image
                            break
                            
                        case "broken clouds":
                            let image = UIImage(named:"cloudy2")?.withRenderingMode(.alwaysTemplate)
                            
                            self.dayWeatherIcon.tintColor = UIColor.white
                            self.dayWeatherIcon.image = image
                            break
                            
                        case "shower rain":
                            let image = UIImage(named:"rainy")?.withRenderingMode(.alwaysTemplate)
                            
                            self.dayWeatherIcon.tintColor = UIColor.white
                            self.dayWeatherIcon.image = image
                            break
                            
                        case "rain":
                            let image = UIImage(named:"rainysunny")?.withRenderingMode(.alwaysTemplate)
                            
                            self.dayWeatherIcon.tintColor = UIColor.white
                            self.dayWeatherIcon.image = image
                            break
                            
                        case "snow":
                            let image = UIImage(named:"snowy")?.withRenderingMode(.alwaysTemplate)
                            
                            self.dayWeatherIcon.tintColor = UIColor.white
                            self.dayWeatherIcon.image = image
                            break
                            
                        default:
                            break
                        }
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(cityID, forKey: "cityID")
                       
                        userDefaults.synchronize()
                        
                    }
                    
                    
                }
        }
    }
    
    
    @IBAction func searchBtnOnClick(_ sender: Any) {
        
        openSearchVC()
        
    }
    
    func openSearchVC() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
    
        searchVC.delegate = self
        searchVC.cityData = self.cityData
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    
    func didFinishSecondVC(searchVC: SearchVC) {
        self.selectedCityID = searchVC.selectedCityID
        getWeatherByCityID()
    }
}



