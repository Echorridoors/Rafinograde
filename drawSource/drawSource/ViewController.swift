//
//  ViewController.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
		
	@IBOutlet var gridView: UIView!
	@IBOutlet var drawView: DrawView!
	
	@IBOutlet var optionClear: UIButton!
	@IBOutlet var optionUndo: UIButton!
	
	@IBOutlet var modeGeometric: UIButton!
	@IBOutlet var modeMirrorX: UIButton!
	@IBOutlet var modeThick: UIButton!
	@IBOutlet var modeRounded: UIButton!
	@IBOutlet var modeColor: UIButton!
	
	@IBOutlet var interfaceOptions: UIView!
	@IBOutlet var interfaceModes: UIView!
	
	var tileSize:CGFloat!
	var screenWidth:CGFloat!
	var screenHeight:CGFloat!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		templateStart()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func templateStart()
	{
		tileSize = self.view.frame.size.width/8
		screenWidth = self.view.frame.size.width
		screenHeight = self.view.frame.size.height
		
		
		var theDrawView = drawView as DrawView
		theDrawView.setUnit = tileSize
		
		// Interfaces
		interfaceOptions.frame = CGRectMake(tileSize, 0, screenWidth-(2*tileSize), tileSize)
		interfaceModes.frame = CGRectMake(tileSize, screenHeight-tileSize, screenWidth-(2*tileSize), tileSize)
		
		// Options
		
		optionClear.frame = CGRectMake(tileSize*5, 0, tileSize, tileSize)
		optionClear.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		optionClear.setTitle("Nu", forState: UIControlState.Normal)
		
		optionUndo.frame = CGRectMake(0, 0, tileSize, tileSize)
		optionUndo.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		optionUndo.setTitle("Un", forState: UIControlState.Normal)
		
		// Modes
		modeMirrorX.frame = CGRectMake(0, 0, tileSize, tileSize)
		modeMirrorX.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeMirrorX.setTitle("Mi", forState: UIControlState.Normal)
		
		// Geometric
		modeGeometric.frame = CGRectMake(tileSize, 0, tileSize, tileSize)
		modeGeometric.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeGeometric.setTitle("Sq", forState: UIControlState.Normal)
		
		// Thickness
		modeThick.frame = CGRectMake(tileSize*2, 0, tileSize, tileSize)
		modeThick.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeThick.setTitle("Th", forState: UIControlState.Normal)
		
		// Roundess
		modeRounded.frame = CGRectMake(tileSize*3, 0, tileSize, tileSize)
		modeRounded.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeRounded.setTitle("Rn", forState: UIControlState.Normal)
		
		// Color
		modeColor.frame = CGRectMake(tileSize*5, 0, tileSize, tileSize)
		modeColor.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
		modeColor.setTitle("Cl", forState: UIControlState.Normal)
			
		templateGrid()
	}
	
	func templateGrid()
	{
		var lineView = UIView(frame: CGRectMake(tileSize, tileSize, 1, screenHeight-(2*tileSize)))
		lineView.backgroundColor = UIColor.whiteColor()
		self.gridView.addSubview(lineView)
		
		lineView = UIView(frame: CGRectMake(screenWidth-tileSize, tileSize, 1, screenHeight-(2*tileSize)))
		lineView.backgroundColor = UIColor.whiteColor()
		self.gridView.addSubview(lineView)
		
		lineView = UIView(frame: CGRectMake(tileSize, tileSize, screenWidth-(2*tileSize), 1))
		lineView.backgroundColor = UIColor.whiteColor()
		self.gridView.addSubview(lineView)
		
		lineView = UIView(frame: CGRectMake(tileSize, screenHeight-tileSize, screenWidth-(2*tileSize), 1))
		lineView.backgroundColor = UIColor.whiteColor()
		self.gridView.addSubview(lineView)
		
		var x:CGFloat = 1
		while x < 18
		{
			var y:CGFloat = 1
			while y < 30
			{
				var posX:CGFloat =  CGFloat( Int( tileSize+(tileSize/3*x) ) )
				var posY:CGFloat =  CGFloat( Int( tileSize+(tileSize/3*y) ) )
				
				var lineView = UIView(frame: CGRectMake( posX, posY, 1, 1))
				lineView.backgroundColor = UIColor.whiteColor()
				self.gridView.addSubview(lineView)
				
				y = y + 1
			}
			
			x = x + 1
		}
	}
	
	@IBAction func optionClear(sender: AnyObject)
	{
		NSLog("> OPTI | Clear")
		var theDrawView = drawView as DrawView
		theDrawView.lines = []
		theDrawView.setNeedsDisplay()
	}
	
	@IBAction func modeColor(sender: AnyObject)
	{
		var theDrawView = drawView as DrawView
		var color: UIColor!
		if( theDrawView.drawColor == UIColor.redColor() ){
			color = UIColor.blackColor()
		}
		else{
			color = UIColor.redColor()
		}
		theDrawView.drawColor = color
		
		NSLog("> MODE | %@", theDrawView.drawColor)
	}
	@IBAction func modeGeometric(sender: AnyObject)
	{
		var theDrawView = drawView as DrawView
		theDrawView.modeGeometric = "1"
	}
	@IBAction func modeMirrorX(sender: AnyObject)
	{
		var theDrawView = drawView as DrawView
		theDrawView.modeMirrorX = "1"
	}
	
	@IBAction func modeThick(sender: AnyObject)
	{
		var theDrawView = drawView as DrawView
		theDrawView.modeThick = "1"
	}
	
	@IBAction func modeRounded(sender: AnyObject)
	{
		var theDrawView = drawView as DrawView
		theDrawView.modeRounded = "1"
	}
	
	@IBAction func optionUndo(sender: AnyObject)
	{
		var theDrawView = drawView as DrawView
		theDrawView.lines.removeLast()
		theDrawView.setNeedsDisplay()
	}
	
	
	
	// MARK: - Misc
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}

}

