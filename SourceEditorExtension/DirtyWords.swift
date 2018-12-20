//
//  DirtyWords.swift
//  SourceEditorExtension
//
//  Created by 杨萧玉 on 2018/12/20.
//  Copyright © 2018 杨萧玉. All rights reserved.
//

import Cocoa

class DirtyWords: NSObject {
    static let shared = DirtyWords()
    private var words = [String]()
    private let lock = NSLock()
    
    private override init() {
        
    }
    
    func list() -> [String] {
        lock.lock()
        let result = words
        lock.unlock()
        return result
    }
    
    func loadList() {
        if let path = Bundle.main.path(forResource: "dirtywords", ofType: nil) {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                lock.lock()
                words = data.components(separatedBy: .newlines).map({ $0.trimmingCharacters(in: .whitespaces) }).filter({ $0.count > 0 })
                lock.unlock()
            } catch {
                print(error)
            }
        }
        //        TODO: load from network
    }
    
}
