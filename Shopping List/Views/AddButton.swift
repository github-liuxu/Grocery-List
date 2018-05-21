//
//  AddButton.swift
//  Grocery List
//
//  Created by Thomas Foster on 9/28/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

//@IBDesignable
class AddButton: UIButton {

	var showPlus: Bool = true
	
	
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	
	override func draw(_ rect: CGRect) {
		
		let margin: CGFloat = 10
		let circleThickness: CGFloat = 1.5
		let dotMargin: CGFloat = 0
		let plusMargin: CGFloat = 4.0
		let plusColor = UIColor(red: 67/255, green: 211/255, blue: 89/255, alpha: 1)
//		let minusColor = UIColor(red: 255/255, green: 51/255, blue: 43/255, alpha: 1)
		let minusColor = UIColor.darkGray
		
		let midy = bounds.height / 2
		let midx = bounds.width / 2

		if showPlus {
			let dotx = rect.origin.x + margin+dotMargin
			let doty = rect.origin.y + margin+dotMargin
			let dotWidth = rect.size.width - 2*(margin+dotMargin)
			let dotHeight = rect.size.height - 2*(margin+dotMargin)
			let dotRect = CGRect(x: dotx, y: doty, width: dotWidth, height: dotHeight)

			let dot = UIBezierPath(ovalIn: dotRect)
			plusColor.setFill()
			dot.fill()
			
			
			let plusPath = UIBezierPath()
			plusPath.lineWidth = 3.0
			plusPath.move(to: CGPoint(x: margin+plusMargin, y: midy))
			plusPath.addLine(to: CGPoint(x: bounds.maxX-margin-plusMargin, y: midy))
			plusPath.move(to: CGPoint(x: midx, y: bounds.maxY-margin-plusMargin))
			plusPath.addLine(to: CGPoint(x: midx, y: margin+plusMargin))
			UIColor.white.setStroke()
			plusPath.stroke()
			
			
		} else {	// minus symbol
			let circlex = rect.origin.x + margin
			let circley = rect.origin.y + margin
			let circleWidth = rect.width - margin*2
			let circleHeight = rect.height - margin*2
			let circleRect = CGRect(x: circlex, y: circley, width: circleWidth, height: circleHeight)
			
			let circle = UIBezierPath(ovalIn: circleRect)
			circle.lineWidth = circleThickness
			
			UIColor.lightGray.setStroke()
			circle.stroke()
			
			let plusPath = UIBezierPath()
			plusPath.lineWidth = 3.0
			plusPath.move(to: CGPoint(x: margin+plusMargin, y: midy))
			plusPath.addLine(to: CGPoint(x: bounds.maxX-margin-plusMargin, y: midy))
			minusColor.setStroke()
			plusPath.stroke()

		}
		
	}
	
	private struct Constants {
		static let plusLineWidth: CGFloat = 3.0
		static let plusButtonScale: CGFloat = 0.6
		static let halfPointShift: CGFloat = 0.5
	}
	
	private var halfWidth: CGFloat {
		return bounds.width / 2
	}
	
	private var halfHeight: CGFloat {
		return bounds.height / 2
	}

}
