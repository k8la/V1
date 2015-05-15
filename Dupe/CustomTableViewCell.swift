//
//  CustomTableViewCell.swift
//  Duplicity
//
//  Created by Kaitlyn on 3/21/15.
//  Copyright (c) 2015 K8La. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var firstImage: UIImageView!
   
    @IBOutlet weak var firstBrand: UILabel!

    @IBOutlet weak var firstName: UILabel!
    

    @IBOutlet weak var firstPrice: UILabel!
    @IBOutlet weak var firstType: UILabel!

    
    @IBOutlet weak var secondImage: UIImageView!
    
    @IBOutlet weak var secondBrand: UILabel!
    
    @IBOutlet weak var secondName: UILabel!


    @IBOutlet weak var secondPrice: UILabel!
    @IBOutlet weak var secondType: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
