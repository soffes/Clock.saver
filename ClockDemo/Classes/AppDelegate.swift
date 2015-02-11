//
//  AppDelegate.swift
//  Clock
//
//  Created by Sam Soffes on 7/15/14.
//  Copyright (c) 2014 Sam Soffes. All rights reserved.
//

import Cocoa
import ScreenSaver

@NSApplicationMain
class AppDelegate: NSObject {
	
	// MARK: - Properties

	@IBOutlet var window: NSWindow!
	
	let clockView: ScreenSaverView = {
		let view = ClockView()
		view.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable
		return view
	}()
	
	
	// MARK: - Actions
	
	@IBAction func showConfiguration(sender: NSObject!) {
		NSApp.beginSheet(clockView.configureSheet(), modalForWindow: window, modalDelegate: self, didEndSelector: "endSheet:", contextInfo: nil)
	}
	
	
	// MARK: - Private
	
	func endSheet(sheet: NSWindow) {
		sheet.close()
	}
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(notification: NSNotification) {
		// Add the clock view to the window
		clockView.frame = window.contentView.bounds
		window.contentView.addSubview(clockView)
		
		// Start animating the clock
		clockView.startAnimation()
		NSTimer.scheduledTimerWithTimeInterval(clockView.animationTimeInterval(), target: clockView, selector: "animateOneFrame", userInfo: nil, repeats: true)
	}
}


extension AppDelegate: NSWindowDelegate {
	func windowWillClose(notification: NSNotification) {
		// Quit the app if the main window is closed
		NSApplication.sharedApplication().terminate(window)
	}
}
