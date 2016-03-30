

//
//  weatherService.swift
//  OWM_Weather
//
//  Created by Fahad Ali Khan on 18/11/15.
//  Copyright (c) 2015 MapCase Media. All rights reserved.
//

import Foundation

/*
definition of protocol
*/
protocol weatherServiceDelegate
{
    /*
    this funciton must be implemented by any conforming class (e.g viewController)
    */
    func setWeather(weatherDataObj: weatherData)
}

/*
weatherService class implementation
*/
class weatherService
{
    /*
    variable defined for the purpose of delegation.
    
    Serves as a link between the two classes
    */
    var delegate: weatherServiceDelegate?
    
    /*
    this function takes coordinates and provides the weather data for that location
    */
    
    
    //func getWeather(city: String)
    func getWeather(myLat: Double, myLon: Double)
    {
        /*
        creating a url object of type NSURL
        */
        let url = NSURL(string: getUrl(myLat, myLon: myLon))
        
        
        /*
        creating a web session for data exchange
        */
        let session = NSURLSession.sharedSession()
        
        
        /*
        creating a task. The output of task function is the weather data i.e "data"
        */
        let task = session.dataTaskWithURL(url, completionHandler: completionHandler)
        
        /*
        start running the task
        */
        task.resume()
    }
    
    func completionHandler(dataFromServer: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
        /*
        creating a json type object. Data obtained from task is parsed in json format
        */
        let json = JSON(data: dataFromServer!)
        
        
        /*
        the returned json object contains alot of weather info. Following are some of the parameters
        in which we are interested. The parameters are being typecasted to appropriate types
        */
        let lon = json["lon"].double
        
        let lat = json["lat"].double
        
        /*
        JSON provides default temperature in Kelvin, so we need to convert it to Centigrades
        Also the data is double type number , we only want integer level accuracy, so we
        convert to int.
        
        To get precise value , use temp in function calls instead of tempInt , also change the
        data type to double in weatherData struct file
        */
        let temp = (json["Temperature (C)"][4].double)
        
        let tempFah = (temp! * (9/5)) + 32
        
        let name = "dummy city"
        
        //let desc = json["weather"][0]["description"].string
        let desc = "Nice Weather..!!"
        
        /*
        instance of the struct weatherData created. struct is defined in a seperate file
        */
        let weatherStructObj = weatherData(cityName: name, temp: temp, tempFah:tempFah, description: desc)
        
        
        /*
        if delegate is not nil
        */
        if self.delegate != nil
        {
            /*
            go to the main thread
            */
            dispatch_async(dispatch_get_main_queue(), { ()
                
                /*
                launch the set weather function present in viewController class
                */
                self.delegate?.setWeather(weatherStructObj)
            })
            
        }
        
        /*
        show weather parameters in console for testing purposes
        */
        //print("lat: \(lat) lon: \(lon) temp: \(tempInt)")
    }
    
    func getUrl(myLat: Double, myLon:Double) -> String
    {
        /*
        declaration of variables which make up the path string
        */
        let metgisPath: String = "http://93.189.28.8:8080/forecast?"
        let metgisKey: String = "&key=1f7265d572536674f4e1bab1ec"
        let apiLatitude: String = "lat="
        let apiLongitude: String = "&lon="
        let apiAltittude: String = "&alt="
        
        
        /*
        LC-3
        creating the URL string
        */
        
        let lat_metgis: String = "\(myLat)"
        print("lat_metgis = " + "\(lat_metgis)" + "__")
        
        let lon_metgis: String = "\(myLon)"
        print("lon_metgis = " + "\(lon_metgis)" + "__")
        
        let myAlt = 1
        let alt_metgis: String = "\(myAlt)"
        print("alt_metgis = " + "\(alt_metgis)" + "__")
        
        return metgisPath + apiLatitude + lat_metgis + apiLongitude + lon_metgis + apiAltittude + alt_metgis + metgisKey
    }
    
    /*
    initializer/ constructor
    */
    
    init()
    {
        
    }
}