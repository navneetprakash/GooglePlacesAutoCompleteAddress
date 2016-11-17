//
//  ViewController.swift
//  AppGooglePlacesExample
//
//  Created by Navneet Prakash on 17/11/16.
//  Copyright © 2016 Navneet Prakash. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController, UISearchDisplayDelegate {
    
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var suburb: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var country: UITextField!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var tableDataSource: GMSAutocompleteTableDataSource?
    var srchDisplayController: UISearchDisplayController?
    
    var model = AddressModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableDataSource = GMSAutocompleteTableDataSource()
        tableDataSource?.delegate = self
        
        srchDisplayController = UISearchDisplayController(searchBar: searchBar!, contentsController: self)
        srchDisplayController?.searchResultsDataSource = tableDataSource
        srchDisplayController?.searchResultsDelegate = tableDataSource
        srchDisplayController?.delegate = self
    }
    
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator off.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        // Reload table data.
        srchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        // Turn the network activity indicator on.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Reload table data.
        srchDisplayController?.searchResultsTableView.reloadData()
    }
    
    func connectOutlets() {
        street.text = model.street_address
        suburb.text = model.suburb
        city.text = model.post_code
        country.text = model.country
    }

}

extension ViewController: GMSAutocompleteTableDataSourceDelegate {
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        srchDisplayController?.isActive = false
        
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        
        let address_list = (place.formattedAddress?.characters.split(separator: ",").map(String.init))!
        
        print(address_list)
        
        model.street_address = address_list[0]
        model.suburb = address_list[1]
        model.post_code = address_list[2]
        model.country = address_list[3]
        
        print(model.street_address)
        print(model.suburb)
        print(model.post_code)
        print(model.country)
        
        connectOutlets()
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        tableDataSource?.sourceTextHasChanged(searchString)
        return false
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        // TODO: Handle the error.
        print("Error: \(error.localizedDescription)")
    }
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
}

