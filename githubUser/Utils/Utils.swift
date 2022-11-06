//
//  Utils.swift
//  githubUser
//
//  Created by Suleiman Abubakar on 06/11/2022.
//

import Foundation
import UIKit

enum PhotoTool {
    static func saveImageDocumentDirectory(image: UIImage, Name: String) {
        let fileMgr = FileManager.default
        let paths = (getDirectoryPath() as NSString).appendingPathComponent(Name)
        let image = image
        let imgData = image.jpegData(compressionQuality: 0.5)
        fileMgr.createFile(atPath: paths as String, contents: imgData, attributes: nil)
    }
  
    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func deleteImageDocumentDirectory(Name: String) {
        let fileManager = FileManager.default
        let paths = (getDirectoryPath() as NSString).appendingPathComponent(Name)
        try? fileManager.removeItem(atPath: paths)
    }
  
    static func getImage(Name: String) -> UIImage? {
        let fileMgr = FileManager.default
        let imagePath = (self.getDirectoryPath() as NSString).appendingPathComponent(Name)
        if fileMgr.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)
        } else {
            print("No Image")
            return nil
        }
    }
}
