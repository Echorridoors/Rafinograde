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
	var modeRounded = "Rs"
	var modeGridLarge = "0"
	
	var setUnit: CGFloat!
	
	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	{
		lastPoint = touches.anyObject().locationInView(self)
		var newPoint = touches.anyObject().locationInView(self)
		
		if modeGeometric == "Gs"
		{
			newPoint.x = valueRound(newPoint.x+(setUnit/4), grid: setUnit/2)
			newPoint.y = valueRound(newPoint.y+(setUnit/4), grid: setUnit/2)
		}
		lastPoint = newPoint
	}
	
	override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
	{
	
	}
	
	
	override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	{
		var newPoint = touches.anyObject().locationInView(self)
		addStroke(newPoint)
	}
	
	func addStroke(point:CGPoint)
	{
		
		var newPoint = point
		if modeGeometric == "Gs"
		{
			newPoint.x = valueRound(newPoint.x+(setUnit/4), grid: setUnit/2)
			newPoint.y = valueRound(newPoint.y+(setUnit/4), grid: setUnit/2)
		}
		
		if newPoint.x == lastPoint.x && newPoint.y == lastPoint.y
		{
			return
		}
		
		lines.append(Line(start: lastPoint, end: newPoint, color: modeColorPaint(), modeMirror: modeMirror, modeGeometric: modeGeometric, modeThick: modeThick, modeRounded: modeRounded, modeGridLarge: modeGridLarge))
		lastPoint = newPoint
		
		if lines.count > 1000
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
		else if self.modeColor == "Cw"
		{
			return UIColor.whiteColor()
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
		
		CGContextSetLineWidth(context, 1)
		
		var gridUnit:CGFloat = self.setUnit/2
		
		var lineId = 0
		
		let hohokumColours = [
			UIColorFromRGB(0xffa726),
			UIColorFromRGB(0xef1180),
			UIColorFromRGB(0xb02389),
			UIColorFromRGB(0xe65a4d),
			UIColorFromRGB(0xffef04),
			UIColorFromRGB(0x20c6e0),
			UIColorFromRGB(0x3580c4)
		]
		let xxiivvColours = [
			UIColorFromRGB(0x72dec2),
			UIColorFromRGB(0xde7272),
			UIColorFromRGB(0x222222),
			UIColorFromRGB(0xffffff)
		]
		
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
				let colorIndex = (lineId+lines.count)/20 % xxiivvColours.count
				color = xxiivvColours[colorIndex].CGColor
			}
			
			// Thickness Modes
			if line.modeThick == "T1" { CGContextSetLineWidth(context, 1) }
			if line.modeThick == "T2" { CGContextSetLineWidth(context, gridUnit/3-2) }
			if line.modeThick == "T3" { CGContextSetLineWidth(context, gridUnit/2-2) }
			if line.modeThick == "T4" { CGContextSetLineWidth(context, gridUnit-2) }
			
			if line.modeThick == "Ta" {
				var lineWidth = (lineId+lines.count)/20 % 10
				
				if lineWidth > 5
				{
					lineWidth = 10 - lineWidth
				}
				
				CGContextSetLineWidth(context, CGFloat(lineWidth))
			}
			
			
			

			if line.modeRounded == "Rr" { CGContextSetLineCap(context, kCGLineCapRound) }
			if line.modeRounded == "Rs" { CGContextSetLineCap(context, kCGLineCapSquare) }
			
			
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
