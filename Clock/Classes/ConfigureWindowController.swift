//
//  ConfigureWindowController.swift
//  Clock
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

class ConfigureWindowController: NSWindowController {
	
	// MARK: - Properties

	@IBOutlet var faceStylePicker: NSPopUpButton!
	@IBOutlet var backgroundStylePicker: NSPopUpButton!
	@IBOutlet var tickMarksCheckbox: NSButton!
	@IBOutlet var numbersCheckbox: NSButton!
	@IBOutlet var dateCheckbox: NSButton!
	@IBOutlet var logoCheckbox: NSButton!
	
	var defaults: ScreenSaverDefaults {
		return ScreenSaverDefaults.defaultsForModuleWithName(BundleIdentifier) as ScreenSaverDefaults
	}
	
	override var windowNibName: String! {
		return "Configuration"
	}
	
	
	// MARK: - NSObject
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		faceStylePicker.selectItemAtIndex(defaults.integerForKey(ClockStyleDefaultsKey))
		backgroundStylePicker.selectItemAtIndex(defaults.integerForKey(BackgroundStyleDefaultsKey))
		tickMarksCheckbox.state = defaults.integerForKey(TickMarksDefaultsKey)
		numbersCheckbox.state = defaults.integerForKey(NumbersDefaultsKey)
		dateCheckbox.state = defaults.integerForKey(DateDefaultsKey)
		logoCheckbox.state = defaults.integerForKey(LogoDefaultsKey)
	}
	
	
	// MARK: - Actions
	
	@IBAction func close(sender: AnyObject) {
		NSApp.endSheet(window)
	}
	
	@IBAction func popUpChanged(sender: NSPopUpButton) {
		defaults.setInteger(sender.indexOfSelectedItem, forKey: defaultsKeyForControl(sender))
		didChange()
	}
	
	@IBAction func checkboxChanged(sender: NSButton) {
		defaults.setBool(sender.state == 1, forKey: defaultsKeyForControl(sender))
		didChange()
	}
	
	
	// MARK: - Private
	
	func defaultsKeyForControl(control: NSControl) -> String {
		let keys = [ClockStyleDefaultsKey, BackgroundStyleDefaultsKey, TickMarksDefaultsKey, NumbersDefaultsKey,
			DateDefaultsKey, LogoDefaultsKey]
		return keys[control.tag]
	}
	
	func didChange() {
		defaults.synchronize()
		NSNotificationCenter.defaultCenter().postNotificationName(ConfigurationDidChangeNotificationName, object: nil)
	}
}
