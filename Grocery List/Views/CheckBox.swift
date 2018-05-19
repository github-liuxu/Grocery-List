import UIKit

//@IBDesignable
class CheckBox: UIButton {
	
	var isChecked: Bool = false
	
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	
	override func draw(_ rect: CGRect) {
		
		let margin: CGFloat = 10
		let circleThickness: CGFloat = 1.25
		let dotMargin: CGFloat = 3.5
		let color = CHECKBOX_COLOR
		
		// Original blue color
		//UIColor(red: 0, green: 111/255, blue: 255/255, alpha: 1)
		
		let circlex = rect.origin.x + margin
		let circley = rect.origin.y + margin
		let circleWidth = rect.width - margin*2
		let circleHeight = rect.height - margin*2
		let circleRect = CGRect(x: circlex, y: circley, width: circleWidth, height: circleHeight)
		
		let dotx = rect.origin.x + margin+dotMargin
		let doty = rect.origin.y + margin+dotMargin
		let dotWidth = rect.size.width - 2*(margin+dotMargin)
		let dotHeight = rect.size.height - 2*(margin+dotMargin)
		let dotRect = CGRect(x: dotx, y: doty, width: dotWidth, height: dotHeight)
		
		let circle = UIBezierPath(ovalIn: circleRect)
		circle.lineWidth = circleThickness
		UIColor.lightGray.setStroke()
		circle.stroke()
		
		if isChecked {
			let dot = UIBezierPath(ovalIn: dotRect)
			color.setFill()
			dot.fill()
		}
		
	}
	
	private struct Constants {
		static let checkWidth: CGFloat = 3.0
		static let checkScale: CGFloat = 0.6
		static let halfPointShift: CGFloat = 0.5
	}
	
	private var halfWidth: CGFloat {
		return bounds.width / 2
	}
	
	private var halfHeight: CGFloat {
		return bounds.height / 2
	}
	
}
