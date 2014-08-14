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
		var context = UIGraphicsGetCurrentContext()
		CGContextBeginPath(context)
		CGContextSetLineCap(context, kCGLineCapRound)
		CGContextSetLineWidth(context, 1)
		for line in lines
		{
			CGContextMoveToPoint(context, line.start.x, line.start.y)
			CGContextAddLineToPoint(context, line.end.x, line.end.y)
			CGContextSetStrokeColorWithColor(context, line.color.CGColor)
			CGContextStrokePath(context)
		}
		
		for line in lines
		{
			var mirrorStart = self.frame.size.width/2 - ( line.start.x * 0.5 - self.frame.size.width/2 )
			var mirrorEnd = self.frame.size.width/2 - ( line.end.x * 0.5 - self.frame.size.width/2 )
			
			
			CGContextMoveToPoint(context, mirrorStart, line.start.y)
			CGContextAddLineToPoint(context, mirrorEnd, line.end.y)
			CGContextSetStrokeColorWithColor(context, line.color.CGColor)
			CGContextStrokePath(context)
		}
	}

}
