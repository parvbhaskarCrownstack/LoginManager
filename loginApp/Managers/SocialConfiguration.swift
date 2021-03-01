
import UIKit

class SocialConfiguration: NSObject {
    var isConfigured: Bool! = false
    var clientId: String!

    fileprivate var scope: [String]!
    var permissions: [String]! {
        get {
            return scope
        }
        set {
            scope = newValue
        }
    }

    init(client_ID: String, scope: [String]) {
        super.init()
        clientId = client_ID
        permissions = scope
    }
}
