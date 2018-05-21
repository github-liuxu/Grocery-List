//
//	Grocery List
//

import UIKit

class ShoppingViewController: ListViewController, AddItemViewControllerDelegate,SectionsViewControllerDelegate,MasterListViewControllerDelegate {
    
    var dataSource:[ListItem]?
    var selectIndexPath:NSIndexPath?
    
    var sections = [Section]()                // Data.
    
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

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.largeTitleDisplayMode = .always

//        loadData()
		tableView.reloadData()
		
		setTableViewBackground(text: "No Shopping")
	}

	override func viewWillDisappear(_ animated: Bool) {
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

		// get item from data model
		let item = sections[indexPath.section].groceryItem[indexPath.row]
		let attributeString = NSMutableAttributedString(string: item.name)
		attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        let countString = NSMutableAttributedString(string: String(item.count))
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        let amountString = NSMutableAttributedString(string: String(item.price*item.count))
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))

		// setup text, format, and color
		if item.isInCart {
			cell.textField.textColor = UIColor.gray
			cell.textField.attributedText = attributeString
            cell.counTextField.textColor = UIColor.gray
            cell.counTextField.attributedText = countString
            cell.totalAmount.textColor = UIColor.gray
            cell.totalAmount.attributedText = amountString
		} else {
			cell.textField.textColor = UIColor.darkText
			cell.textField.attributedText = nil
			cell.textField?.text = item.name
            cell.counTextField.textColor = UIColor.darkText
            cell.counTextField.attributedText = nil
            cell.counTextField?.text = String(item.count)
            cell.totalAmount.textColor = UIColor.darkText
            cell.totalAmount.attributedText = nil
            cell.totalAmount.text = String(item.price*item.count)
		}
		cell.checkBox.isChecked = item.isInCart
		cell.checkBox.setNeedsDisplay()
		
		// Action for checkbox tapped
		cell.check = {
			item.isInCart = !item.isInCart
			cell.checkBox.isChecked = item.isInCart
			if item.isInCart {
				cell.textField.textColor = UIColor.gray
				cell.textField.attributedText = attributeString
                cell.counTextField.textColor = UIColor.gray
                cell.counTextField.attributedText = countString
                cell.totalAmount.textColor = UIColor.gray
                cell.totalAmount.attributedText = amountString
			} else {
				cell.textField.attributedText = nil
				cell.textField.textColor = UIColor.darkText
				cell.textField.text = item.name
                cell.counTextField.attributedText = nil
                cell.counTextField.textColor = UIColor.darkText
                cell.counTextField?.text = String(item.count)
                cell.totalAmount.attributedText = nil
                cell.totalAmount.textColor = UIColor.darkText
                cell.totalAmount.text = String(item.price*item.count)
			}
			cell.setNeedsDisplay()
			print("\(item.isInCart)")
			self.saveData()
		}
        return cell
    }

	
	@objc func deletePressed() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Clear All", style: .destructive, handler: { alert -> Void in self.deleteAll() }))
		alert.addAction(UIAlertAction(title: "Clear Selected", style: .destructive, handler: { alert -> Void in self.deleteSelected() }))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {alert -> Void in }))
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

	override func textFieldDidBeginEditing(_ textField: UITextField) {
		super.textFieldDidBeginEditing(textField)

		// disable checkbox
//		let location = textField.convert(textField.bounds.origin, to: self.tableView)
//		let indexPath = tableView.indexPathForRow(at: location)
		let cell = tableView.cellForRow(at: textFieldIndexPath) as! ShoppingItemCell
		cell.checkBox.isEnabled = false
		
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		let location = textField.convert(textField.bounds.origin, to: self.tableView)
		let indexPath = self.tableView.indexPathForRow(at: location)

		// Store the text
		let trimmedString = textField.text!.trimmingCharacters(in: .whitespaces)
		sections[(indexPath?.section)!].groceryItem[(indexPath?.row)!].name = trimmedString
		tableView.reloadData()
		saveData()
		
		// enable checkbox
		let cell = tableView.cellForRow(at: indexPath!) as! ShoppingItemCell
		cell.checkBox.isEnabled = true
		isEditingTextField = false

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
	
}
