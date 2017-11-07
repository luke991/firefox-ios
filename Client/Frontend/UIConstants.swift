/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Shared

// A browser color represents the color of UI in both Private browsing mode and normal mode
struct BrowserColor {
    let normalColor: Int
    let PBMColor: Int
    init(normal: Int, pbm: Int) {
        self.normalColor = normal
        self.PBMColor = pbm
    }

    func color(isPBM: Bool) -> UIColor {
        return UIColor(rgb: isPBM ? PBMColor : normalColor)
    }

    func colorFor(_ theme: Theme) -> UIColor {
        return color(isPBM: theme == .Private)
    }

}

extension UIColor {
    struct Browser
    {
        static let Background = BrowserColor(normal: 0xf9f9fa, pbm: 0x38383D)
        static let Text = BrowserColor(normal: 0xffffff, pbm: 0x414146)
        static let URLBarDivider = BrowserColor(normal: 0xE4E4E4, pbm: 0x414146)
        static let LocationBarBackground = UIColor(rgb: 0xD7D7DB)
        static let Tint = BrowserColor(normal: 0x272727, pbm: 0xD2D2D4)
    }

    // These are defaults from http://design.firefox.com/photon/visuals/color.html
    struct Defaults {
        static let Grey10 = UIColor(rgb: 0xf9f9fa)
        static let Grey40 = UIColor(rgb: 0xb1b1b3)
        static let Grey50 = UIColor(rgb: 0x737373)
        static let Grey60 = UIColor(rgb: 0x4a4a4f)
        static let Grey70 = UIColor(rgb: 0x38383d)
        static let Grey80 = UIColor(rgb: 0x272727) // Grey80 is actually #2a2a2e
        static let Grey90 = UIColor(rgb: 0x0c0c0d)

        static let LockGreen = UIColor(rgb: 0x16DA00) //need a photon green?

        static let Blue40 = UIColor(rgb: 0x45a1ff)
        static let Blue50 = UIColor(rgb: 0x0a84ff)
        static let Blue60 = UIColor(rgb: 0x0066DC) // Blue60 is actually #0060df

        static let Purple50 = UIColor(rgb: 0x9400ff)
    }

    struct URLBar {
        static let Border = BrowserColor(normal: 0x737373, pbm: 0x2D2D31)
        static let ActiveBorder = BrowserColor(normal: 0xB0D5FB, pbm: 0x4a4a4f)
        static let Tint = BrowserColor(normal: 0x00dcfc, pbm: 0xf9f9fa)
    }

    struct TextField {
        static let Background = BrowserColor(normal: 0xffffff, pbm: 0x636369)
        static let TextAndTint = BrowserColor(normal: 0x272727, pbm: 0xffffff)
        static let Highlight = BrowserColor(normal: 0xccdded, pbm: 0x7878a5)
        static let ReaderModeButtonSelected = BrowserColor(normal: 0x00A2FE, pbm: 0xcf68ff)
        static let ReaderModeButtonUnselected = BrowserColor(normal: 0x737373, pbm: 0xADADb0)
        static let PageOptionsSelected = BrowserColor(normal: 0x00A2FE, pbm: 0xcf68ff)
        static let PageOptionsUnselected = UIColor.Browser.Tint
        static let Separator = BrowserColor(normal: 0xE5E5E5, pbm: 0x3f3f43)
    }

    // The back/forward/refresh/menu button (bottom toolbar)
    struct ToolbarButton {
        static let SelectedTint = BrowserColor(normal: 0x00A2FE, pbm: 0xAC39FF)
        static let DisabledTint = BrowserColor(normal: 0x55, pbm: 0x0) //wrong
    }

    struct LoadingBar {
        static let Start = BrowserColor(normal: 0x00DCFC, pbm: 0x9400ff)
        static let End = BrowserColor(normal: 0x0A84FF, pbm: 0xff1ad9)
    }

    struct TabTray {
        static let Background = BrowserColor(normal: 0xf9f9fa, pbm: 0x4a4a4a)
    }

    struct TopTabs {
        static let PrivateModeTint = BrowserColor(normal: 0xf9f9fa, pbm: 0xb1b1b3)
        static let Background = UIColor.Defaults.Grey80
    }

    struct HomePanel {
        // These values are the same for both private/normal.
        // The homepanel toolbar needed to be able to theme, not anymore.
        // Keep this just in case someone decides they want it to theme again
        static let ToolbarBackground = BrowserColor(normal: 0xf9f9fa, pbm: 0xf9f9fa)
        static let ToolbarHighlight = BrowserColor(normal: 0x4c9eff, pbm: 0x4c9eff)
        static let ToolbarTint = BrowserColor(normal: 0x7e7e7f, pbm: 0x7e7e7f)
    }
}

public struct UIConstants {
    static let AboutHomePage = URL(string: "\(WebServer.sharedInstance.base)/about/home/")!

    // Toolbars
    static let TopToolbarHeight: CGFloat = 56
    static var ToolbarHeight: CGFloat = 46
    static var BottomToolbarHeight: CGFloat {
        get {
            var bottomInset: CGFloat = 0.0
            if #available(iOS 11, *) {
                if let window = UIApplication.shared.keyWindow {
                    bottomInset = window.safeAreaInsets.bottom
                }
            }
            return ToolbarHeight + bottomInset
        }
    }

    static let DefaultPadding: CGFloat = 10
    static let SnackbarButtonHeight: CGFloat = 48

    static let AppBackgroundColor = UIColor.Defaults.Grey10
    static let SystemBlueColor = UIColor.Defaults.Blue50
    static let ControlTintColor = UIColor.Defaults.Blue50
    static let PasscodeDotColor = UIColor.Defaults.Grey60
    static let PrivateModeAssistantToolbarBackgroundColor = UIColor.Defaults.Grey50
    static let PrivateModeTextHighlightColor = UIColor.Defaults.Purple50
    static let PrivateModePurple = UIColor(rgb: 0xcf68ff)

    // Static fonts
    static let DefaultChromeSize: CGFloat = 16
    static let DefaultChromeSmallSize: CGFloat = 11
    static let PasscodeEntryFontSize: CGFloat = 36
    static let DefaultChromeFont: UIFont = UIFont.systemFont(ofSize: DefaultChromeSize, weight: UIFontWeightRegular)
    static let DefaultChromeSmallFontBold = UIFont.boldSystemFont(ofSize: DefaultChromeSmallSize)
    static let PasscodeEntryFont = UIFont.systemFont(ofSize: PasscodeEntryFontSize, weight: UIFontWeightBold)

    static let PanelBackgroundColor = UIColor.white
    static let SeparatorColor = UIColor(rgb: 0xcccccc)
    static let HighlightBlue = UIColor(red: 76/255, green: 158/255, blue: 255/255, alpha: 1)
    static let DestructiveRed = UIColor(red: 255/255, green: 64/255, blue: 0/255, alpha: 1.0)
    static let BorderColor = UIColor.darkGray
    static let BackgroundColor = AppBackgroundColor

    // settings
    static let TableViewHeaderBackgroundColor = AppBackgroundColor
    static let TableViewHeaderTextColor = UIColor.Defaults.Grey50
    static let TableViewRowTextColor = UIColor.Defaults.Grey90
    static let TableViewDisabledRowTextColor = UIColor.lightGray
    static let TableViewSeparatorColor = UIColor(rgb: 0xD1D1D4)
    static let TableViewHeaderFooterHeight = CGFloat(44)
    static let TableViewRowErrorTextColor = UIColor(red: 255/255, green: 0/255, blue: 26/255, alpha: 1.0)
    static let TableViewRowWarningTextColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1.0)
    static let TableViewRowActionAccessoryColor = UIColor(red: 0.29, green: 0.56, blue: 0.89, alpha: 1.0)
    static let TableViewRowSyncTextColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)

    // List of Default colors to use for Favicon backgrounds
    static let DefaultColorStrings = ["2e761a", "399320", "40a624", "57bd35", "70cf5b", "90e07f", "b1eea5", "881606", "aa1b08", "c21f09", "d92215", "ee4b36", "f67964", "ffa792", "025295", "0568ba", "0675d3", "0996f8", "2ea3ff", "61b4ff", "95cdff", "00736f", "01908b", "01a39d", "01bdad", "27d9d2", "58e7e6", "89f4f5", "c84510", "e35b0f", "f77100", "ff9216", "ffad2e", "ffc446", "ffdf81", "911a2e", "b7223b", "cf2743", "ea385e", "fa526e", "ff7a8d", "ffa7b3" ]

    /// JPEG compression quality for persisted screenshots. Must be between 0-1.
    static let ScreenshotQuality: Float = 0.3
    static let ActiveScreenshotQuality: CGFloat = 0.5

    // Warning - Move these to Strings.swift
    static let OKString = NSLocalizedString("OK", comment: "OK button")
    static let CancelString = NSLocalizedString("Cancel", comment: "Label for Cancel button")
}
