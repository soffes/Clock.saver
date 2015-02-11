//
//  ConfigureWindowController.swift
//  Clock
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

let ConfigurationDidChangeNotificationName = "SAMClockConfigurationDidChangeNotification"

class ConfigureWindowController: NSWindowController {
	
	// MARK: - Properties
	
	override var windowNibName: String! {
		return "Configuration"
	}
	
	
	// MARK: - Actions
	
	@IBAction func close(sender: AnyObject) {
		NSApp.endSheet(window!)
	}
}
