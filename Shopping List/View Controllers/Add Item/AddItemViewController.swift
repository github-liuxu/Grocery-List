import UIKit

protocol AddItemViewControllerDelegate: class {
//    func didAddItem(_ controller: AddItemViewController, didAddItem item: [Section])
    
    func didAddSection(_ controller: AddItemViewController, didAddSection section: Section)
    
    func didAddSectionInOtherList(_ controller: AddItemViewController, didAddSection section: Section)
}

/**

**********************
View where you add an item
**********************

Segue'd from
1) Grocery List (GL) or
2) Master List (ML) aka Saved Items

Segue to
1) Section List

*/

class AddItemViewController: UITableViewController, UITextFieldDelegate {

	var sections: [Section] = []
    var dataSource = [Section]()
	var delegate: AddItemViewControllerDelegate?
	
	var setGL: Bool = false		// set by the delegate upon segue
	var setML: Bool = true		// "	"
    var fromMaster: Bool = false
    

	// MARK: - Interface Builder
	
	@IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
	@IBOutlet weak var sectionCell: UITableViewCell!
	@IBOutlet weak var aisleTextLabel: UILabel!
    
    var newText = "";
    var countNewText = "";
    var priceNewText = "";
		
	// Switches
	
	@IBOutlet weak var grocerySwitch: UISwitch!
	@IBOutlet weak var masterListSwitch: UISwitch!
	
	@IBAction func grocerySwitchPressed(_ sender: Any) {
//        if !masterListSwitch.isOn {
//            masterListSwitch.setOn(!masterListSwitch.isOn, animated: true)
//        }
	}
	
	@IBAction func masterListSwitchPressed(_ sender: Any) {
//        if !grocerySwitch.isOn {
//            grocerySwitch.setOn(grocerySwitch.isOn, animated: true)
//        }
	}
	
	@IBAction func defaultsPressed(_ sender: Any) {
		sections.removeAll()
		sections = testData()
//        delegate?.didAddItem(self, didAddItem: sections)
		self.dismiss(animated: true, completion: nil)
	}

	// MARK: - Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set up navigation bar
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		navigationController?.navigationBar.tintColor = TITLE_COLOR
		navigationController?.navigationBar.barTintColor = NAV_BKG
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.isOpaque = true

		// set up switch states
		// if segue-ing from Grocery List (GL) is on, ML is off and vice versa
		grocerySwitch.isOn = setGL
		masterListSwitch.isOn = setML
        loadData()
	}
	
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		nameTextField.becomeFirstResponder()

		// select the first aisle if none is selected
		var foundSelected = false
		
		for index in sections.indices {
			if sections[index].isSelected {
				foundSelected = true
				break
			}
		}

		// Set the field to the first aisle if none selected.
		if foundSelected == false {
			sections[0].isSelected = true
			aisleTextLabel.text = sections[0].name
		} else {
			for index in sections.indices {
				if sections[index].isSelected {
					aisleTextLabel.text = sections[index].name
					break
				}
			}
		}
		
	}

	override func viewWillDisappear(_ animated: Bool) {
		view.endEditing(true)
	}

	// MARK: - Buttons
	
	@IBAction func done() {
		
		let trimmedString = nameTextField.text!.trimmingCharacters(in: .whitespaces)
		let addedItem = Item(name: trimmedString)
        addedItem.count = (Int)(countNewText)!
        addedItem.price = (Int)(priceNewText)!
        addedItem.isOnGroceryList = true
        let sectionName = aisleTextLabel.text
        
        if grocerySwitch.isOn {
            let s = Section()
            s.name = sectionName!
            s.groceryItem = [addedItem]
            if fromMaster {
                delegate?.didAddSectionInOtherList(self, didAddSection: s)
            } else {
                delegate?.didAddSection(self, didAddSection: s)
            }
            
        }
        
        if masterListSwitch.isOn {
            let s = Section()
            s.name = sectionName!
            s.groceryItem = [addedItem]
            if fromMaster {
                delegate?.didAddSection(self, didAddSection: s)
            } else {
                delegate?.didAddSectionInOtherList(self, didAddSection: s)
            }
        }
        
//        addedItem.isOnGroceryList = setGL
		// Add Item to data model
        
//        for i in sections.indices {
//            if sections[i].isSelected {
//                if grocerySwitch.isOn {
//                    sections[i].groceryItem.append(addedItem)
//                }
//                if masterListSwitch.isOn {
//                    sections[i].masterListItem.append(addedItem)
//                    //dataSource is have section
//                    let haveName = haveSectionName(name: sections[i].name)
//                    if haveName.0 {
//                        let sec = haveName.1
//                        sec.masterListItem.append(addedItem)
//                        //save
////                        saveData()
//                        let s = Section()
//                        s.name = sections[i].name
//                        s.groceryItem = [addedItem]
//
//                        delegate?.didAddSection(self, didAddSection: s)
//                    } else {
//                        let sec = haveName.1
//                        sec.name = sections[i].name
//                        sec.masterListItem = [addedItem]
//                        //save
////                        saveData()
//                        delegate?.didAddSection(self, didAddSection: sections[i])
//                    }
//                }
//            }
//        }
//        delegate?.didAddItem(self, didAddItem: sections)
		self.dismiss(animated: true, completion: nil)
	}
    
//    func haveSectionName(name:String) -> (Bool,Section) {
//        for section in dataSource {
//            if section.name == name {
//                return (true, section)
//            }
//        }
//        return (false, Section())
//    }
	
	@IBAction func cancel() {
		self.dismiss(animated: true, completion: nil)
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		if Constants.isTesting { return 4 }		//adds row with "restore defaults" button, for testing
		else { return 3 }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 2 { return 2 }	// lists sections
		else { return 1 }				// name & aisle sections
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if segue.identifier == "SectionListSegue" {
			let sectionListVC = segue.destination as! SectionsListViewController
			sectionListVC.sections = self.sections
		}
	}
	

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func fileURL() -> URL {
        return documentsDirectory().appendingPathComponent("savelist.plist")
    }
    
    func saveData() {
        
        let encoder = PropertyListEncoder()
        let data = try! encoder.encode(dataSource)
        try! data.write(to: fileURL(), options: .atomic)
    }
    
    func loadData() {
        // 1
        let path = fileURL()
        // 2
        if let data = try? Data(contentsOf: path) {
            // 3
            let decoder = PropertyListDecoder()
            dataSource = try! decoder.decode([Section].self, from: data)
        }
    }
	
	
	
	// MARK: - Text Field Delegate Methods

	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameTextField {
            let oldText = nameTextField.text!
            let stringRange = Range(range, in: oldText)!
            newText = oldText.replacingCharacters(in: stringRange, with: string)
        }
		
        if textField == countTextField {
            let countOldText = countTextField.text!
            let countStringRange = Range(range, in: countOldText)!
            countNewText = countOldText.replacingCharacters(in: countStringRange, with: string)
        }
        
        if textField == priceTextField {
            let oldText = priceTextField.text!
            let stringRange = Range(range, in: oldText)!
            priceNewText = oldText.replacingCharacters(in: stringRange, with: string)
        }
        
        if !newText.isEmpty && !countNewText.isEmpty && !priceNewText.isEmpty {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
		
		return true
	}


}
