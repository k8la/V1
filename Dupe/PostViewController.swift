//
//  PostViewController.swift
//  Duplicity
//
//  Created by Kaitlyn on 3/18/15.
//  Copyright (c) 2015 K8La. All rights reserved.
//

import UIKit
import Foundation

class PostViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    func displayAlert(title:String, error:String) {
        
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        

        
        alert.view.tintColor = UIColor(red: 193/255.0, green: 44/255.0, blue: 129/255.0, alpha: 1)

        
    }
    
    var currentPickerTarget: UIImageView!
    var photoSelected:Bool = false
    
    var active:Bool = false
    
    
    @IBOutlet weak var firstImage: UIImageView!

    @IBOutlet weak var firstType: UITextField!
    
    @IBOutlet weak var firstBrand: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var firstPrice: UITextField!
    
    
    @IBOutlet weak var secondImage: UIImageView!
    
    @IBOutlet weak var secondType: UITextField!
    
    @IBOutlet weak var secondBrand: UITextField!
    
    @IBOutlet weak var secondName: UITextField!
    
    @IBOutlet weak var secondPrice: UITextField!
    
    
    @IBAction func submit(sender: AnyObject) {
        
        
        
        var error = ""
        
        if (photoSelected == false) {
            
            error = "Please select an image to post"
            
        } else if (firstType.text == "" || firstBrand.text == "" || firstName.text == "" || firstPrice.text == "" || secondType.text == "" || secondBrand.text == "" || secondName.text == "" || secondPrice.text == "") {
            
            error = "Please enter all fields"
            
        }
        
        
        if error != "" {
            
            displayAlert("Cannot post Dupe", error: error)
            
        } else {
            
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Post")
            

            var username = PFUser.currentUser()["username"] as String

            post["username"] = username
            post["firstType"] = firstType.text
            post["firstBrand"] = firstBrand.text
            post["firstName"] = firstName.text
            post["firstPrice"] = firstPrice.text
            
            post["secondType"] = secondType.text
            post["secondBrand"] = secondBrand.text
            post["secondName"] = secondName.text
            post["secondPrice"] = secondPrice.text
            
            
            let firstImageData = UIImagePNGRepresentation(self.firstImage.image)
            
            let firstImageFile = PFFile(name: "image.png", data: firstImageData)
            
            
            
            
            post["firstImageFile"] = firstImageFile
            
            let secondImageData = UIImagePNGRepresentation(self.secondImage.image)
            
            let secondImageFile = PFFile(name: "image2.png", data: secondImageData)
            
            
            post["secondImageFile"] = secondImageFile
            
            post.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                
                
                
                if success == true {
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    self.performSegueWithIdentifier("ListViewController", sender: self)
                    
                    
                    println("all good")
                    
                    self.displayAlert("Success", error: "Your Dupe has been posted!")
                    
                    
                } else {
                    // Error
                    
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    
                    self.displayAlert("Error", error: "Please try again later")
                    
                    println("fuxored")
                    
                    
                }
            }

            
        }
        
        
    }
    
    @IBAction func selectFirstImage(sender: AnyObject) {
        
        currentPickerTarget = firstImage
        
        photoSelected = true
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let selectPhotoAction = UIAlertAction(title: "Select Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = true
            
            self.presentViewController(image, animated: true, completion: nil)
            
           
        })
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.Camera
            image.allowsEditing = true
            
            self.presentViewController(image, animated: true, completion: nil)

        })
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        

        optionMenu.addAction(selectPhotoAction)
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(cancelAction)
        

        self.presentViewController(optionMenu, animated: true, completion: nil)
        



    }
    
    
    @IBAction func selectSecondImage(sender: AnyObject) {
        currentPickerTarget = secondImage
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = true
            
            self.presentViewController(image, animated: true, completion: nil)
            
            
        })
        let saveAction = UIAlertAction(title: "Take Photo", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            var image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.Camera
            image.allowsEditing = true
            
            self.presentViewController(image, animated: true, completion: nil)
            

            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            println("Cancelled")
        })
        
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
                photoSelected = true
        
        

        
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        currentPickerTarget.image = image

        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationController?.navigationBarHidden = true;

        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    func didTapView(){
        self.view.endEditing(true)
    }
    @IBAction func goBack(sender: AnyObject) {

        self.navigationController?.popViewControllerAnimated(true);
        
    }

}
