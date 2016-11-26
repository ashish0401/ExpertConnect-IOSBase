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
    
    func get(CountryCode:String)
}
class CountryCodeSelectionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var backButton: UIButton!
    

    var countryArray:NSMutableArray = NSMutableArray()
    var searchResultsArray=NSMutableArray()
    
    weak var delegate: CountryCodeSelectionViewControllerDelegate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        
        let originalImage = UIImage(named:"back_btn")
        
        let image: UIImage = UIImage(named: "search_icon")!
        self.searchBar.setImage(image, for: UISearchBarIcon.search, state: UIControlState.normal)
        
        let tintedImage = originalImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = UIColor.ExpertConnectRed
        
//        self.backImageview = originalImage.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
//        myImageView.image = templateImage
//        myImageView.tintColor = UIColor.orangeColor()
        
        tableview.register(CountryListCell.classForCoder(), forCellReuseIdentifier: "CountryListCell")
        
        parseTheCountryjson()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //  MARK: - jsonParsing   
    func parseTheCountryjson() {
    if let path = Bundle.main.path(forResource: "CountryCode", ofType: "json")
    {
        let jsonData = NSData(contentsOfFile: path)
        do {
            let object:NSDictionary = try JSONSerialization.jsonObject(with: jsonData! as Data, options: .allowFragments) as! NSDictionary
//            print(object);
            countryArray.addObjects(from: object.value(forKey: "countries")as! NSArray as [AnyObject] )
            if object is [String: AnyObject] {
//                readJSONObject(dictionary)
            print(countryArray)
            }
            self.tableview.reloadData()
            
        } catch {
            print("Error")
            //  let error as NSError
            // Handle Error
        }
    }
    }
    
    //MARK:- Tableview Delegates
    func tableView(_ tableView:UITableView, numberOfRowsInSection: Int)->Int
    {
        let xyz = searchBar.text
        
        if xyz?.characters.count==0{
            
            return  countryArray.count
        }
        else{
        return searchResultsArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        var cell = CountryListCell()
        
        
       let  cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as UITableViewCell 
        
        
        if (cell==nil)
        {
            Bundle.main.loadNibNamed("countryCell", owner: nil, options: nil)?[0]
            
        }
        
            let xyz = searchBar.text
            
            if xyz?.characters.count==0
            {
                let cellValue = countryArray[indexPath.row] as! NSDictionary
                let str = cellValue.value(forKey: "name") as? String
                print(str)
                let countrynameLabel = cell.contentView.viewWithTag(102) as! UILabel
                let dialCodeLabel = cell.contentView.viewWithTag(103) as! UILabel
                
                countrynameLabel.text = cellValue.value(forKey: "name") as? String
                dialCodeLabel.text = cellValue.value(forKey: "dial_code") as? String
            }
        else
            {
                let cellValue = searchResultsArray[indexPath.row] as! NSDictionary
                
                let countrynameLabel = cell.contentView.viewWithTag(102) as! UILabel
                let dialCodeLabel = cell.contentView.viewWithTag(103) as! UILabel
                
                countrynameLabel.text = cellValue.value(forKey: "name") as? String
                dialCodeLabel.text = cellValue.value(forKey: "dial_code") as? String
        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell")
        
//        let countrynameLabel = cell.contentView.viewWithTag(102) as! UILabel
//        let dialCodeLabel = cell.contentView.viewWithTag(103) as! UILabel
//        countrynameLabel.text = cellValue.value(forKey: "name") as? String
//        dialCodeLabel.text = cellValue.value(forKey: "dial_code") as? String
        
        
        
        return cell;
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        respondsToSelector("setSpringLoaded:")
//        self.delegate (class_respondsToSelector(<#T##cls: AnyClass!##AnyClass!#>, <#T##sel: Selector!##Selector!#>)
//        self.delegate.respondsToSelector(#selector("get:"))
        
        let xyz = searchBar.text
        
        if xyz?.characters.count==0
        {
            let cellValue = countryArray[indexPath.row] as! NSDictionary
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.catchCountryCode = (cellValue.value(forKey: "dial_code") as? String)!
        }
        else
        {
            let cellValue = searchResultsArray[indexPath.row] as! NSDictionary
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.catchCountryCode = (cellValue.value(forKey: "dial_code") as? String)!
        }
        
       
        
//        delegate?.get(CountryCode: "123")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func searchCountry() {

        let xyz = searchBar.text
        
        if xyz?.characters.count != nil {
            searchResultsArray.removeAllObjects()
            for countryDict in countryArray {
                
                
                //                let dial_code = (countryDict as AnyObject).value(forKey: "dial_code")
                //                var dial_code = (countryDict as AnyObject).value(forKeyPath: "dial_code")
                let name = (countryDict as AnyObject).value(forKey: "name")
                print(name)
                if (name as! String).lowercased().contains((xyz?.lowercased())!) {
                    searchResultsArray.add(countryDict)
                    print(searchResultsArray)
                }
            }
            self.tableview.reloadData()
        }
    }
    
    
    // MARK: SearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchCountry()
        self.tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchCountry()
        self.tableview.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchCountry()
        self.tableview.reloadData()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchCountry()
        self.tableview.reloadData()
        return true
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
