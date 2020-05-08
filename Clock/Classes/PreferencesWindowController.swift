import AppKit
import ScreenSaver

final class PreferencesWindowController: NSWindowController {
	
	// MARK: - Properties

	@IBOutlet weak var stylePopUpButton: NSPopUpButton!

	override var windowNibName: NSNib.Name? {
		return "Preferences"
	}

	private let preferences = Preferences()

	// MARK: - NSObject

	override func awakeFromNib() {
		super.awakeFromNib()

		NotificationCenter.default.addObserver(self, selector: #selector(modelDidChange), name: .ModelDidChange,
                                               object: nil)

		stylePopUpButton.removeAllItems()

		let styles = preferences.model.styles
		stylePopUpButton.addItems(withTitles: styles.map({ $0.description }))

		let index = styles.map { $0.rawValue }.firstIndex(of: preferences.styleName) ?? styles.startIndex
		stylePopUpButton.selectItem(at: index)
	}
	
	
	// MARK: - Actions

	@IBAction func selectStyle(_ sender: Any?) {
		preferences.styleName = preferences.model.styles[stylePopUpButton.indexOfSelectedItem].rawValue
	}

	@IBAction func close(_ sender: Any?) {
        guard let window = window else { return }

        if let parent = window.sheetParent {
            parent.endSheet(window)
        } else {
            window.close()
        }
	}

	// MARK: - Private

	@objc private func modelDidChange(_ notification: NSNotification?) {
		stylePopUpButton.removeAllItems()
		stylePopUpButton.addItems(withTitles: preferences.model.styles.map { $0.description })
		
		stylePopUpButton.selectItem(at: 0)
		selectStyle(stylePopUpButton)
	}
}
