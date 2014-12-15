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
	var modeColor = "Cb"
	var modeMirror = "Mr"
	var modeGeometric = "Gp"
	var modeThick = "Ta"
	var modeRounded = "Rs"
	var modeGridLarge = "0"
	var targetRender:UIImageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
	var targetOutput:UIView = UIView(frame: CGRectMake(0, 0, 0, 0))
	
	var setUnit: CGFloat!
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
	{
		let touchesFix = touches.anyObject() as UITouch
		
		lastPoint = touchesFix.locationInView(self)
		var newPoint = touchesFix.locationInView(self)
		
		if modeGeometric == "Gs"
		{
			newPoint.x = valueRound(newPoint.x+(setUnit/4), grid: setUnit/2)
			newPoint.y = valueRound(newPoint.y+(setUnit/4), grid: setUnit/2)
		}
		if modeGeometric == "Gp"
		{
			newPoint.x = valueRound(newPoint.x+(setUnit/8), grid: setUnit/4)
			newPoint.y = valueRound(newPoint.y+(setUnit/8), grid: setUnit/4)
		}
		lastPoint = newPoint
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
	{
		//Create the UIImage
		UIGraphicsBeginImageContext(CGSizeMake(self.frame.width, self.frame.height))
		targetOutput.layer.renderInContext(UIGraphicsGetCurrentContext())
		let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		targetRender.image = image
		lines = []
	}
	
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
	{
		let touchesFix = touches.anyObject() as UITouch
		
		var newPoint = touchesFix.locationInView(self)
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
		if modeGeometric == "Gp"
		{
			newPoint.x = valueRound(newPoint.x+(setUnit/8), grid: setUnit/4)
			newPoint.y = valueRound(newPoint.y+(setUnit/8), grid: setUnit/4)
		}
		
		if newPoint.x == lastPoint.x && newPoint.y == lastPoint.y
		{
			return
		}
		
		lines.append(Line(start: lastPoint, end: newPoint, color: modeColor, modeMirror: modeMirror, modeGeometric: modeGeometric, modeThick: modeThick, modeRounded: modeRounded, modeGridLarge: modeGridLarge))
		lastPoint = newPoint
		
		if lines.count > 1000
		{
			lines = lines.reverse()
			lines.removeLast()
			lines = lines.reverse()
		}
		
		self.setNeedsDisplay()
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
	
	func setRenderView(targetRenderView:UIImageView,targetOutputView:UIView)
	{
		targetRender = targetRenderView
		targetOutput = targetOutputView
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
		let gradientGrey = [
			UIColorFromRGB(0x000000),
			UIColorFromRGB(0x333333),
			UIColorFromRGB(0x999999),
			UIColorFromRGB(0xcccccc),
			UIColorFromRGB(0xeeeeee),
			UIColorFromRGB(0xcccccc),
			UIColorFromRGB(0x999999),
			UIColorFromRGB(0x333333)
		]
		
		for line in lines
		{
			var color = line.color
			var startX = line.start.x
			var startY = line.start.y
			var endX = line.end.x
			var endY = line.end.y
			
			var colorValue:CGColor = UIColorFromRGB(0xffffff).CGColor
	
			// Colour Modes
			if(line.color == "Cb"){ colorValue = UIColorFromRGB(0x000000).CGColor	}
			if(line.color == "Cw"){ colorValue = UIColorFromRGB(0xffffff).CGColor	}
			if(line.color == "Cr"){ colorValue = UIColorFromRGB(0xff0000).CGColor	}
			if(line.color == "Cy"){ colorValue = UIColorFromRGB(0x72dec2).CGColor	}
			if line.color == "Gg"
			{
				let colorIndex = (lineId+lines.count)/20 % gradientGrey.count
				colorValue = gradientGrey[colorIndex].CGColor
			}
			
			// Thickness Modes
			if line.modeThick == "T1" { CGContextSetLineWidth(context, round(1)) }
			if line.modeThick == "T2" { CGContextSetLineWidth(context, round(gridUnit/3-2)) }
			if line.modeThick == "T3" { CGContextSetLineWidth(context, round(gridUnit/2-2)) }
			if line.modeThick == "T4" { CGContextSetLineWidth(context, round(gridUnit-2)) }
			
			if line.modeThick == "Ta" {
				var lineWidth = (lineId+lines.count)/40 % 20
				
				if lineWidth > 10
				{
					lineWidth = 20 - lineWidth
				}
				
				CGContextSetLineWidth(context, round(CGFloat(lineWidth)))
			}
			
			if line.modeRounded == "Rr" { CGContextSetLineCap(context, kCGLineCapRound) }
			if line.modeRounded == "Rs" { CGContextSetLineCap(context, kCGLineCapSquare) }
			
			if startX == endX && startY == endY
			{
				continue
			}
			
			CGContextMoveToPoint(context, startX,startY)
			CGContextAddLineToPoint(context, endX, endY)
			CGContextSetStrokeColorWithColor(context, colorValue)
			CGContextStrokePath(context)
			
			if line.modeMirror == "Mx"
			{
				var mirrorStart = self.frame.size.width/2 - ( startX - self.frame.size.width/2 )
				var mirrorEnd = self.frame.size.width/2 - ( endX - self.frame.size.width/2 )
				
				CGContextMoveToPoint(context, mirrorStart, startY)
				CGContextAddLineToPoint(context, mirrorEnd, endY)
				CGContextSetStrokeColorWithColor(context, colorValue)
				CGContextStrokePath(context)
			}
			
			if line.modeMirror == "My"
			{
				var mirrorStart = self.frame.size.height/2 - ( startY - self.frame.size.height/2 )
				var mirrorEnd = self.frame.size.height/2 - ( endY - self.frame.size.height/2 )
				
				CGContextMoveToPoint(context, startX, mirrorStart)
				CGContextAddLineToPoint(context, endX, mirrorEnd)
				CGContextSetStrokeColorWithColor(context, colorValue)
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
				CGContextSetStrokeColorWithColor(context, colorValue)
				CGContextStrokePath(context)
			}
			lineId += 1
			
		}
	}
	

}
