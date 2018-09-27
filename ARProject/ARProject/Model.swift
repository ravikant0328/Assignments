//
//  Model.swift
//  ARProject
//
//  Created by Ravi on 25/09/18.
//  Copyright © 2018 Ravi. All rights reserved.
//

import Foundation
import AFNetworking
import FirebaseDatabase

final class Model {
    
    func download(filename: String) {
        findURL(name: filename) { modelURL, textureURL in
            if(!modelURL.isEmpty) && (!textureURL.isEmpty) {
                print("URL Found")
                print(modelURL)
                self.downloadModel(path: modelURL, completion: { filepath in
                    if !filepath.isEmpty {
                        print ("SCN Model Downloaded")
                    }
                })
                self.downloadModel(path: textureURL, completion: { filepath in
                    if !filepath.isEmpty {
                        print ("Texture Downloaded")
                    }
                })
            }
        }
    }
    
    func findURL(name: String, completion: @escaping (String, String) -> Void) {
        var ref = Database.database().reference()
        ref = ref.child("Objects").child(name)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            //print(snapshot.value)
            guard let modelurl = snapshot.childSnapshot(forPath: "model").value else { return }
                print(modelurl)
            guard let textureurl = snapshot.childSnapshot(forPath: "texture").value else { return }
                print(textureurl)
            if let model = modelurl as? String {
                if let texture = textureurl as? String {
                   completion(model, texture)
                   print("Hello")
                }
            }
        })
    }
    
    func downloadModel(path: String, completion: @escaping (String) -> Void) {
        
        let configuration = URLSessionConfiguration.default
        let manager = AFURLSessionManager(sessionConfiguration: configuration)
        let url = URL(string: path)
        var request: URLRequest?
        if let anURL = url {
            request = URLRequest(url: anURL)
        }
        guard let confirmrequest = request else { return }
        let downloadTask: URLSessionDownloadTask? = manager.downloadTask(with: confirmrequest, progress: nil, destination: { _, response in
            let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return (documentsDirectoryURL?.appendingPathComponent(response.suggestedFilename ?? ""))!
        }, completionHandler: { _, filePath, _ in
            if let aPath = filePath {
                print("File downloaded to: \(aPath)")
            }
            guard let pathname = filePath?.absoluteString else { return }
                completion(pathname)
        })
        downloadTask?.resume()
 
     }
}
