//
//  Days7ForecastVC.swift
//  WeatherForecast
//
//  Created by Mamdouh El Nakeeb on 7/23/17.
//  Copyright © 2017 Mamdouh El Nakeeb. All rights reserved.
//

import UIKit
import Alamofire
import Pulley

class Days7ForecastVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var weaklyForecastTV: UITableView!
    
    var daysForecastArr: Array<DayForecast> = Array<DayForecast>()
    
    let dateFormat: DateFormat = DateFormat()
    
    var selectedCityID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getWeeklyWeatherForecast()
        
       
    }
    
    func getWeeklyWeatherForecast(){
        
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
        
        let url = "http://api.openweathermap.org/data/2.5/forecast/daily?"
            + "id=" + "\(cityID)"
            + "&cnt=" + "\(7)"
            + "&appid=e5b66a0e0cf10b283e6845a11a0d6628"
        
        
        Alamofire.request(url)
            .responseString{
                
                response in
                
                print(url)
                print(response)
                let data = response.value?.data(using: .utf8)!
                
                //getting the json value from the server
                if let result = try? JSONSerialization.jsonObject(with: data!) as! [String:Any] {
                    
                    //converting it as NSDictionary
                    let jsonData = result as NSDictionary
                    let code = jsonData.value(forKey: "cod") as! String
                    print(code)
                    
                    if code == "500"{
                        
                        let alert = UIAlertController(title: "Error", message: "An error occurred", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    else if code == "200"{
                        
                        let weatherDaysArr = jsonData.value(forKey: "list") as? NSArray
                        
                        for weatherDayObj in weatherDaysArr! {
                            
                            let dateInMillis = (weatherDayObj as AnyObject).value(forKey: "dt") as! Int
                            
                            let dayName = self.dateFormat.getDateStr(dateMilli: (dateInMillis)).characters.split{$0 == ","}.map(String.init)[0]
                            
                            
                            let tempObj = (weatherDayObj as AnyObject).value(forKey: "temp") as? NSDictionary
                            
                            let tempMin = tempObj?.value(forKey: "min") as! Int - 273
                            let tempMax = tempObj?.value(forKey: "max") as! Int - 273
                            
                            let weatherDescArr = (weatherDayObj as AnyObject).value(forKey: "weather") as? NSArray
                            
                            let wetherDescObj = weatherDescArr?.firstObject as? NSDictionary
                            
                            
                            var imgName: String = "sunny"
                            print((wetherDescObj?.value(forKey: "description") as! String))
                            
                            switch ((wetherDescObj?.value(forKey: "description") as! String)){
                                
                            case "light rain":
                                imgName = "rainysunny"
                                break
                                
                            case "few clouds":
                                imgName = "cloudysunny"
                                break
                                
                            case "clear sky":
                                imgName = "sunny"
                                break
                                
                            case "sky is clear":
                                imgName = "sunny"
                                break
                                
                            case "scattered clouds":
                                imgName = "cloudy"
                                break
                                
                            case "broken clouds":
                                imgName = "cloudy2"
                                break
                                
                            case "shower rain":
                                imgName = "rainy"
                                break
                                
                            case "rain":
                                imgName = "rainysunny"
                                break
                                
                            case "snow":
                                imgName = "snowy"
                                break
                                
                            default:
                                break
                            }
                            
                            self.daysForecastArr.append(DayForecast.init(dayName: dayName, weatherState: imgName, temp: "\(tempMax)" + "º ↑ / " + "\(tempMin)" + "º ↓"))
                            
                        }
                        
                        
                        self.weaklyForecastTV.reloadData()
                        
                    }
                    
                    
                }
        }
        
    }
    
    func reloadTableData(_ notification: Notification) {
        weaklyForecastTV.reloadData()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysForecastArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! Day7ForecastTVCell
        
        cell.dayNameL.text = daysForecastArr[indexPath.row].dayName
        
        let image = UIImage(named: daysForecastArr[indexPath.row].weatherState)?.withRenderingMode(.alwaysTemplate)
        
        cell.weatherStateIV.tintColor = UIColor.black
        cell.weatherStateIV.image = image
        
        cell.tempMinMaxL.text = daysForecastArr[indexPath.row].temp
        
        cell.backgroundColor = UIColor.clear
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

}


extension Days7ForecastVC: PulleyDrawerViewControllerDelegate {
    
    func collapsedDrawerHeight() -> CGFloat
    {
        return 68.0
    }
    
    func partialRevealDrawerHeight() -> CGFloat
    {
        return 264.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController)
    {
        weaklyForecastTV.isScrollEnabled = drawer.drawerPosition == .open
        
    }
}

