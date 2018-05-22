//
//	Grocery List
//

import UIKit

class ShoppingViewController: ListViewController, AddItemViewControllerDelegate,SectionsViewControllerDelegate,MasterListViewControllerDelegate,ShoppingItemCellDelegate {
    
    var dataSource:[ListItem]?
    var selectIndexPath:NSIndexPath?
    
    var sections = [Section]()                // Data.
    var shoppingLabel = UILabel()
    var addItemLabel = UILabel()
    var currentTextField = UITextField()
    
    
	// MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let listItem = dataSource![selectIndexPath!.row] as ListItem
        sections = listItem.grocery

		title = "Shopping List"
		// Set Up Navigation Bar
        navigationController?.toolbar.isHidden = false;
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: TITLE_COLOR]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: TITLE_COLOR]
		navigationController?.navigationBar.tintColor = TITLE_COLOR
		navigationController?.navigationBar.barTintColor = NAV_BKG
		
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = true

		// Set Up Navigation Items
		navigationItem.largeTitleDisplayMode = .always
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Saved Items",
		                                                    style: .plain,
		                                                    target: self,
		                                                    action: #selector(gotoSavedItems))

		// Set Up Toolbar
		navigationController?.toolbar.tintColor = TOOLBAR_ITEM_COLOR
		toolbarItems = addToolbarItems()
        let w = UIScreen.main.bounds.size.width
        let h = UIScreen.main.bounds.size.height
        
        if CGSize(width: 1125, height: 2436) == UIScreen.main.currentMode?.size {
            addItemLabel = UILabel(frame: CGRect(x: 0, y: Int(h-86-43), width: Int(w/2), height: 43))
            addItemLabel.textAlignment = .left
            addItemLabel.backgroundColor = UIColor.white;
            
            shoppingLabel = UILabel(frame: CGRect(x: Int(w/2), y: Int(h-86-43), width: Int(w/2), height: 43))
            shoppingLabel.textAlignment = .right
            shoppingLabel.backgroundColor = UIColor.white;
        } else {
            addItemLabel = UILabel(frame: CGRect(x: 0, y: Int(h-86), width: Int(w/2), height: 43))
            addItemLabel.textAlignment = .left
            addItemLabel.backgroundColor = UIColor.white;
            
            shoppingLabel = UILabel(frame: CGRect(x: Int(w/2), y: Int(h-86), width: Int(w/2), height: 43))
            shoppingLabel.textAlignment = .right
            shoppingLabel.backgroundColor = UIColor.white;
        }
        
        
        addItemLabel.text = "Unchecked:0"
        shoppingLabel.text = "Checked:0"
        let keyWindow = UIApplication.shared.windows.first!
        keyWindow.addSubview(addItemLabel)
        keyWindow.addSubview(shoppingLabel)
        tableView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        tableView.addGestureRecognizer(tap)
        
	}
    
    @objc func tapClick() {
        currentTextField.resignFirstResponder()
        
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always
        
        addItemLabel.isHidden = false
        shoppingLabel.isHidden = false
        loadLabelData()
		tableView.reloadData()
		
		setTableViewBackground(text: "No Shopping")
	}

	override func viewWillDisappear(_ animated: Bool) {
        addItemLabel.isHidden = true
        shoppingLabel.isHidden = true
		saveData()
	}

	func addToolbarItems() -> [UIBarButtonItem] {
		
		// Set up Toolbar Buttons
		var items = [UIBarButtonItem]()
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePressed))
		let sectionsButtonItem = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(self.aislesPressed))
		
		items.append(deleteButton)
		items.append(flexSpace)
		items.append(sectionsButtonItem)
		items.append(flexSpace)
		items.append(addButton)
		
		return items
	}

    // MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
	
	// Custom Header View
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
		let label = UILabel(frame: CGRect(x: 16, y: 20, width: tableView.frame.size.width, height: 44))
		label.font = UIFont.boldSystemFont(ofSize: 15.0)
		label.textColor = HEADER_COLOR
		if sections[section].groceryItem.isEmpty {
			label.text = nil
		} else {
			label.text = sections[section].name
		}
		view.addSubview(label)
		view.backgroundColor = UIColor.groupTableViewBackground
		
		return view
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if sections[section].groceryItem.isEmpty {
			return nil
		}
		return "\(sections[section].name)"
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].groceryItem.count
    }
    
    // Hide header unless section has items
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sections[section].groceryItem.isEmpty { return CGFloat.leastNormalMagnitude }
        return 64
    }
    
    // Hide footer
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

	//
	// Cell for row at ...
	//
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: indexPath) as! ShoppingItemCell
        cell.delegate = self
        cell.indexPath = indexPath
		// get item from data model
		let item = sections[indexPath.section].groceryItem[indexPath.row]
        
		let attributeString = NSMutableAttributedString(string: item.name)
		attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        
        let countString = NSMutableAttributedString(string: String(item.count))
        countString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, countString.length))
        
        let amountString = NSMutableAttributedString(string: String(item.price))
        amountString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, amountString.length))

		// setup text, format, and color
        if item.isInCart {
            cell.nametextField.textColor = UIColor.gray
            cell.nametextField.attributedText = attributeString
            
            cell.counTextField.textColor = UIColor.gray
            cell.counTextField.attributedText = countString
            
            cell.totalAmount.textColor = UIColor.gray
            cell.totalAmount.attributedText = amountString
        } else {
            cell.nametextField.textColor = UIColor.darkText
            cell.nametextField.attributedText = nil
            cell.nametextField?.text = item.name
            
            cell.counTextField.textColor = UIColor.darkText
            cell.counTextField.attributedText = nil
            cell.counTextField?.text = String(item.count)
            
            cell.totalAmount.textColor = UIColor.darkText
            cell.totalAmount.attributedText = nil
            cell.totalAmount.text = String(item.price)
        }
		cell.checkBox.isChecked = item.isInCart
		cell.checkBox.setNeedsDisplay()
		
		// Action for checkbox tapped
		cell.check = {
			item.isInCart = !cell.checkBox.isChecked
			cell.checkBox.isChecked = item.isInCart
			if item.isInCart {
				cell.nametextField.textColor = UIColor.gray
				cell.nametextField.attributedText = attributeString
                cell.counTextField.textColor = UIColor.gray
                cell.counTextField.attributedText = countString
                cell.totalAmount.textColor = UIColor.gray
                cell.totalAmount.attributedText = amountString
			} else {
				cell.nametextField.attributedText = nil
				cell.nametextField.textColor = UIColor.darkText
				cell.nametextField.text = item.name
                cell.counTextField.attributedText = nil
                cell.counTextField.textColor = UIColor.darkText
                cell.counTextField.text = String(item.count)
                cell.totalAmount.attributedText = nil
                cell.totalAmount.textColor = UIColor.darkText
                cell.totalAmount.text = String(item.price)
			}
			cell.setNeedsDisplay()
			print("\(item.isInCart)")
			self.saveData()
		}
        return cell
    }

	
	@objc func deletePressed() {
        addItemLabel.isHidden = true
        shoppingLabel.isHidden = true
        
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Clear All", style: .destructive, handler: { alert -> Void in
            self.deleteAll()
            self.addItemLabel.isHidden = false
            self.shoppingLabel.isHidden = false
        }))
		alert.addAction(UIAlertAction(title: "Clear Selected", style: .destructive, handler: { alert -> Void in
            self.deleteSelected()
            self.addItemLabel.isHidden = false
            self.shoppingLabel.isHidden = false
        }))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {alert -> Void in
            self.addItemLabel.isHidden = false
            self.shoppingLabel.isHidden = false
        }))
		present(alert, animated: true, completion: nil)
	}
	

	func deleteSelected() {

		var indicesOfSelected: [IndexPath] = []
		var newItems: [Item] = []

		for i in sections.indices {
			newItems.removeAll()
			for j in sections[i].groceryItem.indices {
				if sections[i].groceryItem[j].isInCart {
					indicesOfSelected.append(IndexPath(row: j, section: i))
				} else {
					let item = sections[i].groceryItem[j]
					newItems.append(item)
				}
			}
			sections[i].groceryItem.removeAll()
			sections[i].groceryItem = newItems
		}
		saveData()
		tableView.performBatchUpdates({	tableView.deleteRows(at: indicesOfSelected, with: .right) }, completion: { finished in self.tableView.reloadData() })
		setTableViewBackground(text: "No Shopping")
		isEditing = false
	}
	
	func deleteAll() {
		//var indices = [IndexPath]()
		for i in sections.indices {
			sections[i].groceryItem.removeAll()
		}
		saveData()
		UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
		setTableViewBackground(text: "No Shopping")
		isEditing = false
	}

	//Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
		
		if editingStyle == .delete {
            // Delete the row from the data source
			sections[indexPath.section].groceryItem.remove(at: indexPath.row)
			saveData()
			// Delete from the table
			tableView.performBatchUpdates({	tableView.deleteRows(at: [indexPath], with: .automatic)}, completion: { finished in tableView.reloadData() })
			setTableViewBackground(text: "No Shopping")
		}
    }

	// Override to support rearranging the table view.
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let itemToMove = sections[fromIndexPath.section].groceryItem[fromIndexPath.row]
		sections[fromIndexPath.section].groceryItem.remove(at: fromIndexPath.row)
		sections[to.section].groceryItem.insert(itemToMove, at: to.row)
		saveData()
	}

	//
    // MARK: - Navigation
	//
	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "AddItem" {
			let navigation = segue.destination as! UINavigationController
			var addItemVC = AddItemViewController()
			addItemVC = navigation.viewControllers[0] as! AddItemViewController
			addItemVC.setGL = true	// default: add to Grocery List
			addItemVC.setML = false
			addItemVC.sections = sections
			addItemVC.delegate = self
        } else if segue.identifier == "AddCatagory_ShoppingVC" {
            let navigation = segue.destination as! UINavigationController
            var sectionsVC = CategoryViewController()
            sectionsVC = navigation.viewControllers[0] as! CategoryViewController
            sectionsVC.sections = sections
            sectionsVC.delegate = self
        } else if segue.identifier == "SavedItemsSegue" {
            let savedItemsVC = segue.destination as! MasterListViewController
            savedItemsVC.sections = sections;
            savedItemsVC.delegate = self;
        }
		
	}
	
	@objc func addPressed() {
		if sections.isEmpty {
			
			let alert = UIAlertController(title: "Whoops!", message: "There are no aisles to put an item in. Press OK to create one.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
				self.performSegue(withIdentifier: "AddSection_ShoppingVC", sender: nil)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)

			
		} else {
			performSegue(withIdentifier: "AddItem", sender: nil)
		}
	}
	
	@objc func aislesPressed() {
		performSegue(withIdentifier: "AddCatagory_ShoppingVC", sender: nil)
	}
	
	@objc func gotoSavedItems() {
		performSegue(withIdentifier: "SavedItemsSegue", sender: nil)
	}

    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }

	//
	// MARK: - Add Item Delegate Methods
	//
	
	func didAddItem(_ controller: AddItemViewController, didAddItem item: [Section]) {
		sections = item
        let list = dataSource![(selectIndexPath?.row)!]
        list.grocery = sections
		saveData()
		tableView.reloadData()

	}

	// MARK: - Text Field Stuff

//    override func textFieldDidBeginEditing(_ textField: UITextField) {
//        super.textFieldDidBeginEditing(textField)
//        currentTextField = textField
//        // disable checkbox
////        let location = textField.convert(textField.bounds.origin, to: self.tableView)
////        let indexPath = tableView.indexPathForRow(at: location)
//        let cell = tableView.cellForRow(at: textFieldIndexPath) as! ShoppingItemCell
//        cell.checkBox.isEnabled = false
//
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        let location = textField.convert(textField.bounds.origin, to: self.tableView)
//        let indexPath = self.tableView.indexPathForRow(at: location)
//
//        // enable checkbox
//        let cell = tableView.cellForRow(at: indexPath!) as! ShoppingItemCell
//        cell.checkBox.isEnabled = true
//        isEditingTextField = false
//
//        // Store the text
//        if textField == cell.textField {
//            let trimmedString = textField.text!.trimmingCharacters(in: .whitespaces)
//            sections[(indexPath?.section)!].groceryItem[(indexPath?.row)!].name = trimmedString
//            tableView.reloadData()
//            saveData()
//        } else if textField == cell.counTextField {
//            let trimmedString = Int(currentTextField.text!)
//            sections[(indexPath?.section)!].groceryItem[(indexPath?.row)!].count = trimmedString!
//            tableView.reloadData()
//            saveData()
//        } else if textField == cell.totalAmount {
//            let trimmedString = Int(cell.totalAmount.text!)
//            sections[(indexPath?.section)!].groceryItem[(indexPath?.row)!].price = Int(trimmedString!)
//            tableView.reloadData()
//            saveData()
//        }
//
//    }
    
    func nameChanged(name: String, indexPath: IndexPath, textField: UITextField) {
        currentTextField = textField
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        sections[indexPath.section].groceryItem[indexPath.row].name = trimmedString
        tableView.reloadData()
        saveData()
    }
    
    func countChanged(count: String, indexPath: IndexPath, textField: UITextField) {
        currentTextField = textField
        let trimmedString = Int(count)
        sections[indexPath.section].groceryItem[indexPath.row].count = trimmedString!
        tableView.reloadData()
        saveData()
        loadLabelData()
    }
    
    func priceChanged(price: String, indexPath: IndexPath, textField: UITextField) {
        currentTextField = textField
        let trimmedString = Int(price)
        sections[(indexPath.section)].groceryItem[(indexPath.row)].price = trimmedString!
        tableView.reloadData()
        saveData()
        loadLabelData()
    }

	@objc func textFieldDoneButton(_ sender: UIBarButtonItem) {
		
	}
	
	func setupDoneButton() {
		if isEditingTextField {
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.textFieldDoneButton(_:)))
		} else {
			navigationItem.leftBarButtonItem = editButtonItem
		}
	}

	// MARK: - Other Stuff
	
	func setTableViewBackground(text: String) {
		
		var hasItems = false
		
		// check if list has items
		for i in sections.indices {
			if sections[i].groceryItem.isEmpty {
				hasItems = false
			} else {
				hasItems = true
				break
			}
		}
		
		// set appropriate background
		if hasItems == false {
			tableView.backgroundView = setupEmptyView(text: text)
		} else {
			tableView.backgroundView = nil
		}
		
	}
    //MARK:SectionsViewControllerDelegate
    func addSectionCallback(addSections:[Section]) {
        sections = addSections
        let list = dataSource![(selectIndexPath?.row)!]
        list.grocery = sections
        saveData()
        tableView.reloadData()
    }
    // MARK: MasterListViewControllerDelegate
    func saveSections(sections:[Section]) {
        self.sections = sections
        let list = dataSource![(selectIndexPath?.row)!]
        list.grocery = sections
        saveData()
        tableView.reloadData()
    }
    
    // MARK: - Data
    
    override func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func fileURL() -> URL {
        return documentsDirectory().appendingPathComponent("list.plist")
    }
    
    override func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(dataSource)
            try data.write(to: fileURL(), options: .atomic)
        } catch {
            print("Error encoding item array")
        }
    }
    
    func loadLabelData() {
        // 1
        let path = fileURL()
        // 2
        if let data = try? Data(contentsOf: path) {
            // 3
            let decoder = PropertyListDecoder()
            do {
                // 4
                let dateSourceTemp = try decoder.decode([ListItem].self, from: data)
                for listItem in dateSourceTemp {
                    var moneyShopping = 0
                    for section in listItem.grocery {
                        for item in section.groceryItem {
                            moneyShopping += item.price*item.count
                        }
                    }
                    shoppingLabel.text = "Checked:"+String(moneyShopping)
                    var moneyItem = 0
                    for section in listItem.grocery {
                        for item in section.masterListItem {
                            moneyItem += item.price*item.count
                        }
                    }
                    addItemLabel.text = "Unchecked:"+String(moneyItem)
                }
            } catch {
                print("Error decoding item array")
            }
        } }
	
}
