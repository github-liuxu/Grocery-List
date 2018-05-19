// Data Model

import Foundation

// Section = Supermarket aisle
class Section: NSObject, Codable {

	var name: String = ""
	var groceryItem: [Item] = []		// grocery list items
	var masterListItem: [Item] = []		// saved items list

	var isSelected: Bool = false		// for selecting which section an item is in while adding an item
	var isCollapsed: Bool = false
	
		
}



class Item: NSObject, Codable {
	
	var name: String = ""
	var isInCart: Bool = false
	var isOnGroceryList: Bool = false
	
	init(name: String) {
		self.name = name
	}
	
	
}

class ListItem: NSObject, Codable {
    
    var grocery:[Section] = []
    var name: String = ""
    var date: String = ""
    var money: String = ""
    
}





