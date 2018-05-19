//
//  AddSectionViewController.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/25/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

protocol AddSectionViewControllerDelegate: class {
	func AddSectionViewControllerDidCancel(_ controller: AddSectionViewController)
	func AddSectionViewController(_ controller: AddSectionViewController, didFinishAdding section: Section)
}

class AddSectionViewController: UITableViewController, UITextFieldDelegate {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	
	weak var delegate: AddSectionViewControllerDelegate?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.largeTitleDisplayMode = .never
		title = "Add an Section"
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		textField.becomeFirstResponder()
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
	// make row not selectable
	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let oldText = textField.text!
		let stringRange = Range(range, in: oldText)!
		let newText = oldText.replacingCharacters(in: stringRange, with: string)

		doneButton.isEnabled = !newText.isEmpty
		return true
	}

	
	
	@IBAction func cancel() {
		delegate?.AddSectionViewControllerDidCancel(self)
	}
	
	@IBAction func done() {
		let section = Section()
		let trimmedString = textField.text!.trimmingCharacters(in: .whitespaces)
		section.name = trimmedString
		delegate?.AddSectionViewController(self, didFinishAdding: section)
	}


}
