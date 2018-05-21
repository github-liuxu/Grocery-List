/**

AKA Saved Items List in app
Segue'd from Grocery List

*/

import UIKit

protocol MasterListViewControllerDelegate: class {
    func saveSections(sections:[Section])
}

class MasterListViewController: ListViewController, AddItemViewControllerDelegate, SectionsViewControllerDelegate {
	
    weak var delegate: MasterListViewControllerDelegate?
	var sections = [Section]()                // Data.
	var currentTextField = UITextField()
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Saved Items"
		
		// set up navigation bar
		navigationController?.navigationBar.prefersLargeTitles = false
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = editButtonItem
		
		// set up toolbar
		toolbarItems = addToolbarItems()
		
		tableView.estimatedRowHeight = 44.0
		tableView.rowHeight = UITableViewAutomaticDimension
		
		tableView.register(CollapsibleTableViewHeader.nib, forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.identifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<Shopping List",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(back))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        tableView.addGestureRecognizer(tap)
	}
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tapClick() {
        currentTextField.resignFirstResponder()
        
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//        loadData()
		tableView.reloadData()
		setTableViewBackground(text: "No Items")
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		saveData()
	}
	
	func addToolbarItems() -> [UIBarButtonItem] {
		
		// Set up Toolbar
		var items = [UIBarButtonItem]()
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		let sectionsButtonItem = UIBarButtonItem(title: "Edit Aisles", style: .plain, target: self, action: #selector(self.aislesPressed))
		let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePressed))
		
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
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return sections[section].isCollapsed ? 0 : sections[section].masterListItem.count
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.identifier) as? CollapsibleTableViewHeader {
			header.aisle = sections[section]
			header.section = section
			header.button.closed = sections[section].isCollapsed
			header.delegate = self

			return header
		}
		return UIView()
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 44
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("begin cellforrowat")
		let cell = tableView.dequeueReusableCell(withIdentifier: "MasterListCell", for: indexPath) as! MasterListCell
		let item = sections[indexPath.section].masterListItem[indexPath.row]
		var index: Int = 0
		cell.textField.text = item.name
        cell.count.text = String(item.count)
        cell.price.text = String(item.price)
		item.isOnGroceryList = false
		
		
		for i in sections[indexPath.section].groceryItem.indices {
			if item.name == sections[indexPath.section].groceryItem[i].name {
				index = i
				item.isOnGroceryList = true
				print("for loop 1")
				break
			} else {
				item.isOnGroceryList = false
				print("for loop 2")
			}
		}
		
		cell.plusButton.showPlus = !item.isOnGroceryList
		cell.plusButton.setNeedsDisplay()
		
		cell.plus = {
			if item.isOnGroceryList == false {
				item.isOnGroceryList = true
				self.sections[indexPath.section].groceryItem.append(item)
				print("added item: item.isOnGroceryList = \(item.isOnGroceryList)")
			} else {
				item.isOnGroceryList = false
				for i in self.sections[indexPath.section].groceryItem.indices {
					if item.name == self.sections[indexPath.section].groceryItem[i].name {
						index = i
					}
				}
				self.sections[indexPath.section].groceryItem.remove(at: index)
				
			}
			cell.plusButton.showPlus = !item.isOnGroceryList
			self.saveData()
			print("\(item.isOnGroceryList)")
		}
		
		return cell
	}
	
	
	
	//
	// Editing
	//
	
	
	// Handle Deleting Rows
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			sections[indexPath.section].masterListItem.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			saveData()
			setTableViewBackground(text: "No Items")
			
		}
	}
	
	// Handle Reordering Rows
	override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let itemToMove = sections[fromIndexPath.section].masterListItem[fromIndexPath.row]
		
		sections[fromIndexPath.section].masterListItem.remove(at: fromIndexPath.row)
		sections[to.section].masterListItem.insert(itemToMove, at: to.row)
		saveData()
//		perform(#selector(reloadTable), with: self, afterDelay: 0.1)
	}
	
	
	@objc func reloadTable() {
		tableView.reloadData()
	}

	
	@objc func deletePressed() {
		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Delete All", style: .destructive, handler: { alert -> Void in self.deleteAll() }))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {alert -> Void in }))
		present(alert, animated: true, completion: nil)
	}
	
	func deleteAll() {
		//var indices = [IndexPath]()
		for i in sections.indices {
			sections[i].masterListItem.removeAll()
		}
		saveData()
		UIView.transition(with: tableView, duration: 0.35, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }, completion: nil)
		setTableViewBackground(text: "No Items")
		isEditing = false
	}

	//
	// MARK: - Navigation
	//
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "AddToMasterList" {
			let navigation = segue.destination as! UINavigationController
			let addVC = navigation.viewControllers[0] as! AddItemViewController
			addVC.setML = true
			addVC.setGL = false
			addVC.sections = sections
			addVC.delegate = self
        } else if segue.identifier == "AddSection" {
            let navigation = segue.destination as! UINavigationController
            var sectionsVC = CategoryViewController()
            sectionsVC = navigation.viewControllers[0] as! CategoryViewController
            sectionsVC.sections = sections
            sectionsVC.delegate = self
        }
	}
	
	@objc func addPressed() {
		
		if sections.isEmpty {
			let alert = UIAlertController(title: "Whoops!", message: "There are no aisles to put an item in. Press OK to create one.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
				self.performSegue(withIdentifier: "AddSection", sender: nil)
			}))
			alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
			self.present(alert, animated: true, completion: nil)
		} else {
			performSegue(withIdentifier: "AddToMasterList", sender: nil)
		}
	}
	
	@objc func aislesPressed() {
		performSegue(withIdentifier: "AddSection", sender: nil)
	}

	// MARK: - Add Item Delegate Methods
	
	
	func didAddItem(_ controller: AddItemViewController, didAddItem item: [Section]) {
		sections = item
		saveData()
		tableView.reloadData()
	}
    
    // MARK: - Edit Delegate
    func addSectionCallback(addSections:[Section]) {
        sections = addSections
        saveData()
        tableView.reloadData()
    }

    // MARK: - Text Field Stuff
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        currentTextField = textField
        
    }
	
	// MARK: - Text Field Stuff
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		let location = textField.convert(textField.bounds.origin, to: self.tableView)
		let textFieldIndexPath = self.tableView.indexPathForRow(at: location)
        
        // enable checkbox
        let cell = tableView.cellForRow(at: textFieldIndexPath!) as! MasterListCell
        isEditingTextField = false
        
        if textField == cell.textField {
            let trimmedString = textField.text!.trimmingCharacters(in: .whitespaces)
            sections[(textFieldIndexPath?.section)!].masterListItem[(textFieldIndexPath?.row)!].name = trimmedString
            tableView.reloadData()
            saveData()
            
        } else if textField == cell.count {
            let trimmedString = Int(currentTextField.text!)
            sections[(textFieldIndexPath?.section)!].masterListItem[(textFieldIndexPath?.row)!].count = trimmedString!
            tableView.reloadData()
            saveData()
        } else if textField == cell.price {
            let trimmedString = Int(cell.price.text!)
            sections[(textFieldIndexPath?.section)!].masterListItem[(textFieldIndexPath?.row)!].price = Int(trimmedString!)
            tableView.reloadData()
            saveData()
        }
	}

	func setTableViewBackground(text: String) {
		
		if sections.isEmpty {
			tableView.backgroundView = setupEmptyView(text: text)
		} else {
			tableView.backgroundView = nil
		}
		
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
        delegate?.saveSections(sections: sections)
    }
    
}




extension MasterListViewController: CollapsibleTableViewHeaderDelegate {
	
	func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {

		print ("togglesection")
		let isCollapsed = !sections[section].isCollapsed
		
		// Toggle collapse
		sections[section].isCollapsed = isCollapsed
		
		// reload whole section
		tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
	}
	
}

