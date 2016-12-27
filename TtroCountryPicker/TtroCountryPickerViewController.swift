//
//  TtroCountryPickerViewController.swift
//  Pods
//
//  Created by Farid on 12/20/16.
//
//

import UIKit

public class TtroCountryPickerViewController: UINavigationController {

    
    public var pickerDelegate : MICountryPickerDelegate!
    public var coreDataSource : MICountryPickerDataSource!
//    public var serverDataSource : MICountryPickerServerDataSource!
    
    let countryPicker = MICountryPicker(completionHandler: nil)
    
//    convenience init(){
//        self.init(rootViewController : countryPicker)
//    }
//    
//    override init(rootViewController: UIViewController) {
//        super.init(rootViewController : rootViewController)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override public func viewDidLoad() {
        self.viewControllers = [countryPicker]
        
        super.viewDidLoad()

        countryPicker.pickerDelegate = self.pickerDelegate
        countryPicker.coreDataSource = self.coreDataSource
//        countryPicker.serverDataSource = self.serverDataSource
//        countryPicker.checkCountryList()
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
