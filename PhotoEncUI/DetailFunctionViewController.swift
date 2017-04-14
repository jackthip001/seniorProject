//
//  DetailFunctionViewController.swift
//  PhotoEncUI
//
//  Created by FelisDJ on 3/14/2560 BE.
//  Copyright © 2560 Jackthip Pureesatian. All rights reserved.
//

import UIKit

protocol returnImageDelegate {
	func changedImage(image: UIImage)
	
}

class DetailFunctionViewController: UIViewController {

	var delegate: returnImageDelegate? = nil
	
	var modeSelection: String = ""
	var imageToEdit: UIImage?
	var imageBeforeEdit: UIImage?
	var imageToShow: UIImage?
	
	@IBOutlet weak var imageToEditView: UIImageView!
	@IBOutlet weak var testLabel: UILabel!
	@IBOutlet weak var valueSlider: UISlider!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print(modeSelection)
		testLabel.text = "\(modeSelection): \((Int)(valueSlider.value))"
		
		imageToShow = resizeImage(image: imageBeforeEdit!, targetSize: imageToEditView.frame.size)
		
		imageToEditView.image = imageToShow
		imageToEdit = imageToShow
		
		imageToEditView.isUserInteractionEnabled = true
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.imageLongPressed(_:)))
		longPressRecognizer.minimumPressDuration = 0.0
		imageToEditView.addGestureRecognizer(longPressRecognizer)

		if modeSelection == "grayscale" {
			valueSlider.isHidden = true
		}

		initImage()
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func imageLongPressed(_ sender: UIGestureRecognizer) {
		print("Long tap")
		if sender.state == .ended {
			print("UIGestureRecognizerStateEnded")
			imageToEditView.image = imageToEdit
			//Do Whatever You want on End of Gesture
		}
		else if sender.state == .began {
			print("UIGestureRecognizerStateBegan.")
			imageToEditView.image = imageBeforeEdit
			//Do Whatever You want on Began of Gesture
		}
		
	}
	
	@IBAction func cancelFunction(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func doneFunction(_ sender: UIBarButtonItem) {
		self.delegate?.changedImage(image: selectMode())
//		self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil);
		self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func valueChange(_ sender: UISlider) {
		initImage()
	}
	
	func initImage() {
		if modeSelection == "intensity" || modeSelection == "saturation" {
			imageToEditView.image = changeIntensityOrSaturation(imageInput: imageToShow!)
		} else if modeSelection == "averageFilter" || modeSelection == "gaussianFilter" || modeSelection == "medianFilter" || modeSelection == "sharpen" {
			imageToEditView.image = filterImage(imageInput: imageToShow!)
		} else if modeSelection == "grayscale" {
			imageToEditView.image = imageToGray(imageInput: imageToShow!)
		}
		
		imageToEdit = imageToEditView.image
	}
	
	func selectMode() -> UIImage {
		var image: UIImage?
		if modeSelection == "intensity" || modeSelection == "saturation" {
			image = changeIntensityOrSaturation(imageInput: imageBeforeEdit!)
		} else if modeSelection == "averageFilter" || modeSelection == "gaussianFilter" || modeSelection == "medianFilter" || modeSelection == "sharpen" {
			image = filterImage(imageInput: imageBeforeEdit!)
		} else if modeSelection == "grayscale" {
			valueSlider.isHidden = false
			image = imageToGray(imageInput: imageBeforeEdit!)
		}
		
		return image!
	}
	
	func changeIntensityOrSaturation(imageInput: UIImage) -> UIImage {
		let value = Int(20*valueSlider.value)
		testLabel.text = "\(modeSelection): \(value)"
		let imageOutput:UIImage = OpenCVWrapper.enhancementIntensity(imageInput, Int(value), modeSelection)
		
		return imageOutput
	}
	
	func filterImage(imageInput: UIImage) -> UIImage {
		let filterSize = Int((valueSlider.value)+5)*2+1
		testLabel.text = "\(modeSelection): \(filterSize)"
		let imageOutput: UIImage = OpenCVWrapper.filterMode(imageInput, modeSelection, filterSize)
		
		return imageOutput
	}
	
	func imageToGray(imageInput: UIImage) -> UIImage {
		let imageOutput: UIImage = OpenCVWrapper.makeGray(from: imageInput)
		
		return imageOutput
	}
	
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
