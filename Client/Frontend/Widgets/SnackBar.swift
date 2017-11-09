/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import SnapKit
import Shared

class SnackBarUX {
    static var MaxWidth: CGFloat = 400
    static let HighlightColor = UIColor(red: 205/255, green: 223/255, blue: 243/255, alpha: 0.9)
    static let HighlightText = UIColor(red: 42/255, green: 121/255, blue: 213/255, alpha: 1.0)
}

/**
 * A specialized version of UIButton for use in SnackBars. These are displayed evenly
 * spaced in the bottom of the bar. The main convenience of these is that you can pass
 * in a callback in the constructor (although these also style themselves appropriately).
 */
typealias SnackBarCallback = (_ bar: SnackBar) -> Void
class SnackButton: UIButton {
    let callback: SnackBarCallback?
    fileprivate var bar: SnackBar!

    override open var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? SnackBarUX.HighlightColor : .clear
        }
    }

    init(title: String, accessibilityIdentifier: String, callback: @escaping SnackBarCallback) {
        self.callback = callback

        super.init(frame: CGRect.zero)

        setTitle(title, for: .normal)
        titleLabel?.font = DynamicFontHelper.defaultHelper.DefaultMediumFont
        setTitleColor(SnackBarUX.HighlightText, for: .highlighted)
        setTitleColor(SettingsUX.TableViewRowTextColor, for: .normal)
        addTarget(self, action: #selector(SnackButton.onClick), for: .touchUpInside)
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func onClick() {
        callback?(bar)
    }

    func drawSeparator() {
        let separator = UIView()
        separator.backgroundColor = UIConstants.BorderColor
        self.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.width.equalTo(0.5)
            make.top.bottom.equalTo(self)
        }
    }

}

class SnackBar: UIView {
    let imageView = UIImageView()
    let textLabel = UILabel()
    let contentView = UIView()
    let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let buttonsView = UIStackView()

    // The Constraint for the bottom of this snackbar. We use this to transition it
    var bottom: Constraint?

    init(text: String, img: UIImage?) {
        super.init(frame: CGRect.zero)

        imageView.image = img
        textLabel.text = text
        setup()
    }

    fileprivate func setup() {
        textLabel.backgroundColor = nil
        buttonsView.distribution = .fillEqually

        addSubview(backgroundView)
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(textLabel)

        let separator = UIView()
        separator.backgroundColor = UIConstants.BorderColor
        contentView.addSubview(separator)
        addSubview(buttonsView)

        separator.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(0.5)
            make.top.equalTo(buttonsView.snp.top)
        }

        backgroundColor = UIColor.clear
        imageView.contentMode = UIViewContentMode.left

        textLabel.font = DynamicFontHelper.defaultHelper.DefaultMediumFont
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.textColor = SettingsUX.TableViewRowTextColor
        textLabel.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageWidth: CGFloat
        if let img = imageView.image {
            imageWidth = img.size.width + UIConstants.DefaultPadding * 2
        } else {
            imageWidth = 0
        }
        self.textLabel.preferredMaxLayoutWidth = contentView.frame.width - (imageWidth + UIConstants.DefaultPadding)
        super.layoutSubviews()
    }

    fileprivate func drawLine(_ context: CGContext, start: CGPoint, end: CGPoint) {
        context.setStrokeColor(UIConstants.BorderColor.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: start.x, y: start.y))
        context.addLine(to: CGPoint(x: end.x, y: end.y))
        context.strokePath()
    }

    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            drawLine(context, start: CGPoint(x: 0, y: 1), end: CGPoint(x: frame.size.width, y: 1))
        }
    }

    /**
     * Called to check if the snackbar should be removed or not. By default, Snackbars persist forever.
     * Override this class or use a class like CountdownSnackbar if you want things expire
     * - returns: true if the snackbar should be kept alive
     */
    func shouldPersist(_ tab: Tab) -> Bool {
        return true
    }

    override func updateConstraints() {
        super.updateConstraints()

        backgroundView.snp.remakeConstraints { make in
            make.bottom.left.right.equalTo(self)
            // Offset it by the width of the top border line so we can see the line from the super view
            make.top.equalTo(self).offset(1)
        }

        contentView.snp.remakeConstraints { make in
            make.top.left.right.equalTo(self).inset(UIEdgeInsets(equalInset: UIConstants.DefaultPadding))
        }

        if let img = imageView.image {
            imageView.snp.remakeConstraints { make in
                make.left.centerY.equalTo(contentView)
                // To avoid doubling the padding, the textview doesn't have an inset on its left side.
                // Instead, it relies on the imageView to tell it where its left side should be.
                make.width.equalTo(img.size.width + UIConstants.DefaultPadding)
                make.height.equalTo(img.size.height + UIConstants.DefaultPadding)
            }
        } else {
            imageView.snp.remakeConstraints { make in
                make.width.height.equalTo(0)
                make.top.left.equalTo(self)
                make.bottom.lessThanOrEqualTo(contentView.snp.bottom)
            }
        }

        textLabel.snp.remakeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(self.imageView.snp.right)
            make.trailing.equalTo(contentView)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom)
        }

        buttonsView.snp.remakeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(UIConstants.DefaultPadding)
            make.bottom.equalTo(self.snp.bottom)
            make.leading.trailing.equalTo(self)
            if self.buttonsView.subviews.count > 0 {
                make.height.equalTo(UIConstants.SnackbarButtonHeight)
            } else {
                make.height.equalTo(0)
            }
        }
    }

    var showing: Bool {
        return alpha != 0 && self.superview != nil
    }

    func show() {
        alpha = 1
        bottom?.update(offset: 0)
    }

    func addButton(_ snackButton: SnackButton) {
        snackButton.bar = self
        buttonsView.addArrangedSubview(snackButton)

        // Only show the separator on the left of the button if it is not the first view
        if buttonsView.arrangedSubviews.count != 1 {
            snackButton.drawSeparator()
        }
    }
}

/**
 * A special version of a snackbar that persists for at least a timeout. After that
 * it will dismiss itself on the next page load where this tab isn't showing. As long as
 * you stay on the current tab though, it will persist until you interact with it.
 */
class TimerSnackBar: SnackBar {
    fileprivate var timer: Timer?
    fileprivate var timeout: TimeInterval

    init(timeout: TimeInterval = 10, text: String, img: UIImage?) {
        self.timeout = timeout
        super.init(text: text, img: img)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func showAppStoreConfirmationBar(forTab tab: Tab, appStoreURL: URL) {
        let bar = TimerSnackBar(text: Strings.ExternalLinkAppStoreConfirmationTitle, img: UIImage(named: "defaultFavicon"))
        let openAppStore = SnackButton(title: Strings.OKString, accessibilityIdentifier: "ConfirmOpenInAppStore") { bar in
            tab.removeSnackbar(bar)
            UIApplication.shared.openURL(appStoreURL)
        }
        let cancelButton = SnackButton(title: Strings.CancelString, accessibilityIdentifier: "CancelOpenInAppStore") { bar in
            tab.removeSnackbar(bar)
        }
        bar.addButton(openAppStore)
        bar.addButton(cancelButton)
        tab.addSnackbar(bar)
    }
    
    override func show() {
        self.timer = Timer(timeInterval: timeout, target: self, selector: #selector(TimerSnackBar.timerDone), userInfo: nil, repeats: false)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
        super.show()
    }

    @objc func timerDone() {
        self.timer = nil
    }

    override func shouldPersist(_ tab: Tab) -> Bool {
        if !showing {
            return timer != nil
        }
        return super.shouldPersist(tab)
    }
}
