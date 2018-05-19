//
//  MasterListCell.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/28/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

class MasterListCell: UITableViewCell {

	var plus: (() -> Void)? = nil

	
	@IBOutlet weak var plusButton: AddButton!
	@IBOutlet weak var textField: UITextField!
	@IBAction func addPressed(sender: UIButton) {
		if let plus = self.plus {
			plusButton.setNeedsDisplay()
			plus()
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
