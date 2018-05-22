
import UIKit

import Foundation

class MainViewController :UITableViewController ,ListItemCellDelegate{
    
    var dateSource = [ListItem]()
    var addButton = UIButton()
    
    var currentTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My List"
        
        print(documentsDirectory().appendingPathComponent("sections.plist"))
        
        // Set Up Navigation Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: TITLE_COLOR]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: TITLE_COLOR]
        navigationController?.navigationBar.tintColor = TITLE_COLOR
        navigationController?.navigationBar.barTintColor = NAV_BKG

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = true
        
        let keyWindow = UIApplication.shared.windows.first!
        addButton = UIButton(frame: CGRect(x: view.frame.size.width*3.0/4, y: view.frame.size.height*4.0/5, width: 60, height: 60))
        addButton.backgroundColor = Color.oldRed
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.setTitle("+", for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(addClick), for: UIControlEvents.touchUpInside)
        addButton.layer.cornerRadius = addButton.frame.size.width/2
        addButton.layer.masksToBounds = true
        keyWindow.addSubview(addButton)
        
        let notificationName = "ShoppingNeedSaveData"
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction), name: NSNotification.Name(rawValue: notificationName), object: nil)
    }
    
    @objc func notificationAction() {
        self.saveData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        addButton.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        addButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.toolbar.isHidden = true;
        loadData()
        self.tableView.reloadData()
    }
    
    @objc func addClick() {
        
        performSegue(withIdentifier: "AddListViewController", sender: nil)
        
    }
    
    // MARK: - Data
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func fileURL() -> URL {
        return documentsDirectory().appendingPathComponent("list.plist")
    }
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(dateSource)
            try data.write(to: fileURL(), options: .atomic)
        } catch {
            print("Error encoding item array")
        }
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
                dateSource = try decoder.decode([ListItem].self, from: data)
                for listItem in dateSource {
                    var money = 0
                    for section in listItem.grocery {
                        for item in section.groceryItem {
                            money += item.price*item.count
                        }
                    }
                    listItem.money = String(money)
                    
                }
            } catch {
                print("Error decoding item array")
            }
        } }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! ListItemCell
        
        let listItem = self.dateSource[indexPath.row]
        cell.delegate = self
        cell.indexParh = indexPath as IndexPath;
        cell.nameTextField.text = listItem.name
        cell.dateTextField.text = listItem.date
        cell.money.text = listItem.money
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShoppingViewController", sender: nil)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            dateSource.remove(at: indexPath.row)
            saveData()
            // Delete from the table
            tableView.performBatchUpdates({    tableView.deleteRows(at: [indexPath], with: .automatic)}, completion: { finished in tableView.reloadData() })
        }
    }
    
    func nameChanged(name:String,indexPath:IndexPath) {
        let listItem = dateSource[indexPath.row]
        listItem.name = name;
        tableView.reloadData()
        saveData()
    }
    
    func dateChanged(date:String,indexPath:IndexPath) {
        let listItem = dateSource[indexPath.row]
        listItem.date = date;
        tableView.reloadData()
        saveData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShoppingViewController" {
            if tableView.indexPathForSelectedRow != nil {
                let desController = segue.destination as! ShoppingViewController
                let indexPath = tableView.indexPathForSelectedRow
                desController.dataSource = dateSource
                desController.selectIndexPath = indexPath! as NSIndexPath
            }
        } else if segue.identifier == "AddListViewController" {
            let desController = segue.destination as! UINavigationController
            let detailController = desController.viewControllers[0] as! AddListViewController
            detailController.delegate = self
        }
    }
    
    
    //add list callback
    func addListCallBack(item:ListItem) {
        dateSource.append(item)
        tableView.reloadData()
        saveData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
