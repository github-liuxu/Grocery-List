/**

List of aisles that appears when 'Edit Aisles' is pressed. Editable, reorderable

- Presented modally from either Grocery List or Saved Items List (Master List)
- Segues to: AddCategoryViewController

*/

import UIKit

protocol SectionsViewControllerDelegate: class {
    func addSectionCallback(addSections:[Section])
}

class CategoryViewController: ListViewController, AddSectionViewControllerDelegate {
    
    weak var delegate: SectionsViewControllerDelegate?
    var sections = [Section]()                // Data.
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Category List"
		
		// set up navigation bar
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		navigationController?.navigationBar.tintColor = TITLE_COLOR
		navigationController?.navigationBar.barTintColor = NAV_BKG
		navigationController?.navigationBar.isTranslucent = false
		navigationController?.navigationBar.isOpaque = true
		navigationController?.toolbar.tintColor = TOOLBAR_ITEM_COLOR
//		navigationController?.toolbar.barTintColor = BAR_BUTTON_COLOR

		// set up toolbar
		navigationItem.rightBarButtonItem = editButtonItem
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.donePressed))
		var items = [UIBarButtonItem]()
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		items.append(flexSpace)
		items.append(addButton)
		toolbarItems = items

    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//        loadData()
		tableView.reloadData()
		setTableViewBackground(text: "No Categorys")
	}

    // MARK: - Table view data source
	override func numberOfSections(in tableView: UITableView) -> Int {
        if sections.isEmpty { return 0 }
            
        else { return 1 }
	}
	
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionsID", for: indexPath) as! SectionsCell

		let section = sections[indexPath.row]
		cell.textField.text = section.name

        return cell
    }

	// MARK: - Table Editing
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		
		if isEditing {
			navigationItem.leftBarButtonItem = nil		// Hide real Done button since Edit button changes to 'Done' when editing
		} else {
			// Restore real Done button
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
			                                                   target: self,
			                                                   action: #selector(self.donePressed))
		}
		
	}
	
	// FIXME: It's fucked!!
    // Swipe to Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			if !sections[indexPath.row].groceryItem.isEmpty || !sections[indexPath.row].masterListItem.isEmpty {
				let alert = UIAlertController(title: "Warning", message: "This Category contains items. Are you sure you want to delete it?", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
					self.sections.remove(at: indexPath.row)
					tableView.performBatchUpdates({	tableView.deleteRows(at: [indexPath], with: .automatic)}, completion: { finished in tableView.reloadData() })
					self.saveData()
				}))
				alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
				setTableViewBackground(text: "No Category")
			} else {
				sections.remove(at: indexPath.row)
				tableView.performBatchUpdates({	tableView.deleteRows(at: [indexPath], with: .automatic)}, completion: { finished in tableView.reloadData() })
				saveData()
				setTableViewBackground(text: "No Category")
			}
        }
    }

    // Move Rows
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
		let itemToMove = sections[fromIndexPath.row]
		print("itemToMove.shoppingItem.count = \(itemToMove.groceryItem.count)")
		sections.remove(at: fromIndexPath.row)
		sections.insert(itemToMove, at: to.row)
		saveData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddCategory" {
			let addSectionVC = segue.destination as! AddCategoryViewController
			addSectionVC.delegate = self
		}
	}

	@objc func addPressed(sender: UIBarButtonItem) {
		performSegue(withIdentifier: "AddCategory", sender: nil)
	}

	@objc func donePressed(sender: UIBarButtonItem) {
		saveData()
		self.dismiss(animated: true, completion: nil)
        if (self.delegate != nil) {
            self.delegate?.addSectionCallback(addSections :sections)
        }
	}

	// MARK: - Add Section Delegate Methods
	
	// Cancel
	func AddSectionViewControllerDidCancel(_ controller: AddCategoryViewController) {
		navigationController?.popViewController(animated: true)
	}
	
	// Add a section
	func AddSectionViewController(_ controller: AddCategoryViewController, didFinishAdding section: Section) {
		sections.append(section)
		saveData()
		tableView.reloadData()
		navigationController?.popViewController(animated: true)
	}

	// MARK: - Text Field Delegate Methods
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		let location = textField.convert(textField.bounds.origin, to: self.tableView)
		let indexPath = self.tableView.indexPathForRow(at: location)
		
		let trimmedString = textField.text!.trimmingCharacters(in: .whitespaces)
		sections[(indexPath?.row)!].name = trimmedString
		tableView.reloadData()
		saveData()
		isEditingTextField = false
				
	}

	// MARK: - Other

	func setTableViewBackground(text: String) {
		
		if sections.isEmpty {
			tableView.backgroundView = setupEmptyView(text: text)
		} else {
			tableView.backgroundView = nil
		}
		
	}
    
    override func saveData() {
        NotificationCenter.default.post(name: NSNotification.Name.init("ShoppingNeedSaveData"), object: nil)
    }
}
