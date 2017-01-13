//
//  CountryCodeSelectionViewController.swift
//  SwiftLoginApp
//
//  Created by Sameer Kutty on 18/07/16.
//  Copyright © 2016 com.redbytes. All rights reserved.
//

import UIKit
public protocol CountryCodeSelectionViewControllerDelegate : class
{
    func didSelectCountry(withCode:String)
}
class CountryCodeSelectionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var backButton: UIButton!
    
    var countryArray:NSMutableArray = NSMutableArray()
    var searchResultsArray = NSMutableArray()
    var filteredArray: NSArray = [NSDictionary]() as NSArray
    let noDataLabel = UILabel()
    var searchActive = false
    weak var countryCodedelegate: CountryCodeSelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        let originalImage = UIImage(named:"back_btn")
        //let image: UIImage = UIImage(named: "search_icon")!
        //self.searchBar.setImage(image, for: UISearchBarIcon.search, state: UIControlState.normal)
        let tintedImage = originalImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = UIColor.ExpertConnectRed
        
        noDataLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 21)
        noDataLabel.center = self.view.center
        noDataLabel.textAlignment = .center
        noDataLabel.text = "No Results".localized(in: "Login")
        noDataLabel.font =  UIFont(name: "Raleway-Medium", size: 22)
        noDataLabel.textColor = UIColor.ExpertConnectBlack
        self.view.addSubview(noDataLabel)
        noDataLabel.isHidden = true
        parseTheCountryjson()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setExpertConnectSeacrhBarTheme(searchBar: self.searchBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK: - jsonParsing
    func parseTheCountryjson() {
        if let path = Bundle.main.path(forResource: "CountryCode", ofType: "json") {
            let jsonData = NSData(contentsOfFile: path)
            do {
                let object:NSDictionary = try JSONSerialization.jsonObject(with: jsonData! as Data, options: .allowFragments) as! NSDictionary
                countryArray.addObjects(from: object.value(forKey: "countries")as! NSArray as [AnyObject] )
                if object is [String: AnyObject] {
                    print(countryArray)
                }
                self.tableview.reloadData()
                } catch {
                print("Error")
            }
        }
    }
    
    //MARK:- Tableview Delegates
    func tableView(_ tableView:UITableView, numberOfRowsInSection: Int)->Int
    {
        if searchActive {
            return self.filteredArray.count
        }
        return  countryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as UITableViewCell
        let font = UIFont(name: "Raleway-Light", size: 18)
        if (cell == nil) {
            Bundle.main.loadNibNamed("countryCell", owner: nil, options: nil)?[0]
        }
        
        var countryDict = [String: String]()
        if searchActive {
            countryDict = (self.filteredArray[indexPath.row] as? [String:AnyObject])! as! [String : String]
        } else {
            countryDict = (self.countryArray[indexPath.row] as? [String:AnyObject])! as! [String : String]
        }
        let countryName = countryDict["countryName"]
        let countryCode = countryDict["countryCode"]
        var countryFlag = countryDict["flag"]
        let cap = countryFlag?.capitalized
        countryFlag = cap?.replacingOccurrences(of: "_", with: " ")
        
        let countryFlagImageview = cell.contentView.viewWithTag(101) as! UIImageView
        let countrynameLabel = cell.contentView.viewWithTag(102) as! UILabel
        let dialCodeLabel = cell.contentView.viewWithTag(103) as! UILabel
        
        countryFlagImageview.image = UIImage(named: countryFlag!)
        countrynameLabel.text = countryName
        dialCodeLabel.text = String(format: "%@%@", "+", countryCode!)
        
        countrynameLabel.font = font
        dialCodeLabel.font = font
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var countryDict = [String: String]()
        if searchActive {
            countryDict = (self.filteredArray[indexPath.row] as? [String:AnyObject])! as! [String : String]
        } else {
            countryDict = (self.countryArray[indexPath.row] as? [String:AnyObject])! as! [String : String]
        }
        let countryCode = countryDict["countryCode"]
        countryCodedelegate?.didSelectCountry(withCode: String(format: "%@%@", "+", countryCode!))
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0;//Choose your custom row height
    }
    
    // MARK: SearchBar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let namePredicate = NSPredicate(format: "countryName contains[c] %@",  String(searchText));
        self.filteredArray = self.countryArray.filter { namePredicate.evaluate(with: $0) } as NSArray;
        if !searchText.isEmpty {
            searchActive = true
            noDataLabel.isHidden = self.filteredArray.count == 0 ? false : true
        } else {
            searchActive = false
            noDataLabel.isHidden = true
        }
        self.tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = ""
        searchActive = false
        noDataLabel.isHidden = true
        self.tableview.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.tableview.reloadData()
        return true
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
