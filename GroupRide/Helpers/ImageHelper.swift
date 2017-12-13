//
//  ImageHelper.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/13/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class ImageHelper {
    
    static let shared = ImageHelper()
    
    @discardableResult func flipImage(image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else {
            return image
        }
        let flippedImage = UIImage(cgImage: cgImage,
                                   scale: image.scale,
                                   orientation: .leftMirrored)
        return flippedImage
    }
    
}
