//
//  AddListViewController.swift
//  Grocery List
//
//  Created by 刘东旭 on 2018/5/19.
//  Copyright © 2018年 Thomas Foster. All rights reserved.
//

import UIKit
import Foundation

class AddListViewController: UITableViewController {
    
    weak var delegate:MainViewController?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    var datePicker:UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "add list"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: TITLE_COLOR]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: TITLE_COLOR]
        navigationController?.navigationBar.tintColor = TITLE_COLOR
        navigationController?.navigationBar.barTintColor = NAV_BKG
        
        let cancelButtonItem = UIBarButtonItem(title: "Cancel",
                                             style: .plain,
                                            target: self,
                                            action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButtonItem
        
        let doneButtonItem = UIBarButtonItem(title: "Done",
                                             style: .plain,
                                             target: self,
                                             action: #selector(done))
        navigationItem.rightBarButtonItem = doneButtonItem
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: view.frame.height-250, width: view.frame.width, height: 250))
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged),
                             for: .valueChanged)
        view.addSubview(datePicker)
        datePicker.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dateClick))
        dateLabel.addGestureRecognizer(tap)
        
        nameTextField.delegate = self as? UITextFieldDelegate
        moneyTextField.delegate = self as? UITextFieldDelegate
        
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyBored)))
    }
    
    @objc func dateClick() {
        datePicker.isHidden = false
        nameTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
        dateChanged(datePicker: datePicker)
    }
    
    @objc func closeKeyBored () {
        datePicker.isHidden = true
        nameTextField.resignFirstResponder()
        moneyTextField.resignFirstResponder()
    }
    
    @objc func dateChanged(datePicker : UIDatePicker){
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy/MM/dd"
        dateTextField.text = formatter.string(from: datePicker.date)
    }
    
    // Hide footer
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 64
        }
        return CGFloat.leastNormalMagnitude
    }
    
    @objc func cancel () {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func done () {
        if delegate != nil {
            if (nameTextField.text!.isEmpty || dateTextField.text!.isEmpty || moneyTextField.text!.isEmpty) {
                //alert
                let alert = UIAlertController(title: "Tip!", message: "Please fill in all the items.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let item = ListItem()
                item.name = nameTextField.text!
                item.date = dateTextField.text!
                item.money = "$" + moneyTextField.text!
                
                let produceSection = Section()
                produceSection.name = "Produce Section"
                
                item.grocery = [produceSection]
                delegate?.addListCallBack(item: item)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
}
