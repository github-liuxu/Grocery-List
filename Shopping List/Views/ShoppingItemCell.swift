//
//  ShoppingItemCell.swift
//  Shopping List
//
//  Created by Thomas Foster on 9/27/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

protocol ShoppingItemCellDelegate :class {
    func nameChanged(name:String,indexPath:IndexPath,textField: UITextField)
    func countChanged(count:String,indexPath:IndexPath,textField: UITextField)
    func priceChanged(price:String,indexPath:IndexPath,textField: UITextField)
}

class ShoppingItemCell: UITableViewCell,UITextFieldDelegate {

	var check: (() -> Void)? = nil
	
	
	@IBOutlet weak var checkBox: CheckBox!
	@IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var counTextField: UITextField!
    @IBOutlet weak var totalAmount: UITextField!
    var indexPath = IndexPath()
    
    weak var delegate:ShoppingItemCellDelegate?
    @IBAction func checkPressed(sender: UIButton) {
		if let check = self.check {
            check()
            checkBox.setNeedsDisplay()
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nametextField.delegate = self
        counTextField.delegate = self
        totalAmount.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
		
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nametextField {
            delegate?.nameChanged(name: (textField.text?.trimmingCharacters(in: .whitespaces))!,indexPath: indexPath as IndexPath,textField: textField)
        } else if textField == counTextField {
            delegate?.countChanged(count: (textField.text?.trimmingCharacters(in: .whitespaces))!,indexPath: indexPath as IndexPath,textField: textField)
        } else if textField == totalAmount {
            delegate?.priceChanged(price: (textField.text?.trimmingCharacters(in: .whitespaces))!,indexPath: indexPath as IndexPath,textField: textField)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
