//
//  ViewController.swift
//  test-sathit
//
//  Created by nick on 11/9/2563 BE.
//  Copyright © 2563 is software. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import AlamofireImage

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
 

    @IBOutlet weak var textSearch: UISearchBar!
    @IBOutlet weak var myTable: UITableView!
    
    var nameArr = [String]()
    var addressArr = [String]()
    var iconArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textSearch.delegate =  self
        loadJson()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        loadJson()
        //print("keyword ")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerCell
        
        cell.nameLabel.text = self.nameArr[indexPath.row]
        cell.address.text = self.addressArr[indexPath.row]
        
        let url = self.iconArr[indexPath.row]
        
        if url != "" {
            cell.icon.af_setImage(
                withURL: URL(string: url)!,
                placeholderImage: nil,
                imageTransition: .crossDissolve(0.2)
            )
            
           
            
        }

        
        return cell
        
    }
    
    
    
    
    func loadJson(){
        
        
       
        
        let keyword =  textSearch.text
        
  
        let urlString = "https://api.foursquare.com/v2/venues/explore"
        Alamofire.request(urlString,method: .get, parameters: [
  "client_id":"DE4CFE5HFNFN041WJH3FA104PRPIDFEGFHBSHKVAKXEWNTRN",
  "client_secret":"NGS3SQ5S31RGP0OHHNQTF1QWA4TIFNIA3DBCKZBSAGUZYNXG",
  "v":"20180323",
  "limit":"10",
  "ll":"40.7243,-74.0018",
  "query":"coffee",
            "keyword": keyword ?? "" ],encoding: URLEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success:
                
                if let result = response.result.value{
                    let rr = JSON(result)
                    // self.json = rr
                    //print(rr)
                    
                    
                    self.nameArr = [String]()
                    self.addressArr = [String]()
                    self.iconArr = [String]()
                    
                    
                    for (_,groups) in rr["response"]["groups"]{
                        //print(groups)
                        for (_,value) in groups["items"]{
                          //  print(value)
                            if let  name =  value["venue"]["name"].string{
                                self.nameArr.append(name)
                            }else{
                                self.nameArr.append("")
                            }
                            
                            var addressStr  = ""
                            for (_,addresslist) in value["venue"]["location"]["formattedAddress"]{
                                //print(addresslist)
                                if let  name =  addresslist.string{
                                    addressStr  += " "+name
                                }
                                
                                
                            }
                           self.addressArr.append(addressStr)
                            
                            
                           for (_,categories) in value["venue"]["categories"]{
                                    var iconUrl = ""
                                    if let  name =  categories["icon"]["prefix"].string{
                                        //self.nameArr.append(name)
                                        iconUrl += name
                                    }
                                    if let  name =  categories["icon"]["suffix"].string{
                                        iconUrl += "88"+name
                                    }
                            
                                   self.iconArr.append(iconUrl)
                          
                            }
                        }
                        
                        
                    }
                    
                    
                    
                }
                self.myTable.reloadData()
             
                
                
                
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }

    


}

class ViewControllerCell :UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
}

