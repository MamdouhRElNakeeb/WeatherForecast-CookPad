//
//  SearchVC.swift
//  WeatherForecast
//
//  Created by Mamdouh El Nakeeb on 7/23/17.
//  Copyright © 2017 Mamdouh El Nakeeb. All rights reserved.
//

import UIKit

class SearchVC: UIViewController ,UITableViewDataSource,UITableViewDelegate , UISearchResultsUpdating , UISearchBarDelegate{

    @IBOutlet weak var tblSearch: UITableView!
    
    var cityData = [City]()
    var filteredArray = [City]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
   
    var delegate: SearchVCDelegate! = nil
    
    var selectedCityID: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        configureSearchController()
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search by City"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        
    
        self.tblSearch.tableHeaderView = searchController.searchBar
    }
    
    //MARK:- table datasource
    //MARK:-
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return cityData.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row].name + ", " + cityData[indexPath.row].country
        }
        else {
            cell.textLabel?.text = cityData[indexPath.row].name + ", " + cityData[indexPath.row].country
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if shouldShowSearchResults {
            self.selectedCityID = filteredArray[indexPath.row].id
        }
        else{
            self.selectedCityID = cityData[indexPath.row].id
        }
        _ = navigationController?.popViewController(animated: true)
        delegate.didFinishSecondVC(searchVC: self)
    }
    //MARK:- search update delegate
    //MARK:-
    
    public func updateSearchResults(for searchController: UISearchController){
        let searchString = searchController.searchBar.text
        
        // Filter the data array and get only those countries that match the search text.
        
        filteredArray = cityData.filter({ (country) -> Bool in
            let countryText: NSString = country.name as NSString
            return (countryText.range(of: searchString!, options: .caseInsensitive).location) != NSNotFound
        })
        tblSearch.reloadData()
    }
    
    //MARK:- search bar delegate
    //MARK:-
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearch.reloadData()
    }
    
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblSearch.reloadData()
    }

}

protocol SearchVCDelegate {
    func didFinishSecondVC(searchVC: SearchVC)
}
