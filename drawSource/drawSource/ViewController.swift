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
			"system":["save","clear","share"],
			"filter":["glitch","sorter"]
		]
		
		// Set default settings
		for categories in menus {
			settings[categories.0] = categories.1[0]
		}
		
		templateStart()
		loadMenu()
		
		var theDrawView = drawView as DrawView
		theDrawView.modeMirror = settings["mirror"]!
		theDrawView.modeMirror = settings["grid"]!
		theDrawView.modeMirror = settings["thickness"]!
		theDrawView.modeMirror = settings["rounding"]!
		theDrawView.modeColor = settings["color"]!
		theDrawView.setNeedsDisplay()
		
		createSelectionMenu()
		
	}
	
	// MARK: Menu -
	
	func updateSelectionMenu(iconTag:Int)
	{
	}
	
	func createSelectionMenu()
	{
		selectionView = UIView(frame: CGRectMake(0, screenHeight-tileSize, tileSize*7, tileSize))
		selectionView.backgroundColor = UIColor.redColor()
		
		var col:CGFloat = 0
		for categories in menus {
			
			var row:CGFloat = 0
			
			// Icon
			let iconView = UIImageView(frame: CGRectMake(tileSize*col, 0, tileSize, tileSize))
			let iconString = String(format: "%@.%@", categories.0, settings[categories.0]!)
			
			iconView.image = UIImage(named: iconString)
			iconView.contentMode = UIViewContentMode.ScaleAspectFit
			iconView.backgroundColor = UIColor.yellowColor()
			iconView.tag = 590 + Int(col)
			selectionView.addSubview(iconView)
			
			col++
		}
		
		self.view.addSubview(selectionView)
		
	}
	
	func loadMenu()
	{
		var col:CGFloat = 0
		for categories in menus {
			let menuHeight:CGFloat = CGFloat(categories.1.count + 1) * tileSize
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
	
	func optionsHide()
	{
		
	}
	
	func optionThickness(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["thickness"] = sender.currentTitle
		optionsHide()
		
		var theDrawView = drawView as DrawView
		theDrawView.modeThick = settings["thickness"]!
	}
	
	func optionSystem(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["system"] = sender.currentTitle
		optionsHide()
		
		if( sender.currentTitle == "clear" ){
			let randomColour = Int(arc4random_uniform(5))
			let colours = [UIColorFromRGB(0x72dec2).CGColor,UIColorFromRGB(0xff0000).CGColor,UIColorFromRGB(0x222222).CGColor,UIColorFromRGB(0xffffff).CGColor,UIColorFromRGB(0xdddddd).CGColor,UIColorFromRGB(0x999999).CGColor]
			let randomIndex = Int(arc4random_uniform(UInt32(colours.count)))
			self.outputView.backgroundColor = UIColor(CGColor: colours[randomIndex])
			var theDrawView = drawView as DrawView
			theDrawView.lines = []
			renderView.image = UIImage(named: "")
			theDrawView.setNeedsDisplay()
		}
	}
	
	func optionColor(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["color"] = sender.currentTitle
		optionsHide()
		
		var theDrawView = drawView as DrawView
		theDrawView.modeColor = settings["color"]!
		theDrawView.setNeedsDisplay()
	}
	
	func optionRounding(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["rounding"] = sender.currentTitle
		optionsHide()
		
		var theDrawView = drawView as DrawView
		theDrawView.modeRounded = settings["rounding"]!
	}
	
	func optionGrid(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["grid"] = sender.currentTitle
		optionsHide()
		
		var theDrawView = drawView as DrawView
		theDrawView.modeGeometric = settings["grid"]!
		updateSelectionMenu(590)
	}
	
	func optionMirror(sender:UIButton!)
	{
		optionUnselect(sender.tag)
		settings["mirroir"] = sender.currentTitle
		optionsHide()
		
		var theDrawView = drawView as DrawView
		theDrawView.modeMirror = settings["mirroir"]!
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

