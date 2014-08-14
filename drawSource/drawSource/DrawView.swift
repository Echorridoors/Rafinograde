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
	var drawColor = UIColor.blackColor()
	
	override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
	{
		lastPoint = touches.anyObject().locationInView(self)
	}
	
	override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
	{
		var newPoint = touches.anyObject().locationInView(self)
		lines.append(Line(start: lastPoint, end: newPoint, color: drawColor))
		lastPoint = newPoint
		
		self.setNeedsDisplay()
	}
	
	override func drawRect(rect: CGRect)
	{
		var settings = ["mirrorX":"1","snap":"1"]
		
		var context = UIGraphicsGetCurrentContext()
		CGContextBeginPath(context)
		CGContextSetLineCap(context, kCGLineCapRound)
		CGContextSetLineWidth(context, 1)
		for line in lines
		{
			var startX = line.start.x
			var startY = line.start.y
			var endX = line.end.x
			var endY = line.end.y
			
			if settings["snap"] == "1"
			{
				startX = CGFloat(Int(line.start.x/20)*20)
				startY = CGFloat(Int(line.start.y/20)*20)
				endX = CGFloat(Int(line.end.x/20)*20)
				endY = CGFloat(Int(line.end.y/20)*20)
			}
			
			CGContextMoveToPoint(context, startX,startY)
			CGContextAddLineToPoint(context, endX, endY)
			CGContextSetStrokeColorWithColor(context, line.color.CGColor)
			CGContextStrokePath(context)
			if settings["mirrorX"] == "1"
			{
					var mirrorStart = self.frame.size.width/2 - ( startX - self.frame.size.width/2 )
					var mirrorEnd = self.frame.size.width/2 - ( endX - self.frame.size.width/2 )
					
					CGContextMoveToPoint(context, mirrorStart, startY)
					CGContextAddLineToPoint(context, mirrorEnd, endY)
					CGContextSetStrokeColorWithColor(context, line.color.CGColor)
					CGContextStrokePath(context)
				
			}
		}
	}
	

}
