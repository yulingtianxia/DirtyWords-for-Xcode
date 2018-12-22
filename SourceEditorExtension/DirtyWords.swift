//
//  DirtyWords.swift
//  SourceEditorExtension
//
//  Created by 杨萧玉 on 2018/12/20.
//  Copyright © 2018 杨萧玉. All rights reserved.
//

import Cocoa

class DirtyWords {
    static let shared = DirtyWords()
    private var words = [String]()
    private let lock = NSLock()
    private let fileName = "dirtywords"
    
    private init() {
        
    }
    
    func list() -> [String] {
        lock.lock()
        let result = words
        lock.unlock()
        return result
    }
    
    func load() {
        do {
            var dirtyWordsFileURL: URL? = nil
            
//            if let fileURL = remoteDirtyWordsFileStoreURL() {
//                if FileManager.default.fileExists(atPath: fileURL.path) {
//                    dirtyWordsFileURL = fileURL
//                }
//            }
            if dirtyWordsFileURL == nil, let fileURL = localDirtyWordsFileURL() {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    dirtyWordsFileURL = fileURL
                }
            }
            guard let url = dirtyWordsFileURL else {
                print("dirtyWordsFileURL is nil")
                return
            }
            try loadDirtyWords(fromFileURL: url)
            
        } catch {
            print(error.localizedDescription)
        }
        
//        downloadDirtyWordsFile()
    }
    
    func loadDirtyWords(fromFileURL url: URL) throws {
        let data = try String(contentsOf: url, encoding: .utf8)
        lock.lock()
        words = data.components(separatedBy: .newlines).map({ $0.trimmingCharacters(in: .whitespaces) }).filter({ $0.count > 0 })
        for word in words {
            var valid = true
            for w in words {
                if w != word && word.contains(w) {
                    valid = false
                }
            }
            if valid {
                print(word)
            }
        }
        lock.unlock()
    }
    
    func downloadDirtyWordsFile() {
        guard let url = URL(string: "https://raw.githubusercontent.com/yulingtianxia/DirtyWords-for-Xcode/master/SourceEditorExtension/dirtywords") else {
            print("load dirty word url error.")
            return
        }
        let task = URLSession.shared.downloadTask(with: url) { (localURL, response, error) in
            if let error = error {
                print("download dirty words file error. \(error.localizedDescription)")
                return
            }
            guard let sourceURL = localURL else {
                print("download dirty words file localURL is nil.")
                return
            }
            guard let targetURL = self.remoteDirtyWordsFileStoreURL() else {
                print("remote dirty words file store URL is nil.")
                return
            }
            do {
                if FileManager.default.fileExists(atPath: targetURL.path) {
                    try FileManager.default.removeItem(at: targetURL)
                }
                try FileManager.default.moveItem(at: sourceURL, to: targetURL)
                try self.loadDirtyWords(fromFileURL: targetURL)
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        task.resume()
    }
    
    func remoteDirtyWordsFileStoreURL() -> URL? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            return fileURL
        }
        return nil
    }
    
    func localDirtyWordsFileURL() -> URL? {
        if let fileURL = Bundle.main.url(forResource: fileName, withExtension: nil) {
            return fileURL
        }
        return nil
    }
    
}
