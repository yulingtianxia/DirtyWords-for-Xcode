//
//  SourceEditorExtension.swift
//  SourceEditorExtension
//
//  Created by 杨萧玉 on 2018/12/20.
//  Copyright © 2018 杨萧玉. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    func extensionDidFinishLaunching() {
        DirtyWords.shared.loadList()
    }
    
    /*
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return []
    }
    */
    
    
}
