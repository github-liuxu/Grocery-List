
import UIKit

protocol ListItemCellDelegate :class {
    func nameChanged(name:String,indexPath:IndexPath)
    func dateChanged(date:String,indexPath:IndexPath)
}

class ListItemCell: UITableViewCell, UITextFieldDelegate {
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var money: UILabel!
    
    weak var delegate : ListItemCellDelegate?
    var indexParh = IndexPath()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameTextField.delegate = self
        dateTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            delegate?.nameChanged(name: (textField.text?.trimmingCharacters(in: .whitespaces))!,indexPath: indexParh as IndexPath)
        } else {
            delegate?.dateChanged(date: (textField.text?.trimmingCharacters(in: .whitespaces))!,indexPath: indexParh as IndexPath)
            
            
            
        }

    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
