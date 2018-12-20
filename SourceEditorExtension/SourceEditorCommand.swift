//
//  SourceEditorCommand.swift
//  SourceEditorExtension
//
//  Created by 杨萧玉 on 2018/12/20.
//  Copyright © 2018 杨萧玉. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        let dirtyWords = DirtyWords.shared.list()
        for (index, line) in invocation.buffer.lines.enumerated() {
            guard var code = line as? String else {
                continue
            }
            for word in dirtyWords {
                code = code.replacingOccurrences(of: word, with: "<#T##\(word)#>", options: [.literal, .caseInsensitive], range: nil)
            }
            invocation.buffer.lines[index] = code
        }
        completionHandler(nil)
    }
    
}
