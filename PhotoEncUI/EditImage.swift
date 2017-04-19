//
//  EditImage.swift
//  PhotoEncUI
//
//  Created by FelisDJ on 4/16/2560 BE.
//  Copyright © 2560 Jackthip Pureesatian. All rights reserved.
//

import UIKit

class EditImage: NSObject {
	
	func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
		let size = image.size
		
		let widthRatio  = targetSize.width  / image.size.width
		let heightRatio = targetSize.height / image.size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		image.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
	
	func changeIntensityOrSaturation(imageInput: UIImage, valueSlider: Float, modeSelection: String) -> UIImage {
		let value = Int(20*valueSlider)
//		testLabel.text = "\(modeSelection): \(value)"
		let imageOutput:UIImage = OpenCVWrapper.enhancementIntensity(imageInput, Int(value), modeSelection)
		
		return imageOutput
	}
	
	func filterImage(imageInput: UIImage, valueSlider: Float, modeSelection: String) -> UIImage {
		let filterSize = Int((valueSlider)+5)*2+1
//		testLabel.text = "\(modeSelection): \(Int((valueSlider.value)+5)*2+1)"
		let imageOutput: UIImage = OpenCVWrapper.filterMode(imageInput, modeSelection, filterSize)
		
		return imageOutput
	}
	
	func imageToGray(imageInput: UIImage) -> UIImage {
		let imageOutput: UIImage = OpenCVWrapper.makeGray(from: imageInput)
		
		return imageOutput
	}
	
	func imageRotateOrFlip(imageInput: UIImage, mode: String) -> UIImage {
		print("func rotate on EditImage")
		var imageOutput: UIImage!
		if mode == "rLeft" {
			imageOutput = OpenCVWrapper.rotateMode(imageInput, 90.0)
		} else if mode == "rRight" {
			imageOutput = OpenCVWrapper.rotateMode(imageInput, -90.0)
		} else if mode == "fVertical" {
			imageOutput = OpenCVWrapper.flipMode(imageInput, "vertical")
		} else {
			imageOutput = OpenCVWrapper.flipMode(imageInput, "horizontal")
		}
		return imageOutput
	}

	func imageToAutoContrast(imageInput: UIImage) -> UIImage {
		let imageOutput: UIImage = OpenCVWrapper.autoContrast(imageInput)
		
		return imageOutput
	}

	func calHistogram(imageInput: UIImage) -> UIImage {
		let histogram: UIImage = OpenCVWrapper.histogramData(imageInput)
		
		return histogram
	}
}
