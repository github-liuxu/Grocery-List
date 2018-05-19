import UIKit

//
// Superclass of Grocery List VC, Saved Items List VC, Sections VC
//
class ListViewController: UITableViewController {

    var sectionsData = [Section]()                // Data.
	var savedText: String?					// Used for restoring text after tap outside textField
	var textFieldIndexPath = IndexPath()	// Location of text field being edited
	var isEditingTextField = false
	var didReorder: Bool = false
//    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//        target: self,
//        action: #selector(dismissKeyboard))

	// MARK: - View Controller Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
//        view.addGestureRecognizer(tap)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
		isEditing = false
	}

	// Background text if list is empty, eg "No Groceries"
	func setupEmptyView(text: String) -> UIView {
		let emptyView = UIView()
		let label = UILabel()
		emptyView.frame = tableView.frame
		emptyView.backgroundColor = UIColor.groupTableViewBackground
		label.frame = CGRect.zero
		label.text = text
		label.font = UIFont.boldSystemFont(ofSize: 36.0)
		label.textColor = UIColor.lightGray
		//		label.shadowColor = UIColor.lightGray
		//		label.shadowOffset = CGSize(width: 1.0, height: 1.0)
		label.sizeToFit()
		label.center = emptyView.center
		emptyView.addSubview(label)
		return emptyView
	}
	

	// MARK: - Table view data source
	
	// make rows not selectable
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}
	
	// Enable row moving
	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
	}

	// MARK: - Data
	
	func documentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	func fileURL() -> URL {
		return documentsDirectory().appendingPathComponent("sections.plist")
	}
	
	func saveData() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(sections)
//            try data.write(to: fileURL(), options: .atomic)
//        } catch {
//            print("Error encoding item array")
//        }
        NotificationCenter.default.post(name: NSNotification.Name.init("GroceryNeedSaveData"), object: nil)
	}
	
    func loadData() {
        // 1
        let path = fileURL()
        // 2
        if let data = try? Data(contentsOf: path) {
            // 3
            let decoder = PropertyListDecoder()
            do {
                // 4
                sectionsData = try decoder.decode([Section].self, from: data)
            } catch {
                print("Error decoding item array")
            }
        }
    }
	
	
	
	// MARK: - Editing
//	override func setEditing(_ editing: Bool, animated: Bool) {
//		super.setEditing(editing, animated: animated)
//
//		if isEditing {
//			view.removeGestureRecognizer(tap)
//		} else {
//			view.addGestureRecognizer(tap)
//		}
//
//	}

	@objc func dismissKeyboard() {
		if isEditingTextField {
			if let cell = tableView.cellForRow(at: textFieldIndexPath) as? GroceryItemCell {
				if let text = savedText {
					if cell.textField.text == "" {
						cell.textField.text = text //	User clicked away from textField but it's empty, restore original text
					}
				}
			} else if let masterListCell = tableView.cellForRow(at: textFieldIndexPath) as? MasterListCell {
				if let text = savedText {
					if masterListCell.textField.text == "" {
						masterListCell.textField.text = text
					}
				}
			} else {
				let sectionsCell = tableView.cellForRow(at: textFieldIndexPath) as! SectionsCell
				if let text = savedText {
					if sectionsCell.textField.text == "" {
						sectionsCell.textField.text = text
					}
				}
			}
			view.endEditing(true)
			isEditingTextField = false
			savedText = nil
		}
	}

}

//
// Handle in-cell editing
//

extension ListViewController: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		isEditingTextField = true
		savedText = textField.text!
		let location = textField.convert(textField.bounds.origin, to: tableView)
		textFieldIndexPath = self.tableView.indexPathForRow(at: location)!
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		isEditingTextField = false
		savedText = nil
		textField.resignFirstResponder()
		return true
	}

}
