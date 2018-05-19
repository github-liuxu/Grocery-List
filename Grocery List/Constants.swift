import UIKit

// App Colors

// Yellow Theme

//let NAV_BKG = Color.iconYellow
//let BAR_BUTTON_COLOR = Color.defaultBlue
//let TITLE_COLOR = UIColor.black
//let HEADER_COLOR = Color.defaultBlue
//let CHECKBOX_COLOR = Color.mexicanRed
//let TOOLBAR_ITEM_COLOR = Color.defaultBlue
//var statusColor = "light"


// Red Theme

let NAV_BKG = Color.mexicanRed
let BAR_BUTTON_COLOR = UIColor.white
let TITLE_COLOR = UIColor.white
let HEADER_COLOR = Color.mexicanRed
let TOOLBAR_ITEM_COLOR = Color.mexicanRed
let CHECKBOX_COLOR = Color.defaultBlue

struct Color {
	
	// Icon Colors
	static let iconYellow = UIColor(red: 255/255, green: 224/255, blue: 147/255, alpha: 1.0)
	static let iconDarkBlue = UIColor(red: 31/255, green: 199/255, blue: 215/255, alpha: 1.0)
	
	// Old Colors
	static let mexicanRed = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
	static let oldRed = UIColor(red: 235/255, green: 25/255, blue: 65/255, alpha: 1.0)
	
	// Other Colors
	static let defaultBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
}

struct Constants {
	static var isTesting = false
}

func testData() -> [Section] {
	
	var fullList: [Section] = []
	
	let produceSection = Section()
	produceSection.name = "Produce Section"
	produceSection.isSelected = true
	let apples = Item(name: "Apples")
	let bananas = Item(name: "Bananas")
	let carrots = Item(name: "Carrots")
	let celery = Item(name: "Celery")
	produceSection.masterListItem.append(apples)
	produceSection.masterListItem.append(bananas)
	produceSection.masterListItem.append(carrots)
	produceSection.masterListItem.append(celery)
	fullList.append(produceSection)
	
	let deliSection = Section()
	deliSection.name = "Deli"
	let cheese = Item(name: "Cheese")
	let meat = Item(name: "Lunch Meat")
	let salad = Item(name: "Potato Salad")
	deliSection.masterListItem.append(cheese)
	deliSection.masterListItem.append(meat)
	deliSection.masterListItem.append(salad)
	fullList.append(deliSection)
	
	let breadSection = Section()
	breadSection.name = "Bread Aisle"
	let bread = Item(name: "Bread")
	let rolls = Item(name: "Hamburger Rolls")
	breadSection.masterListItem.append(bread)
	breadSection.masterListItem.append(rolls)
	fullList.append(breadSection)
	
	let dairySection = Section()
	dairySection.name = "Dairy Section"
	let milk = Item(name: "Milk")
	let eggs = Item(name: "Eggs")
	let butter = Item(name: "Butter")
	dairySection.masterListItem.append(milk)
	dairySection.masterListItem.append(eggs)
	dairySection.masterListItem.append(butter)
	fullList.append(dairySection)
	
	let householdSection = Section()
	householdSection.name = "Household Items Aisle"
	let pt = Item(name: "Paper Towels")
	let tp = Item(name: "Toilet Paper")
	householdSection.masterListItem.append(pt)
	householdSection.masterListItem.append(tp)
	fullList.append(householdSection)
	
	return fullList
}




func loadDefaultData() -> [Section] {
	
	var list: [Section] = []
	
	let produceSection = Section()
	produceSection.name = "Produce Section"
	produceSection.isSelected = true
	let apples = Item(name: "Apples")
	let bananas = Item(name: "Bananas")
	let carrots = Item(name: "Carrots")
	let celery = Item(name: "Celery")
	produceSection.masterListItem.append(apples)
	produceSection.masterListItem.append(bananas)
	produceSection.groceryItem.append(bananas)
	produceSection.masterListItem.append(carrots)
	produceSection.masterListItem.append(celery)
	produceSection.groceryItem.append(celery)
	list.append(produceSection)
	
	let breadSection = Section()
	breadSection.name = "Bread Aisle"
	let bread = Item(name: "Bread")
	let rolls = Item(name: "Bagels")
	let jelly = Item(name: "Jelly")
	breadSection.masterListItem.append(bread)
	breadSection.groceryItem.append(bread)
	breadSection.masterListItem.append(rolls)
	breadSection.masterListItem.append(jelly)
	list.append(breadSection)
	
	let dairySection = Section()
	dairySection.name = "Dairy Section"
	let milk = Item(name: "Milk")
	let eggs = Item(name: "Eggs")
	let butter = Item(name: "Butter")
	dairySection.masterListItem.append(milk)
	dairySection.groceryItem.append(milk)
	dairySection.masterListItem.append(eggs)
	dairySection.groceryItem.append(eggs)
	dairySection.masterListItem.append(butter)
	list.append(dairySection)
	
	
	return list
}


