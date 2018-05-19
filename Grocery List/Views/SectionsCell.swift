//
//  SectionsCell.swift
//  Grocery List
//
//  Created by Thomas Foster on 10/15/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

class SectionsCell: UITableViewCell {

	
	@IBOutlet weak var textField: UITextField!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
