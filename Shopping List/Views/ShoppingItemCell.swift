//
//  ShoppingItemCell.swift
//  Shopping List
//
//  Created by Thomas Foster on 9/27/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit


class ShoppingItemCell: UITableViewCell {

	var check: (() -> Void)? = nil
	
	
	@IBOutlet weak var checkBox: CheckBox!
	@IBOutlet weak var textField: UITextField!

    @IBOutlet weak var counTextField: UITextField!
    
    @IBOutlet weak var totalAmount: UITextField!
    @IBAction func checkPressed(sender: UIButton) {
		if let check = self.check {
			checkBox.setNeedsDisplay()
			check()
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
