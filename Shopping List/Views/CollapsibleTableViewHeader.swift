import UIKit

protocol CollapsibleTableViewHeaderDelegate {
	func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var countLabel: UILabel!
	@IBOutlet weak var button: SectionToggle!
	
	var delegate: CollapsibleTableViewHeaderDelegate?
	var section: Int = 0
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
	
	var aisle: Section? {
		didSet {
			guard let aisle = aisle else { return }
			countLabel.text = "\(aisle.masterListItem.count)"
			titleLabel.text = aisle.name
			//setCollapsed(aisle.isCollapsed)
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapHeader(_:))))
	}
	
	@objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
		guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else { return }
		delegate?.toggleSection(self, section: cell.section)
	}
	
	func setCollapsed(_ collapsed: Bool) {
//		button.rotate(collapsed ? 0.0 : .pi / 2)
	}
	
}
