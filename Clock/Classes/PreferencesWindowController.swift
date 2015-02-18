//
//  PreferencesWindowController.swift
//  Clock.saver
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

class PreferencesWindowController: NSWindowController {
	
	// MARK: - Properties
	
	override var windowNibName: String! {
		return "Preferences"
	}
	
	
	// MARK: - Actions
	
	@IBAction func close(sender: AnyObject) {
		NSApp.endSheet(window!)
	}
}
