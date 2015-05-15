//
//  ListViewController.swift
//  Duplicity
//
//  Created by Kaitlyn on 3/18/15.
//  Copyright (c) 2015 K8La. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableViewAll: UITableView!
    @IBOutlet weak var tableViewSearched: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var viewSearched: UIView!
    @IBOutlet weak var viewLineMe: UIView!
    @IBOutlet weak var viewLineAll: UIView!
    @IBOutlet weak var ButtonMe: UIButton!
    @IBOutlet weak var ButtonAll: UIButton!

    /******* CODE ADDED ********/
    @IBOutlet weak var viewOpen: UIView!
    @IBOutlet weak var firstImageOpen: UIImageView!
    @IBOutlet weak var firstBrandOpen: UILabel!
    @IBOutlet weak var firstNameOpen: UILabel!
    @IBOutlet weak var firstPriceOpen: UILabel!
    @IBOutlet weak var firstTypeOpen: UILabel!
    @IBOutlet weak var secondImageOpen: UIImageView!
    @IBOutlet weak var secondBrandOpen: UILabel!
    @IBOutlet weak var secondNameOpen: UILabel!
    @IBOutlet weak var secondPriceOpen: UILabel!
    @IBOutlet weak var secondTypeOpen: UILabel!
    /******* CODE ADDED END********/
    
    
//    @IBAction func all(sender: AnyObject) {
//    }
//
//
//
//    @IBAction func me(sender: AnyObject) {
//        
//        var username = PFUser.currentUser()["username"] as String
//        
//        
//        var question = PFQuery(className:"Post")
//        question.whereKey("username", equalTo: username)
//        question.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]!, error: NSError!) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                println("Successfully retrieved \(objects!.count) dupes.")
//                // Do something with the found objects
//                
//                
//                
//                if let objects = objects as? [PFObject] {
//                    for object in objects {
//                        println(object.objectId)
//                    }
//                }
//            } else {
//                // Log details of the failure
//                println("Error: \(error!) \(error!.userInfo!)")
//            }
//        }
//
//    }
    
    
    var searchResults = []
    var searchActive : Bool = false
    
    var filteredData = [Product]()
    
    var firstType = [String]()
    var firstBrand = [String]()
    var firstName = [String]()
    var firstPrice = [String]()
    var firstImages = [UIImage]()
    var firstImageFiles = [PFFile]()
    
    var secondType = [String]()
    var secondBrand = [String]()
    var secondName = [String]()
    var secondPrice = [String]()
    var secondImages = [UIImage]()
    var secondImageFiles = [PFFile]()
    
    //    func updateSearchResultsForSearchController(searchController: UISearchController)
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func didTapView()
    {
        self.view.endEditing(true)
        /******* CODE ADDED ********/
        self.viewOpen.hidden = true;
        /******* CODE ADDED END ********/
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "DUPLICITY"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Light", size: 22)!]

        
        
// BUGBUG: back cursor still appears for slight second
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        
        //
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.viewSearched.addGestureRecognizer(tapRecognizer)
        self.viewOpen.addGestureRecognizer(tapRecognizer)
        //
        /* Setup delegates */
        searchBar.delegate = self
        self.tableViewAll.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        var query = PFQuery(className:"Post")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                //success
                println("Successfully retrieved \(objects.count) dupes.")
                
                for object in objects {
                    
                    self.firstType.append(object["firstType"] as String)
                    self.firstBrand.append(object["firstBrand"] as String)
                    self.firstName.append(object["firstName"] as String)
                    self.firstPrice.append(object["firstPrice"] as String)
                    self.firstImageFiles.append(object["firstImageFile"] as PFFile)
                    
                    self.secondType.append(object["secondType"] as String)
                    self.secondBrand.append(object["secondBrand"] as String)
                    self.secondName.append(object["secondName"] as String)
                    self.secondPrice.append(object["secondPrice"] as String)
                    self.secondImageFiles.append(object["secondImageFile"] as PFFile)
                    
                    self.tableViewAll.reloadData()
                } // for ojbect in objects
                
            } else {
                println(error)
            } // if error == nil
            
        } //query.findObjects
        
        viewLineAll.backgroundColor = UIColor(red: 184/255, green: 37/255, blue: 110/255, alpha: 1.0);
        viewLineMe.backgroundColor = UIColor.clearColor()
        ButtonMe.alpha = 0.5;
        ButtonAll.alpha = 1.0;
        
        
    }
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false;
        
    }
    func textFieldShouldBeginEditing(txtFeild: UITextField)-> Bool
    {
        searchActive = true;
        return true;
    }
    func textFieldDidBeginEditing(txtFeild: UITextField)
    {
        searchActive = true;
        
    }
    func textFieldShouldEndEditing(txtFeild: UITextField) -> Bool
    {
        searchActive = false;
        return true;
    }
    func textFieldDidEndEditing(txtFeild: UITextField)
    {
        searchActive = false;
    }
    
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String)
    {
        
        
        filteredData.removeAll(keepCapacity: false)
        
        //To add searched FirstBrand
        var filteredFirstBrand = [String]()
        filteredFirstBrand = firstBrand.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(textField.text, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        for str in filteredFirstBrand {
            println("FirstBrand , \(str)!")
            var index:Int
            index = find(firstBrand, str)!
            var tempProduct = Product()
            tempProduct.firstBrand = firstBrand[index]
            tempProduct.firstName = firstName[index]
            tempProduct.firstPrice = firstPrice[index]
            tempProduct.firstType = firstType[index]
            tempProduct.firstImageFiles = firstImageFiles[index]
            tempProduct.secondBrand = secondBrand[index]
            tempProduct.secondName = secondName[index]
            tempProduct.secondPrice = secondPrice[index]
            tempProduct.secondType = secondType[index]
            tempProduct.secondImageFiles = secondImageFiles[index]
            filteredData.append(tempProduct)
        }
        
        //To add searched SecondBrand
        var filteredSecondBrand = [String]()
        filteredSecondBrand = secondBrand.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(textField.text, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        for str in filteredSecondBrand {
            println("SecondBrand , \(str)!")
            var index:Int
            index = find(secondBrand, str)!
            var tempProduct = Product()
            tempProduct.firstBrand = firstBrand[index]
            tempProduct.firstName = firstName[index]
            tempProduct.firstPrice = firstPrice[index]
            tempProduct.firstType = firstType[index]
            tempProduct.firstImageFiles = firstImageFiles[index]
            tempProduct.secondBrand = secondBrand[index]
            tempProduct.secondName = secondName[index]
            tempProduct.secondPrice = secondPrice[index]
            tempProduct.secondType = secondType[index]
            tempProduct.secondImageFiles = secondImageFiles[index]
            filteredData.append(tempProduct)
        }
        
        
        //To add searched FirstType
        var filteredFirstType = [String]()
        filteredFirstType = firstType.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(textField.text, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        for str in filteredFirstType {
            println("FirstType , \(str)!")
            var index:Int
            index = find(firstType, str)!
            var tempProduct = Product()
            tempProduct.firstBrand = firstBrand[index]
            tempProduct.firstName = firstName[index]
            tempProduct.firstPrice = firstPrice[index]
            tempProduct.firstType = firstType[index]
            tempProduct.firstImageFiles = firstImageFiles[index]
            tempProduct.secondBrand = secondBrand[index]
            tempProduct.secondName = secondName[index]
            tempProduct.secondPrice = secondPrice[index]
            tempProduct.secondType = secondType[index]
            tempProduct.secondImageFiles = secondImageFiles[index]
            filteredData.append(tempProduct)
        }
        
        
        //To add searched SecondType
        var filteredSecondType = [String]()
        filteredSecondType = secondType.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(textField.text, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        for str in filteredSecondType {
            println("SecondType , \(str)!")
            var index:Int
            index = find(secondType, str)!
            var tempProduct = Product()
            tempProduct.firstBrand = firstBrand[index]
            tempProduct.firstName = firstName[index]
            tempProduct.firstPrice = firstPrice[index]
            tempProduct.firstType = firstType[index]
            tempProduct.firstImageFiles = firstImageFiles[index]
            tempProduct.secondBrand = secondBrand[index]
            tempProduct.secondName = secondName[index]
            tempProduct.secondPrice = secondPrice[index]
            tempProduct.secondType = secondType[index]
            tempProduct.secondImageFiles = secondImageFiles[index]
            filteredData.append(tempProduct)
        }
        
        
        //To add searched FirstName
        var filteredFirstName = [String]()
        filteredFirstName = firstName.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(textField.text, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        for str in filteredFirstName {
            println("FirstName , \(str)!")
            var index:Int
            index = find(firstName, str)!
            var tempProduct = Product()
            tempProduct.firstBrand = firstBrand[index]
            tempProduct.firstName = firstName[index]
            tempProduct.firstPrice = firstPrice[index]
            tempProduct.firstType = firstType[index]
            tempProduct.firstImageFiles = firstImageFiles[index]
            tempProduct.secondBrand = secondBrand[index]
            tempProduct.secondName = secondName[index]
            tempProduct.secondPrice = secondPrice[index]
            tempProduct.secondType = secondType[index]
            tempProduct.secondImageFiles = secondImageFiles[index]
            filteredData.append(tempProduct)
        }
        
        
        //to add searched SecondName
        var filteredSecondName = [String]()
        filteredSecondName = secondName.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(textField.text, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        for str in filteredSecondName {
            println("SecondName , \(str)!")
            var index:Int
            index = find(secondName, str)!
            var tempProduct = Product()
            tempProduct.firstBrand = firstBrand[index]
            tempProduct.firstName = firstName[index]
            tempProduct.firstPrice = firstPrice[index]
            tempProduct.firstType = firstType[index]
            tempProduct.firstImageFiles = firstImageFiles[index]
            tempProduct.secondBrand = secondBrand[index]
            tempProduct.secondName = secondName[index]
            tempProduct.secondPrice = secondPrice[index]
            tempProduct.secondType = secondType[index]
            tempProduct.secondImageFiles = secondImageFiles[index]
            filteredData.append(tempProduct)
        }
        println("SecondName , \(self.searchBar.text)!")
        
        
        if(string == "")
        {
            filteredData.removeAll(keepCapacity: false)
        }
        self.tableViewSearched.reloadData()
    }



    @IBAction func cancel(sender: AnyObject) {
        searchActive = false;

        searchBar.text = "";
        tableViewSearched.reloadData();


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchBar.text != "") {
            if(filteredData.count > 0)
            {
                self.tableViewSearched.hidden = false;
                self.viewSearched.hidden = false;
                self.tableViewAll.scrollEnabled = false;                    self.tableViewAll.userInteractionEnabled = false;
                
            }
            else
            {
                self.tableViewSearched.hidden = true;
                self.viewSearched.hidden = true;
                self.tableViewAll.scrollEnabled = true;                    self.tableViewAll.userInteractionEnabled = true;
                
            }
        }
        //If no item is searched then show all data
        if(tableView == tableViewSearched)
        {
            if(self.searchBar.text != "") {
                if(filteredData.count > 0)
                {
                    self.tableViewSearched.hidden = false;
                    self.viewSearched.hidden = false;
                    self.tableViewAll.scrollEnabled = false;                    self.tableViewAll.userInteractionEnabled = false;
                    
                }
                else
                {
                    self.tableViewSearched.hidden = true;
                    self.viewSearched.hidden = true;
                    self.tableViewAll.userInteractionEnabled = true;
                    self.tableViewAll.scrollEnabled = true;
                }
            }
            else
            {
                self.tableViewSearched.hidden = true;
                self.viewSearched.hidden = true;
                self.tableViewAll.scrollEnabled = true;
                self.tableViewAll.userInteractionEnabled = true;
                
            }
            return filteredData.count
            
        }
        return self.firstType.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        myCell.title.text = titles[indexPath.row]
        //        myCell.username.text = usernames[indexPath.row]
        
        
        //If any item is searched then show searched data else show all data
        if(tableView == tableViewSearched)
        {
            let cell = self.tableViewSearched.dequeueReusableCellWithIdentifier("myCellSearch", forIndexPath: indexPath) as CustomTableViewCell
            
            
            cell.firstBrand.text = filteredData[indexPath.row].firstBrand
            cell.firstName.text = filteredData[indexPath.row].firstName;
            cell.firstPrice.text = "$" + filteredData[indexPath.row].firstPrice
            cell.firstType.text = filteredData[indexPath.row].firstType
            
            
            cell.secondBrand.text = filteredData[indexPath.row].secondBrand
            cell.secondName.text = filteredData[indexPath.row].secondName
            cell.secondPrice.text = "$" + filteredData[indexPath.row].secondPrice
            cell.secondType.text = filteredData[indexPath.row].secondType
            
            
            filteredData[indexPath.row].firstImageFiles.getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                
                if error == nil {
                    println("found image")
                    let image = UIImage(data: imageData)
                    
                    cell.firstImage.image = image
                }
                
            }
            
            filteredData[indexPath.row].secondImageFiles.getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                
                if error == nil {
                    println("found image")
                    let image = UIImage(data: imageData)
                    
                    cell.secondImage.image = image
                }
                
            }
            cell.firstName.sizeToFit();
            
            cell.updateConstraints();
            
            return cell
            
        }
            
        else
        {
            let cell = self.tableViewAll.dequeueReusableCellWithIdentifier("myCellAll", forIndexPath: indexPath) as CustomTableViewCell
            
            
            cell.firstBrand.text = firstBrand[indexPath.row]
            cell.firstName.text = firstName[indexPath.row] + " " + firstType[indexPath.row]
            cell.firstPrice.text = "$" + firstPrice[indexPath.row]
            cell.firstType.text = firstType[indexPath.row]
            
            
            cell.secondBrand.text = secondBrand[indexPath.row]
            cell.secondName.text = secondName[indexPath.row] + " " + secondType[indexPath.row]
            cell.secondPrice.text = "$" + secondPrice[indexPath.row]
            cell.secondType.text = secondType[indexPath.row]
            
            
            firstImageFiles[indexPath.row].getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                
                if error == nil {
                    println("found image")
                    let image = UIImage(data: imageData)
                    
                    cell.firstImage.image = image
                }
                
            }
            
            secondImageFiles[indexPath.row].getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                
                if error == nil {
                    println("found image")
                    let image = UIImage(data: imageData)
                    
                    cell.secondImage.image = image
                }
                
            }
            
            cell.firstName.sizeToFit();
            cell.updateConstraints();
            
            
            return cell
            
        }
        
        
    }

    @IBAction func selectAllFromTable(sender: AnyObject) {

        viewLineAll.backgroundColor = UIColor(red: 184/255, green: 37/255, blue: 110/255, alpha: 1.0);
        viewLineMe.backgroundColor = UIColor.clearColor()
        ButtonMe.alpha = 0.5;
        ButtonAll.alpha = 1.0;


    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
     {
        if( searchActive == true )
        {
            /******* CODE ADDED ********/

            self.viewOpen.hidden = true;
            /******* CODE ADDED END********/

            self.view.endEditing(true)
        }

        else if(tableView == tableViewSearched)
        {
            /******* CODE ADDED ********/

            self.viewOpen.hidden = true;
            /******* CODE ADDED END********/

//            self.performSegueWithIdentifier("showFeature", sender: nil);
        }
            
            /******* CODE ADDED ********/
        else if(tableView == tableViewAll)
        {
        
            self.viewOpen.hidden = false;
            
            firstBrandOpen.text = firstBrand[indexPath.row]
            firstNameOpen.text = firstName[indexPath.row];
            firstPriceOpen.text = "$" + firstPrice[indexPath.row]
            firstTypeOpen.text = firstType[indexPath.row]
            
            
            secondBrandOpen.text = secondBrand[indexPath.row]
            secondNameOpen.text = secondName[indexPath.row]
            secondPriceOpen.text = "$" + secondPrice[indexPath.row]
            secondTypeOpen.text = secondType[indexPath.row]
            
            
            firstImageFiles[indexPath.row].getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                
                if error == nil {
                    println("found image")
                    let image = UIImage(data: imageData)
                    
                    self.firstImageOpen.image = image
                }
                
            }
            
            secondImageFiles[indexPath.row].getDataInBackgroundWithBlock{
                (imageData: NSData!, error: NSError!) -> Void in
                
                if error == nil {
                    println("found image")
                    let image = UIImage(data: imageData)
                    
                    self.secondImageOpen.image = image
                }
            }
//            
//                self.firstNameOpen.sizeToFit();
//            
//            self.firstNameOpen.updateConstraints();
//

            
        }
        /******* CODE ADDED END********/

        


    }

    @IBAction func selectMe(sender: AnyObject) {

        viewLineMe.backgroundColor = UIColor(red: 184/255, green: 37/255, blue: 110/255, alpha: 1.0);
        viewLineAll.backgroundColor = UIColor.clearColor()
        ButtonAll.alpha = 0.5;
        ButtonMe.alpha = 1.0;

    }



    
}
