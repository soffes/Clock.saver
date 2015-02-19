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

	@IBOutlet weak var stylePopUpButton: NSPopUpButton!


	override var windowNibName: String! {
		return "Preferences"
	}

	private let preferences = Preferences()


	// MARK: - Initializers

	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}


	// MARK: - NSObject

	override func awakeFromNib() {
		super.awakeFromNib()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: "modelDidChange:", name: ModelDidChangeNotificationName, object: nil)
		modelDidChange(nil)
	}
	
	
	// MARK: - Actions

	@IBAction func selectStyle(sender: AnyObject?) {
		preferences.styleName = preferences.model.styles[stylePopUpButton.indexOfSelectedItem].rawValue
	}

	@IBAction func close(sender: AnyObject?) {
		NSApp.endSheet(window!)
	}


	// MARK: - Private

	func modelDidChange(notification: NSNotification?) {
		stylePopUpButton.removeAllItems()
		stylePopUpButton.addItemsWithTitles(preferences.model.styles.map({ $0.description }))
		
		stylePopUpButton.selectItemAtIndex(0)
		selectStyle(stylePopUpButton)
	}
}
