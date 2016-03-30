//
//  ViewController.swift
//  Forecast App Prototype
//
//  Created by Fahad Ali Khan on 03/11/15.
//  Copyright (c) 2015 MapCase Media. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

/*
class viewController conforms to weatherServiceDelegate. UIViewController = super class.

*/

class ViewController: UIViewController, weatherServiceDelegate, CLLocationManagerDelegate {
    
    
    /*
    Creating an instance of class weatherService
    */
    var weatherServiceObj = weatherService()
    
    
    /*
    Outlets being defined for Labels in the Storyboard
    */
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var mapOutlet: MKMapView!
    
    @IBOutlet weak var toggleOutlet: UISwitch!
    
    /*
    instance of CLLocationManager class created
    */
    let locMgr = CLLocationManager()
    
    
    /*
    Created a variable to store recently updated locations
    */
    var location: CLLocation!
    
    
    /*
    this variable stores the name of city provided by CLLocation
    
    Type is AnyObject because we dont know the type of returned data
    */
    var cityLocPro: AnyObject!
    
    
    /*
    variables to be passed to  the getWeather()
    
    they will store lat/long values
    */
    var myLat: Double!
    
    var myLon: Double!
    
    
    /*
    Action function for the button
    */
    @IBAction func updateWeatherButton(sender: UIButton)
    {
        self.weatherServiceObj.getWeather(self.myLat!,  myLon: self.myLon!)
        
        locMgr.startUpdatingLocation()
    }
    
    
    
    
    
    
    /*
    setWeather function is created to conform with the delegate protocol
    */
    func setWeather(weatherDataObj: weatherData)
    {
        /*
        showing weather parameters onto the labels
        */
        //cityLabel.text = weatherDataObj.cityNameStruct
        cityLabel.text = "\(cityLocPro)"
        
        if toggleOutlet.on
        {
            tempLabel.text = "\(weatherDataObj.tempStruct)"
            
        }
            
        else
        {
            tempLabel.text = "\(weatherDataObj.tempFahStruct)"
            
        }
        
        //descLabel.text = weatherDataObj.descriptionStruct
    }
    
    
    /*
    this function runs after the view has been loaded
    */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        /*
        creating the link between the delegate class and the view controller class
        
        self = object of viewController class
        
        assgining the self object to the delegate variable of weatherService class
        */
        self.weatherServiceObj.delegate = self
        
        
        
        /*
        setting the GPS accuracy at best as we need accurate coordinates
        */
        locMgr.desiredAccuracy = kCLLocationAccuracyBest
        
        /*
        Asking for authorization from the user (key must also be added to info.plist)
        */
        locMgr.requestWhenInUseAuthorization()
        
        /*
        After the user has given permission, start updating location
        */
        locMgr.startUpdatingLocation()
        
        /*
        Assigning the delegate to self
        */
        locMgr.delegate = self
    }
    
    
    
    
    /*
    Delegate Method
    */
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        /*
        storing the most recently updated location into the constant currentLocation
        */
        
        
        location = (locations as [CLLocation]).last
        
        latLabel.text = "\(location.coordinate.latitude)"
        
        longLabel.text = "\(location.coordinate.longitude)"
        
        
        /*
        GeoCoder: Conversion of coordinates to a tangible address
        
        Defining the instance of CLGeocoder and calling the reverse geocoding function.
        
        Passed an object of type CLLocation! to the reverse geocoder function. This object contains coordinates, speed, accuracy etc. so the reverseCoder will take these values and provide us with a human tangible address
        */
        
        CLGeocoder().reverseGeocodeLocation(location){
            
            (myPlacements, myError) ->Void in
            
            /*
            Store the placement provided by Geocoder into the variable called myPlacement
            */
            if let myPlacement: AnyObject = myPlacements?.first
            {
                /*
                Getting address data from placement variable and storing it into a string
                */
                let currentAddress = "\(myPlacement.locality!)" + ", " + "\(myPlacement.country!)" + ", " + "\(myPlacement.postalCode!)"
                
                /*
                Feeding the string to the myAddress label to finaaly display the address
                */
                self.addressLabel.text = currentAddress
                
                
                
                /*
                Save location name and print on console
                */
                self.cityLocPro = myPlacement.locality!
                
                
                /*
                Storing the lat, long values into the variables. these variables are passed to the getWeather function
                */
                self.myLat = self.location.coordinate.latitude
                
                self.myLon = self.location.coordinate.longitude
                
                
                /*
                Map Part
                */
                
                var mapLocation = CLLocationCoordinate2DMake(self.myLat!, self.myLon!) //(48.88182, 2.43952)
                
                var mapAnnotation = MKPointAnnotation()
                
                var span = MKCoordinateSpanMake(0.00002, 0.00002)
                
                var region = MKCoordinateRegion(center: mapLocation, span: span)
                
                self.mapOutlet.setRegion(region, animated: true)
                
                mapAnnotation.setCoordinate(mapLocation)
                
                mapAnnotation.title = " Pizzeria Ristornate"
                mapAnnotation.subtitle = "Luna Rossa"
                
                
                self.weatherServiceObj.getWeather(self.myLat!,  myLon: self.myLon!)
                
                
                self.mapOutlet.addAnnotation(mapAnnotation)
                
            }
            
        }
        
    }
    
    
    
    
}
