//
//  Lines.swift
//  drawSource
//
//  Created by Devine Lu Linvega on 2014-08-14.
//  Copyright (c) 2014 XXIIVV. All rights reserved.
//

import UIKit

class Line {

	var start: CGPoint
	var end: CGPoint
	var color: String
	var modeMirror: String
	var modeGeometric: String
	var modeThick: String
	var modeRounded: String
	var modeGridLarge: String
	
	init( start _start: CGPoint, end _end: CGPoint, color _color: String, modeMirror _modeMirror: String, modeGeometric _modeGeometric: String, modeThick _modeThick: String, modeRounded _modeRounded: String, modeGridLarge _modeGridLarge: String){
		start = _start
		end = _end
		color = _color
		modeMirror = _modeMirror
		modeGeometric = _modeGeometric
		modeThick = _modeThick
		modeRounded = _modeRounded
		modeGridLarge = _modeGridLarge
	}
	
}