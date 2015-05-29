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
var selectionView:UIView!

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
			"rounding":["round","square","none"],
			"color":["black","red","cyan","white","chess"],
			"system":["share","save","clear"],
			"filter":[""]
		]
		
		// Set default settings
		for categories in menus {
			settings[categories.0] = categories.1[0]
		}
		
		optionsCollapse()
		
		templateStart()
		loadMenu()
		
		var theDrawView = drawView as DrawView
		theDrawView.modeMirror = settings["mirror"]!
		theDrawView.modeMirror = settings["grid"]!
		theDrawView.modeMirror = settings["thickness"]!
		theDrawView.modeMirror = settings["rounding"]!
		theDrawView.modeColor = settings["color"]!
		theDrawView.setNeedsDisplay()
		
	}
	
	// MARK: Menu -
	
	func updateSelectionMenu(iconTag:Int, iconString:String)
	{
		println("$ SELCT | Updating view #\(iconTag) -> \(iconString)")
		for iconView in selectionView.subviews {
			if iconView.tag != iconTag { continue }
			var iconView = iconView as! UIImageView
			iconView.image = UIImage(named: iconString)
		}
	}
	
	func createSelectionMenu()
	{
		selectionView = UIView(frame: CGRectMake(0, screenHeight-tileSize, tileSize*7, tileSize))
		
		var col:CGFloat = 0
		for categories in menus {
			
			if categories.0 == "rounding" { col = 4 }
			
			if categories.0 != "system" && categories.0 != "filter" {
				
				// Icon
				let iconView = UIImageView(frame: CGRectMake(tileSize*col, 0, tileSize, tileSize))
				let iconString = String(format: "%@.%@", categories.0, settings[categories.0]!)
				
				iconView.image = UIImage(named: iconString)
				iconView.contentMode = UIViewContentMode.ScaleAspectFit
				iconView.tag = 590 + Int(col)
				selectionView.addSubview(iconView)
				
			}
			
			
			
			col++
		}
		
		self.view.addSubview(selectionView)
		
	}
	
	func loadMenu()
	{
		var col:CGFloat = 0
		for categories in menus {
			let menuHeight:CGFloat = CGFloat(categories.1.count + 1) * tileSize
			
			if categories.0 == "rounding" { col = 4 }
			if categories.0 == "system" { col = 7 }
			if categories.0 == "filter" { col = 5 }
			
			let menuView = UIView(frame: CGRectMake(tileSize*col, screenHeight-menuHeight, tileSize, menuHeight))
			menuView.tag = 66
			var row:CGFloat = 0
			for option in categories.1 {
				
				// Icon
				let iconView = UIImageView(frame: CGRectMake(0, tileSize*row, tileSize, tileSize))
				let iconString = String(format: "%@.%@", categories.0, option)
				
				iconView.image = UIImage(named: iconString)
				iconView.contentMode = UIViewContentMode.ScaleAspectFit
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
		
		createSelectionMenu()
		
		// Collapse/Expand menu
		
		let iconView = UIImageView(frame: CGRectMake(screenWidth-tileSize, screenHeight-tileSize, tileSize, tileSize))
		iconView.image = UIImage(named: "toggle.expand")
		iconView.contentMode = UIViewContentMode.ScaleAspectFit
		iconView.tag = 977
		self.view.addSubview(iconView)
		
		let toggleButton   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
		toggleButton.frame = CGRectMake(0, screenHeight-tileSize, screenWidth, tileSize)
		toggleButton.addTarget(self, action: Selector("toggleMenu"), forControlEvents: UIControlEvents.TouchUpInside)
		self.view.addSubview(toggleButton)
		
	}
	
	func optionUnselect(targetTag:Int)
	{
		for targetView in self.view.subviews {
			for button in targetView.subviews {
				if button.tag == targetTag {
					let targetButton:UIButton = button as! UIButton
					targetButton.alpha = 0.5
				}
			}
		}
	}
	
	
	func optionThickness(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["thickness"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeThick = settings["thickness"]!
		
		updateSelectionMenu(592, iconString: String(format:"thickness.%@", sender.currentTitle!) )
	}
	
	func optionSystem(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["system"] = sender.currentTitle
		
		if( sender.currentTitle == "clear" ){
			let colours = [UIColorFromRGB(0xff0000).CGColor,UIColorFromRGB(0xefefef).CGColor,UIColorFromRGB(0xdddddd).CGColor,UIColorFromRGB(0x999999).CGColor]
			let randomIndex = Int(arc4random_uniform(UInt32(colours.count)))
			self.outputView.backgroundColor = UIColor(CGColor: colours[randomIndex])
			var theDrawView = drawView as DrawView
			theDrawView.lines = []
			renderView.image = UIImage(named: "")
			theDrawView.setNeedsDisplay()
		}
		
	}
	
	func optionFilter(sender:UIButton!)
	{
	}
	
	func optionColor(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["color"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeColor = settings["color"]!
		theDrawView.setNeedsDisplay()
		
		updateSelectionMenu(593, iconString: String(format:"color.%@", sender.currentTitle!) )
	}
	
	func optionRounding(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["rounding"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeRounded = settings["rounding"]!
		
		updateSelectionMenu(594, iconString: String(format:"rounding.%@", sender.currentTitle!) )
	}
	
	func optionGrid(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["grid"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeGeometric = settings["grid"]!
	
		updateSelectionMenu(590, iconString: String(format:"grid.%@", sender.currentTitle!) )
	}
	
	func optionMirror(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["mirroir"] = sender.currentTitle
		
		var theDrawView = drawView as DrawView
		theDrawView.modeMirror = settings["mirroir"]!
		
		updateSelectionMenu(591, iconString: String(format:"mirror.%@", sender.currentTitle!) )
	}
	
	// MARK: Toggle -
	
	func toggleMenu()
	{
		if( settings["menu"] == "collapsed" ){
			optionsExpand()
		}
		else{
			optionsCollapse()
		}
	}
	
	func optionsCollapse()
	{
		settings["menu"] = "collapsed"
		for targetView in self.view.subviews {
			// Icon
			if targetView.tag == 977 {
				var iconView = targetView as! UIImageView
				iconView.image = UIImage(named: "toggle.collapse")
			}
			// Options
			if targetView.tag == 66 {
				let targetView = targetView as! UIView
				targetView.hidden = true
			}
		}
	}
	
	func optionsExpand()
	{
		settings["menu"] = "expanded"
		for targetView in self.view.subviews {
			// Icon
			if targetView.tag == 977 {
				var iconView = targetView as! UIImageView
				iconView.image = UIImage(named: "toggle.expand")
			}
			// Options
			if targetView.tag == 66 {
				let targetView = targetView as! UIView
				targetView.hidden = false
			}
		}
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
		
		renderView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		outputView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		theDrawView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
		
	}
	
	@IBAction func optionSave(sender: AnyObject)
	{
		UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.width, self.view.frame.height))
		outputView.layer.renderInContext(UIGraphicsGetCurrentContext())
		let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
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

