//
//  DrawView.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit
import Darwin

class DrawView: UIView {
	
	var lines:[Line] = []
	var lastPoint: CGPoint!
	var modeColor = ""
	var modeMirror = "Mr"
	var modeGeometric = "Gp"
	var modeThick = "Ta"
	var modeRounded = "Rs"
	var modeGridLarge = "0"
	var targetRender:UIImageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
	var targetOutput:UIView = UIView(frame: CGRectMake(0, 0, 0, 0))
	var menuView:UIView = UIView(frame: CGRectMake(0, 0, 0, 0))
	
	var setUnit: CGFloat!
	
	override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
	{
		if let touch = touches.first as? UITouch {
			
			lastPoint = touch.locationInView(self)
			var newPoint = touch.locationInView(self)
			
			if modeGeometric == "large"
			{
				lastPoint.x = valueRound(lastPoint.x+(setUnit/4), grid: setUnit/2)
				lastPoint.y = valueRound(lastPoint.y+(setUnit/4), grid: setUnit/2)
				newPoint.x = valueRound(newPoint.x+(setUnit/4), grid: setUnit/2)
				newPoint.y = valueRound(newPoint.y+(setUnit/4), grid: setUnit/2)
			}
			if modeGeometric == "small"
			{
				lastPoint.x = valueRound(lastPoint.x+(setUnit/8), grid: setUnit/4)
				lastPoint.y = valueRound(lastPoint.y+(setUnit/8), grid: setUnit/4)
				newPoint.x = valueRound(newPoint.x+(setUnit/8), grid: setUnit/4)
				newPoint.y = valueRound(newPoint.y+(setUnit/8), grid: setUnit/4)
			}
		}
		super.touchesBegan(touches , withEvent:event)
	}
	
	override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent)
	{
		//Create the UIImage
		UIGraphicsBeginImageContext(CGSizeMake(self.frame.width, self.frame.height))
		targetOutput.layer.renderInContext(UIGraphicsGetCurrentContext())
		let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		targetRender.image = image
		lines = []
		self.setNeedsDisplay()
		
		menuView.hidden = false
	}
	
	override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
	{
		if let touch = touches.first as? UITouch
		{
			var newPoint = touch.locationInView(self)
			
			if modeGeometric == "large"
			{
				newPoint.x = valueRound(newPoint.x+(setUnit/4), grid: setUnit/2)
				newPoint.y = valueRound(newPoint.y+(setUnit/4), grid: setUnit/2)
			}
			if modeGeometric == "small"
			{
				newPoint.x = valueRound(newPoint.x+(setUnit/8), grid: setUnit/4)
				newPoint.y = valueRound(newPoint.y+(setUnit/8), grid: setUnit/4)
			}
			
			menuView.hidden = true
			addStroke(newPoint)
		}
		super.touchesBegan(touches , withEvent:event)
	}
	
	func addStroke(point:CGPoint)
	{
		
		var newPoint = point
		if modeGeometric == "large"
		{
			newPoint.x = valueRound(newPoint.x+(setUnit/4), grid: setUnit/2)
			newPoint.y = valueRound(newPoint.y+(setUnit/4), grid: setUnit/2)
		}
		if modeGeometric == "small"
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
	
	func setMenuViewNew(targetMenuView:UIView)
	{
		menuView = targetMenuView
	}
	
	override func drawRect(rect: CGRect)
	{
		var context = UIGraphicsGetCurrentContext()
		CGContextBeginPath(context)
		
		CGContextSetLineWidth(context, 1)
		
		var gridUnit:CGFloat = self.setUnit/2
		
		var lineId = 0
		
		let gradientDamier = [
			UIColorFromRGB(0x000000),
			UIColorFromRGB(0xffffff)
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
			if(line.color == "black"){ colorValue = UIColorFromRGB(0x000000).CGColor	}
			if(line.color == "white"){ colorValue = UIColorFromRGB(0xffffff).CGColor	}
			if(line.color == "red"){ colorValue = UIColorFromRGB(0xff0000).CGColor	}
			if(line.color == "cyan"){ colorValue = UIColorFromRGB(0x72dec2).CGColor	}
			if line.color == "chess"{ colorValue = gradientDamier[((lineId+lines.count)/5 % gradientDamier.count)].CGColor }
			
			// Thickness Modes
			if line.modeThick == "1" { CGContextSetLineWidth(context, round(1)) }
			if line.modeThick == "2" { CGContextSetLineWidth(context, round(gridUnit/2-2)) }
			if line.modeThick == "3" { CGContextSetLineWidth(context, round(gridUnit-2)) }
			if line.modeThick == "4" { CGContextSetLineWidth(context, round(gridUnit)) }
			if line.modeThick == "osc" {
				
				let lineThickness:Int = 30
				var lineWidth = (lineId+lines.count)/(lineThickness/10) % lineThickness
				if lineWidth > (lineThickness/2)
				{
					lineWidth = lineThickness - lineWidth
				}
				lineWidth += 2
				CGContextSetLineWidth(context, round(CGFloat(lineWidth)))
			}
			
			// Rounding Modes
			if line.modeRounded == "round" { CGContextSetLineCap(context, kCGLineCapRound) }
			if line.modeRounded == "square" { CGContextSetLineCap(context, kCGLineCapSquare) }
			
			if startX == endX && startY == endY
			{
				continue
			}
			
			CGContextMoveToPoint(context, startX,startY)
			CGContextAddLineToPoint(context, endX, endY)
			CGContextSetStrokeColorWithColor(context, colorValue)
			CGContextStrokePath(context)
			
			// Mirror
			if line.modeMirror == "x"
			{
				var mirrorStart = self.frame.size.width/2 - ( startX - self.frame.size.width/2 )
				var mirrorEnd = self.frame.size.width/2 - ( endX - self.frame.size.width/2 )
				
				CGContextMoveToPoint(context, mirrorStart, startY)
				CGContextAddLineToPoint(context, mirrorEnd, endY)
				CGContextSetStrokeColorWithColor(context, colorValue)
				CGContextStrokePath(context)
			}
			
			if line.modeMirror == "y"
			{
				var mirrorStart = self.frame.size.height/2 - ( startY - self.frame.size.height/2 )
				var mirrorEnd = self.frame.size.height/2 - ( endY - self.frame.size.height/2 )
				
				CGContextMoveToPoint(context, startX, mirrorStart)
				CGContextAddLineToPoint(context, endX, mirrorEnd)
				CGContextSetStrokeColorWithColor(context, colorValue)
				CGContextStrokePath(context)
			}
			
			if line.modeMirror == "radius"
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
