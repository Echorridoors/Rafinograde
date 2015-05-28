//
//  ViewController.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

var menus:Dictionary<String,Array<String>> = ["":["",""]]
var settings:Dictionary<String,String> = ["":""]

class ViewController: UIViewController {
		
	@IBOutlet var gridView: UIView!
	@IBOutlet var drawView: DrawView!
	
	@IBOutlet var renderView: UIImageView!
	@IBOutlet var outputView: UIView!
	
	var tileSize:CGFloat!
	var screenWidth:CGFloat!
	var screenHeight:CGFloat!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		menus = [
			"mirror":["none","x","y","radius"],
			"grid":["freehand","large","small"],
			"thickness":["1","2","3","4","osc"],
			"rounding":["round","square"],
			"color":["black","red","cyan","gradiant-black","chess"],
			"system":["save","clear","share"]
		]
		
		// Set default settings
		for categories in menus {
			settings[categories.0] = categories.1[0]
		}
		
		println(settings)
		
		templateStart()
		loadMenu()
	}
	
	// MARK: Menu -
	
	func loadMenu()
	{
		var col:CGFloat = 0
		for categories in menus {
			let menuHeight:CGFloat = CGFloat(categories.1.count) * tileSize
			let menuView = UIView(frame: CGRectMake(tileSize*col, screenHeight-menuHeight, tileSize, menuHeight))
			menuView.tag = 66
			var row:CGFloat = 0
			for option in categories.1 {
				
				// Icon
				let iconView = UIImageView(frame: CGRectMake(0, tileSize*row, tileSize, tileSize))
				
				let iconString = String(format: "%@.%@", categories.0, option)
				
				iconView.image = UIImage(named: iconString)
//				iconView.contentMode = UIViewContentMode.ScaleAspectFit
				menuView.addSubview(iconView)
				
				// Button
				let selectorString = String(format:"option%@:", categories.0.capitalizedString)
				let optionView   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
				optionView.frame = CGRectMake(0, tileSize*row, tileSize, tileSize)
				optionView.setTitle(option.0, forState: UIControlState.Normal)
				optionView.addTarget(self, action: Selector(selectorString), forControlEvents: UIControlEvents.TouchUpInside)
				optionView.titleLabel?.font = UIFont.boldSystemFontOfSize(0)
				optionView.tag = 100 + Int(1 * col)
				menuView.addSubview(optionView)
				
				row++
			}
			self.view.addSubview(menuView)
			col++
		}
	}
	
	func optionUnselect(targetTag:Int)
	{
		for targetView in self.view.subviews {
			for button in targetView.subviews {
				if button.tag == targetTag {
					let targetButton:UIButton = button as! UIButton
					targetButton.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
				}
			}
		}
	}
	
	func optionsHide()
	{
		
	}
	
	func optionThickness(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["thickness"] = sender.currentTitle
		sender.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
		optionsHide()
	}
	
	func optionSystem(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["system"] = sender.currentTitle
		sender.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
		optionsHide()
	}
	
	func optionColor(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["color"] = sender.currentTitle
		sender.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
		optionsHide()
	}
	
	func optionRounding(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["rounding"] = sender.currentTitle
		sender.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
		optionsHide()
	}
	
	func optionGrid(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["grid"] = sender.currentTitle
		sender.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
		optionsHide()
	}
	
	func optionMirror(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["mirroir"] = sender.currentTitle
		sender.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
		optionsHide()
	}
	
	// MARK: Templates -
	
	func templateStart()
	{
		tileSize = self.view.frame.size.width/8
		screenWidth = self.view.frame.size.width
		screenHeight = self.view.frame.size.height
		
		var theDrawView = drawView as DrawView
		theDrawView.setUnit = tileSize
		
		theDrawView.setRenderView(renderView,targetOutputView: outputView)
//		theDrawView.setMenuViewNew(interfaceModes)
		
		renderView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		outputView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		theDrawView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
			
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
				var posX:CGFloat =  CGFloat( Int( tileSize+(tileSize/2*x) ) )
				var posY:CGFloat =  CGFloat( Int( tileSize+(tileSize/2*y) ) )
				
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
		let randomColour = Int(arc4random_uniform(5))
		
		let colours = [UIColorFromRGB(0x72dec2).CGColor,UIColorFromRGB(0xff0000).CGColor,UIColorFromRGB(0x222222).CGColor,UIColorFromRGB(0xffffff).CGColor,UIColorFromRGB(0xdddddd).CGColor,UIColorFromRGB(0x999999).CGColor]
		let randomIndex = Int(arc4random_uniform(UInt32(colours.count)))
		
		self.outputView.backgroundColor = UIColor(CGColor: colours[randomIndex])
		
		NSLog("> OPTI | Clear")
		var theDrawView = drawView as DrawView
		theDrawView.lines = []
		renderView.image = UIImage(named: "")
		theDrawView.setNeedsDisplay()
	}
	
	@IBAction func optionSave(sender: AnyObject)
	{
		UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.width, self.view.frame.height))
		outputView.layer.renderInContext(UIGraphicsGetCurrentContext())
		let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	}

	// Modes
	
	@IBAction func modeMirror(sender: AnyObject)
	{
		modeMirrorToggle()
	}
	
	func modeMirrorToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["M","Mx","My","Mr","Ms","Mo","Mv"]
		var modesIndex = find(modes, theDrawView.modeMirror)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeMirror = modes[modeTarget]
	}
	
	// Color
	
	@IBAction func modeColor(sender: AnyObject)
	{
		modeColorToggle()
	}
	
	func modeColorToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["Cb","Cw","Cy","Cr","Gg","Gd","Gh"]
		var modesIndex = find(modes, theDrawView.modeColor)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeColor = modes[modeTarget]
		theDrawView.setNeedsDisplay()
	}
	
	// Geometric
	
	@IBAction func modeGeometric(sender: AnyObject)
	{
		modeGeometricToggle()
	}
	
	func modeGeometricToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["Gf","Gs","Gp"]
		var modesIndex = find(modes, theDrawView.modeGeometric)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeGeometric = modes[modeTarget]
	}
	
	// Thickness
	
	@IBAction func modeThick(sender: AnyObject)
	{
		modeThickToggle()
	}
	
	func modeThickToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["T1","T2","T3","T4","T5","Ta"]
		var modesIndex = find(modes, theDrawView.modeThick)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeThick = modes[modeTarget]
	}
	
	@IBAction func modeRounded(sender: AnyObject)
	{
		modeRoundedToggle()
	}
	
	func modeRoundedToggle()
	{
		var theDrawView = drawView as DrawView
		
		var modes = ["Rr","Rs"]
		var modesIndex = find(modes, theDrawView.modeRounded)!
		var modeTarget = modesIndex+1
		if modeTarget > modes.count-1{ modeTarget = 0	}
		theDrawView.modeRounded = modes[modeTarget]
	}
	
	@IBAction func modeContinuous(sender: AnyObject) {
		
	}
	
	// MARK: - Misc
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	func UIColorFromRGB(rgbValue: UInt) -> UIColor {
		return UIColor(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}

