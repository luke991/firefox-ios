/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import Shared
import WebKit

protocol FindInPageHelperDelegate: class {
    func findInPageHelper(_ findInPageHelper: FindInPageHelper, didUpdateCurrentResult currentResult: Int)
    func findInPageHelper(_ findInPageHelper: FindInPageHelper, didUpdateTotalResults totalResults: Int)
}

class FindInPageHelper: DelegatingTabHelper {
    weak var delegate: FindInPageHelperDelegate?
    fileprivate weak var tab: Tab?

    class func name() -> String {
        return "FindInPage"
    }

    required init(tab: Tab, profile: Profile) { }

    required init(tab: Tab, profile: Profile, delegate: AnyObject?) {
        self.tab = tab

        if let delegate = delegate as? FindInPageHelperDelegate {
            self.delegate = delegate
        }

        if let path = Bundle.main.path(forResource: "FindInPage", ofType: "js"), let source = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String {
            let userScript = WKUserScript(source: source, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
            tab.webView!.configuration.userContentController.addUserScript(userScript)
        }
    }

    func scriptMessageHandlerName() -> String? {
        return "findInPageHandler"
    }

    func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let data = message.body as! [String: Int]

        if let currentResult = data["currentResult"] {
            delegate?.findInPageHelper(self, didUpdateCurrentResult: currentResult)
        }

        if let totalResults = data["totalResults"] {
            delegate?.findInPageHelper(self, didUpdateTotalResults: totalResults)
        }
    }
}
