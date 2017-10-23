# WeatherForecast-CookPad-Internship

Technologies used:
- Swift
- Alamofire for HTTP requests.
- Pully for scrollable overlaying views

Home ViewController: 
- The main view that has:
  - Today current tempature, minimum and maximum.
  - Current day number, name and month.
  - City name
  - Search icon to access search by city view.
  - scrollable bottom view for weakly forecast.

Search ViewController:
- The view that has a list of all cities to search.

Day7Forecast ViewController:
- a scrollable bottom view that display the weakly weather forcast and has:
  - Day name
  - Minimum and maximum temprature.
  - Weather condition icon.
  
Utils Class: 
- That check internet connection.

DayFormat Class:
- That get date values from TimeInMillis integer value.
