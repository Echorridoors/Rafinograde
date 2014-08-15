//
//  DrawView.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

class DrawView: UIView {
	
	var lines:[Line] = []
	var lastPoint: CGPoint!
	var modeColor = "Ch"
	var modeMirror = "Mr"
	var modeGeometric = "Gs"
	var modeThick = "T4"
	var modeRounded = "0"
	var modeGridLarge = "0"
	
	var setUnit: CGFloat!
	
	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	{
		lastPoint = touches.anyObject().locationInView(self)
	}
	
	override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	{
		var newPoint = touches.anyObject().locationInView(self)
		lines.append(Line(start: lastPoint, end: newPoint, color: modeColorPaint(), modeMirror: modeMirror, modeGeometric: modeGeometric, modeThick: modeThick, modeRounded: modeRounded, modeGridLarge: modeGridLarge))
		lastPoint = newPoint
		
		if lines.count > 2500
		{
			lines = lines.reverse()
			lines.removeLast()
			lines = lines.reverse()
		}
		
		self.setNeedsDisplay()
	}
	
	func modeColorPaint() -> UIColor
	{
		if self.modeColor == "Ch"
		{
			return UIColor.purpleColor()
		}
		else
		{
			return UIColor.blackColor()
		}
	}
	
	func valueRound( value:CGFloat, grid:CGFloat) -> CGFloat
	{
		return CGFloat( (Int(value/grid) * Int(grid)) )
	}
	
	func UIColorFromRGB(rgbValue: UInt) -> UIColor {
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	override func drawRect(rect: CGRect)
	{
		
		var context = UIGraphicsGetCurrentContext()
		CGContextBeginPath(context)
		CGContextSetLineCap(context, kCGLineCapRound)
		CGContextSetLineWidth(context, 1)
		
		var gridUnit:CGFloat = self.setUnit/2
		
		var lineId = 0
		
		for line in lines
		{
			
			var color = line.color.CGColor
			var startX = line.start.x
			var startY = line.start.y
			var endX = line.end.x
			var endY = line.end.y			
			
			
			// Colour Modes
			if line.color == UIColor.purpleColor()
			{
				let array = [
					UIColorFromRGB(0xffa726),
					UIColorFromRGB(0xef1180),
					UIColorFromRGB(0xb02389),
					UIColorFromRGB(0xe65a4d),
					UIColorFromRGB(0xffef04),
					UIColorFromRGB(0x20c6e0),
					UIColorFromRGB(0x3580c4)
				]
				let colorIndex = (lineId+lines.count)/20 % array.count
				color = array[colorIndex].CGColor
			}
			
			// Thickness Modes
			if line.modeThick == "T1" { CGContextSetLineWidth(context, 1) }
			if line.modeThick == "T2" { CGContextSetLineWidth(context, gridUnit/3-2) }
			if line.modeThick == "T3" { CGContextSetLineWidth(context, gridUnit/2-2) }
			if line.modeThick == "T4" { CGContextSetLineWidth(context, gridUnit-2) }
			
			if line.modeGeometric == "Gs"
			{
				startX = valueRound(line.start.x+(gridUnit/2), grid: gridUnit)
				startY = valueRound(line.start.y+(gridUnit/2), grid: gridUnit)
				endX = valueRound(line.end.x+(gridUnit/2), grid: gridUnit)
				endY = valueRound(line.end.y+(gridUnit/2), grid: gridUnit)
				CGContextSetLineCap(context, kCGLineCapSquare)
			}
			if line.modeGeometric == "Gp"
			{
				startX = valueRound(line.start.x+(gridUnit/2), grid: gridUnit/2)
				startY = valueRound(line.start.y+(gridUnit/2), grid: gridUnit/2)
				endX = valueRound(line.end.x+(gridUnit/2), grid: gridUnit/2)
				endY = valueRound(line.end.y+(gridUnit/2), grid: gridUnit/2)
			}
			
			if startX == endX && startY == endY
			{
				continue
			}
			
			CGContextMoveToPoint(context, startX,startY)
			CGContextAddLineToPoint(context, endX, endY)
			CGContextSetStrokeColorWithColor(context, color)
			CGContextStrokePath(context)
			
			if line.modeMirror == "Mx"
			{
				var mirrorStart = self.frame.size.width/2 - ( startX - self.frame.size.width/2 )
				var mirrorEnd = self.frame.size.width/2 - ( endX - self.frame.size.width/2 )
				
				CGContextMoveToPoint(context, mirrorStart, startY)
				CGContextAddLineToPoint(context, mirrorEnd, endY)
				CGContextSetStrokeColorWithColor(context, color)
				CGContextStrokePath(context)
			}
			
			if line.modeMirror == "My"
			{
				var mirrorStart = self.frame.size.height/2 - ( startY - self.frame.size.height/2 )
				var mirrorEnd = self.frame.size.height/2 - ( endY - self.frame.size.height/2 )
				
				CGContextMoveToPoint(context, startX, mirrorStart)
				CGContextAddLineToPoint(context, endX, mirrorEnd)
				CGContextSetStrokeColorWithColor(context, color)
				CGContextStrokePath(context)
			}
			
			if line.modeMirror == "Mr"
			{
				var mirrorStart = self.frame.size.height/2 - ( startY - self.frame.size.height/2 )
				var mirrorEnd = self.frame.size.height/2 - ( endY - self.frame.size.height/2 )
				var mirrorStart2 = self.frame.size.width/2 - ( startX - self.frame.size.width/2 )
				var mirrorEnd2 = self.frame.size.width/2 - ( endX - self.frame.size.width/2 )
				
				CGContextMoveToPoint(context, mirrorStart2, mirrorStart)
				CGContextAddLineToPoint(context, mirrorEnd2, mirrorEnd)
				CGContextSetStrokeColorWithColor(context, color)
				CGContextStrokePath(context)
			}
			lineId += 1
			
		}
	}
	

}
