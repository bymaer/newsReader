//
//  extensions+protocols.swift
//  tlabNewsReader
//
//  Created by Artyom Mayorov on 2/3/23.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadFrom(URLAddress: String) {
        
        if let image = imageCache.object(forKey: URLAddress as NSString) {
            self.image = image as? UIImage
            return
        }
        
        guard let url = URL(string: URLAddress) else {
            return
        }

        DispatchQueue.global().async {
            [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        imageCache.setObject(loadedImage, forKey: URLAddress as NSString)
                        self?.image = loadedImage
                    }
                }
            }
        }
    }
}
