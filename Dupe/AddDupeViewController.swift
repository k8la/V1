//
//  AddDupeViewController.swift
//  Duplicity
//
//  Created by mac021 on 10/04/15.
//  Copyright (c) 2015 K8La. All rights reserved.
//

import UIKit

class AddDupeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = true;
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(sender: AnyObject) {

        self.navigationController?.popViewControllerAnimated(true);

    }
    
    func didTapView(){
        self.view.endEditing(true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
