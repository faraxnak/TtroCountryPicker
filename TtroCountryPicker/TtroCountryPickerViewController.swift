//
//  TtroCountryPickerViewController.swift
//  Pods
//
//  Created by Farid on 12/20/16.
//
//

import UIKit
import PayWandModelProtocols

public class TtroCountryPickerViewController: UINavigationController {

    
    public var pickerDelegate : MICountryPickerDelegate!
    public var pickerDataSource : MICountryPickerDataSource!
//    public var serverDataSource : MICountryPickerServerDataSource!
    
    let countryPicker = MICountryPicker(completionHandler: nil)
    
    override public func viewDidLoad() {
        self.viewControllers = [countryPicker]
        
        super.viewDidLoad()

        countryPicker.pickerDelegate = self.pickerDelegate
        countryPicker.pickerDataSource = self.pickerDataSource
//        countryPicker.serverDataSource = self.serverDataSource
//        countryPicker.checkCountryList()
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func getCountryFlag(country: CountryP) -> UIImage? {
        return countryPicker.getCountryFlag(country: country)
    }
}
