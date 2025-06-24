//
//  LoggingManager.swift
//  OneThing
//
//  Created by 오현식 on 6/17/25.
//

import Foundation
import os.log

final class LoggingManager {
    
    private static let logger = OSLog(
        subsystem: Bundle.main.bundleIdentifier ?? "com.clip.onething.log",
        category: "Debug"
    )
    
    private class func message(prefix: String, items: [Any], separator: String) -> String {
        return "\(prefix): " + items.reduce("", { $0.isEmpty ? "\($1)" : "\($0)\(separator)\($1)" })
    }
    
    class func info(_ items: Any..., separator: String = " ") {
        let message = self.message(prefix: "ℹ️ INFO", items: items, separator: separator)
        os_log("%{public}@", log: logger, type: .info, message)
    }
    
    class func debug(_ items: Any..., separator: String = " ") {
        let message = self.message(prefix: "⚠️ DEBUG", items: items, separator: separator)
        os_log("%{public}@", log: logger, type: .debug, message)
    }
    
    class func error(_ items: Any..., separator: String = " ") {
        let message = self.message(prefix: "🚨 ERROR", items: items, separator: separator)
        os_log("%{public}@", log: logger, type: .error, message)
    }
    
    class func request(_ items: Any..., separator: String = " ") {
        let message = self.message(prefix: "🙋🏻 REQUEST", items: items, separator: separator)
        os_log("%{public}@", log: logger, type: .debug, message)
    }
    
    class func response(_ items: Any..., separator: String = " ") {
        let message = self.message(prefix: "🙆🏻 RESPONSE", items: items, separator: separator)
        os_log("%{public}@", log: logger, type: .debug, message)
    }
    
    class func fail(_ items: Any..., separator: String = " ") {
        let message = self.message(prefix: "🙅🏻 FAIL", items: items, separator: separator)
        os_log("%{public}@", log: logger, type: .debug, message)
    }
}
