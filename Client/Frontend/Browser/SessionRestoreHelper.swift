/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation
import WebKit

protocol SessionRestoreHelperDelegate: class {
    func sessionRestoreHelper(_ helper: SessionRestoreHelper, didRestoreSessionForTab tab: Tab)
}

class SessionRestoreHelper: DelegatingTabHelper {
    weak var delegate: SessionRestoreHelperDelegate?

    required init(tab: Tab, profile: Profile) { }

    required init(tab: Tab, profile: Profile, delegate: AnyObject?) {
        self.tab = tab
        if let delegate = delegate as? SessionRestoreHelperDelegate {
            self.delegate = delegate
        }
    }

    fileprivate weak var tab: Tab?

    func scriptMessageHandlerName() -> String? {
        return "sessionRestoreHelper"
    }

    func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let tab = tab, let params = message.body as? [String: AnyObject] {
            if params["name"] as! String == "didRestoreSession" {
                DispatchQueue.main.async {
                    self.delegate?.sessionRestoreHelper(self, didRestoreSessionForTab: tab)
                }
            }
        }
    }

    class func name() -> String {
        return "SessionRestoreHelper"
    }
}
