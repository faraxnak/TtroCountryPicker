//
//  MICountryPicker.swift
//  MICountryPicker
//
//  Created by Ibrahim, Mustafa on 1/24/16.
//  Copyright © 2016 Mustafa Ibrahim. All rights reserved.
//

import UIKit
import CoreData
import EasyPeasy
import UIColor_Hex_Swift
import PayWandModelProtocols
import PayWandBasicElements

@objc public protocol MICountryPickerDelegate: class {
    @objc optional func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String)
    @objc optional func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, id: Int, dialCode: String)
    @objc optional func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, id: Int, dialCode: String?, currency : String?, flag : UIImage?)
    
    @objc optional func countryPicker(_ picker: MICountryPicker, didSelectCountryWithInfo country: CountryP)
    
    func countryPicker(setInfoType picker: MICountryPicker) -> MICountryPicker.InfoType
    
}

public protocol MICountryPickerDataSource : class {
    
    func country(countryWithNSFRResult result : NSFetchRequestResult) -> CountryP
    
    func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>
    
//    func setFRCPredicate(countryFRC fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, countryInfo : CountryP)
    func setFRCPredicate(countryFRC fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>, name: String? ,isoCode : String?, phoneCode : String?, currency : String?)
    
//    func countryPicker(addCountries countryNames: [String : String],
//                       countryCurrencies : [String: String])
    
    func countryPicker(refreshCountries picker : MICountryPicker)
    //func countryPicker(numberOfCountries picker: MICountryPicker) -> Int
    
}

//public protocol MICountryPickerServerDataSource : class {
//    func countryPicker(_ picker : MICountryPicker, getCountriesName callback: @escaping ([String: String]) -> ())
//    
//    func countryPicker(_ picker : MICountryPicker, getCountriesPhone callback: @escaping ([String: String]) -> ())
//    
//    func countryPicker(_ picker : MICountryPicker, getCountriesCurrency callback: @escaping ([String: String]) -> ())
//}

//@objc public protocol CountryProtocol {
//    
//    var name: String {get set}
//    var id: NSNumber {get set}
//    var phoneCode: String? {get set}
//    var code : String {get set}
//    var currency : String? {get set}
//}

//public class Country: NSObject, CountryProtocol {
//    public static func fetch(id: NSNumber?, name: String?, code: String?) -> CountryProtocol? {
//        return Country()
//    }
//
//    public func updateServer(onFinish: () -> ()) {
//        
//    }
//
//    public func reloadFromServer(onFinish: () -> ()) {
//        
//    }
//    
//    public static func fetch(params : DataProtocol) -> DataProtocol{
//        return Country()
//    }
//    
//    public static func fetchAll() -> [DataProtocol]{
//        return [Country()]
//    }
//    
//    public func store(){
//        
//    }
//    
//    public required init(coreDataObject : NSManagedObject){
//        Country()
//    }
//
//    public override init() {
//        
//    }
//    
//    public var id: NSNumber!
//    public var name: String!
//    public var phoneCode: String!
//    public var code : String!
//    public var currency : String!
//    
//    public var flag : UIImage?
//    public var exchangeRate : Double = 0
//}

public class MICountryPicker: UITableViewController, UISearchBarDelegate {
    fileprivate let countryPickerCell = "countryTableViewCell"
    fileprivate var lastSearch = ""
    fileprivate var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    fileprivate var searchController: UISearchController!
    //fileprivate let collation = UILocalizedIndexedCollation.current() as UILocalizedIndexedCollation
    public weak var pickerDelegate: MICountryPickerDelegate?
    open weak var pickerDataSource : MICountryPickerDataSource!
//    open weak var serverDataSource : MICountryPickerServerDataSource!
    
    open var didSelectCountryClosure: ((String, String) -> ())?
    open var didSelectCountryWithCallingCodeClosure: ((String, String, String) -> ())?
    open var showCallingCodes = true
    
    fileprivate var countries = [String:String]()
    
//    fileprivate var exchangeRatesUSDBased = [String : Double]()
    
    @objc public enum InfoType : Int {
        case currecny, phoneCode, isoCode
    }
    
    public var infoType = InfoType.currecny
    
    convenience public init(completionHandler: ((String, String) -> ())?) {
        self.init()
//        self.didSelectCountryClosure = completionHandler
    }
    
//    public func checkCountryList(){
//        if (coreDataSource.countryPicker(numberOfCountries: self) == 0){
//            getData()
//        }
//    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.TtroColors.white.color
        self.tableView.separatorStyle = .none
        infoType = pickerDelegate?.countryPicker(setInfoType: self) ?? .currecny
        performFetch()
    }
    
    // MARK : navigation bar
    override open func viewWillAppear(_ animated: Bool) {
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: countryPickerCell)
        createSearchBar()
        definesPresentationContext = true
        self.navigationController?.navigationBar.barTintColor = UIColor.TtroColors.white.color
        //        self.navigationController?.navigationBar.translucent = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MICountryPicker.cancel))
        self.navigationController?.view.backgroundColor = UIColor.orange
        self.title = "Select Country"
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Methods
    
    fileprivate func createSearchBar() {
        if self.tableView.tableHeaderView == nil {
            searchController = UISearchController(searchResultsController: nil)
            switch infoType {
            case .currecny:
                searchController.searchBar.scopeButtonTitles = ["Name", "Currency"]
            case .phoneCode:
                searchController.searchBar.scopeButtonTitles = ["Name", "Phone code"]
            case .isoCode:
                searchController.searchBar.scopeButtonTitles = ["Name", "ISO code"]
            }
            searchController.searchResultsUpdater = self
            searchController.searchBar.delegate = self
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.barTintColor = UIColor.TtroColors.white.color
            tableView.tableHeaderView = searchController.searchBar
        }
    }
}

// MARK: - Table view data source

extension MICountryPicker {
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
        //return fetchedCountries.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sections = self.fetchedResultsController.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
        
//        return fetchedCountries[section].count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: countryPickerCell, for: indexPath) as! CountryTableViewCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: CountryTableViewCell?, indexPath: IndexPath) {
        if (cell == nil){
            return
        }
        do {
//            let country = Country() //try fetchedResultsController.object(at: indexPath) as! CountryMO
//            let bundle = "flags.bundle/"
            let country = pickerDataSource.country(countryWithNSFRResult: fetchedResultsController.object(at: indexPath))
            
            if let code = country.code {
                if let filePath = Bundle(for: MICountryPicker.self).path(forResource: "/flags.bundle/" + code.lowercased(), ofType: "png"){
                    cell?.flagImageView.image = UIImage(contentsOfFile: filePath)
                } else {
                    // put general flag image instead of coutries flag
                }
            }
            
            cell?.nameLabel.text = country.name
            
            switch infoType {
            case .currecny:
                cell?.infoLabel.text = country.currency
            case .phoneCode:
                cell?.infoLabel.text = country.phoneCode
            case .isoCode:
                cell?.infoLabel.text = country.code
            }
        } catch {
            print(error)
        }
    }
    
    override open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.fetchedResultsController.sectionIndexTitles
    }
    
    override open func tableView(_ tableView: UITableView,
                                 sectionForSectionIndexTitle title: String,
                                 at index: Int)
        -> Int {
            return self.fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CountryTableViewCell.cellHeight
    }
}

// MARK: - Table view delegate

extension MICountryPicker {
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let country = Country()
        //pickerDataSource.country(country, result: fetchedResultsController.object(at: indexPath))
        let country = pickerDataSource.country(countryWithNSFRResult: fetchedResultsController.object(at: indexPath))
        
        
        searchController.view.endEditing(false)
        let cell = tableView.cellForRow(at: indexPath) as! CountryTableViewCell
        //country.flag = cell.flagImageView.image
        
        pickerDelegate?.countryPicker?(self, didSelectCountryWithName: country.name!, id: country.id, dialCode: country.phoneCode!)
        pickerDelegate?.countryPicker?(self, didSelectCountryWithName: country.name!, id: country.id, dialCode: country.phoneCode, currency: country.currency, flag: cell.flagImageView.image)
        pickerDelegate?.countryPicker?(self, didSelectCountryWithInfo: country)
        didSelectCountryClosure?(country.name!, country.phoneCode!)
        //didSelectCountryWithCallingCodeClosure?(country.name!, country.code, country.phoneCode)
    }
}

// MARK: - UISearchDisplayDelegate

extension MICountryPicker: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text != lastSearch){
            lastSearch = searchController.searchBar.text!
            if (searchController.searchBar.selectedScopeButtonIndex == 1) {
                switch infoType {
                case .currecny:
                    pickerDataSource.setFRCPredicate(countryFRC: fetchedResultsController, name : nil, isoCode: nil, phoneCode: nil, currency: searchController.searchBar.text)
                case .isoCode:
                    pickerDataSource.setFRCPredicate(countryFRC: fetchedResultsController, name : nil, isoCode: searchController.searchBar.text, phoneCode: nil, currency: nil)
                case .phoneCode:
                    pickerDataSource.setFRCPredicate(countryFRC: fetchedResultsController, name : nil, isoCode: nil, phoneCode: searchController.searchBar.text, currency: nil)
                }
                //self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "phoneCode beginswith %@", searchController.searchBar.text!)
            } else if (searchController.searchBar.selectedScopeButtonIndex == 0 && searchController.searchBar.text != ""){
                pickerDataSource.setFRCPredicate(countryFRC: fetchedResultsController, name: searchController.searchBar.text, isoCode: nil, phoneCode: nil, currency: nil)
            } else {
                self.fetchedResultsController.fetchRequest.predicate = nil
                
            }
            performFetch()
        }
    }
}

// MARK : - UISearchBarDelegate

extension MICountryPicker {
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.text = ""
        if (selectedScope == 0){
            searchBar.keyboardType = .default
        } else {
            searchBar.keyboardType = .namePhonePad
        }
        self.fetchedResultsController.fetchRequest.predicate = nil
        performFetch()
    }
    
}

// MARK: - NSFetchedResultsController

extension MICountryPicker : NSFetchedResultsControllerDelegate {
    
    func performFetch() {
        if (fetchedResultsController == nil){
            
            fetchedResultsController = pickerDataSource.createFetchedResultsController()
            fetchedResultsController.delegate = self
            pickerDataSource.countryPicker(refreshCountries: self)
        }
        do {
            try fetchedResultsController.performFetch()
            //fetchedCountries.removeAll()
//            guard let sectionCount = fetchedResultsController.sections?.count else {
//                return
//            }
//            if (sectionCount == 0){
//                getData()
//            }
//            for i in 0 ..< sectionCount {
//                let sections = self.fetchedResultsController.sections!
//                let sectionInfo = sections[i]
//                
//                fetchedCountries.append(sectionInfo.objects as! [CountryMO])
//            }
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
//    func getData() {
//        serverDataSource.countryPicker(self, getCountriesName: { (countries) in
//            self.countries = countries
//            self.getCurrencies()
//        })
//    }
//    
//    func getCurrencies() {
//        serverDataSource.countryPicker(self, getCountriesCurrency: { (currencies) in
//            self.coreDataSource.countryPicker(addCountries: self.countries, countryCurrencies: currencies)
//        })
//    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("here")
        tableView.endUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(cell: tableView.cellForRow(at: indexPath!) as? CountryTableViewCell, indexPath: indexPath!)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .fade)
        case .update:
            break
        case .move:
            break
        }
    }
}

extension MICountryPicker : BWSwipeCellDelegate {
    
}
