//
//  Arrow.swift
//  Grocery List
//
//  Created by Thomas Foster on 10/20/17.
//  Copyright © 2017 Thomas Foster. All rights reserved.
//

import UIKit

class Arrow: UIButton {

	var pointsRight: Bool = false
	
    override func draw(_ rect: CGRect) {
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: rect.origin.x, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.maxX-3.0, y: rect.maxY/2))
		path.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y))

		path.lineWidth = 3.0
		path.stroke()
	}

}
