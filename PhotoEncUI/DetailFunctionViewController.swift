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
	var intRGB: Float = 0.0
	var intRed: Float = 0.0
	var intGreen: Float = 0.0
	var intBlue: Float = 0.0
	var angle: Double = 0.0
	var rotateMode: String = ""
	
	@IBOutlet weak var imageToEditView: UIImageView!
	@IBOutlet weak var testLabel: UILabel!
	@IBOutlet weak var valueSlider: UISlider!
	@IBOutlet weak var element: UIToolbar!
	@IBOutlet weak var showHisButton: UIButton!
	
	@IBOutlet weak var RGBOrRLeftButton: UIBarButtonItem!
	@IBOutlet weak var redOrFlipHorizontalButton: UIBarButtonItem!
	@IBOutlet weak var greenOrFlipVerticalButton: UIBarButtonItem!
	@IBOutlet weak var blueOrRRightButton: UIBarButtonItem!
	
	@IBOutlet weak var histogramIntensity: UIImageView!
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		print(modeSelection.uppercased())
		testLabel.text = "\(modeSelection): \((Int)(valueSlider.value))"
		
//		valueSlider.trackRect(forBounds: CGRectMake(0,0,200,100))
		initValue()
		setGesture()
		if(modeSelection != "rotate") {
			editImage()
		}
		// Do any additional setup after loading the view.
	}
	
	func initValue() {
//		valueSlider.setThumbImage(nil, for: .normal)
		element.isHidden = true
		showHisButton.isHidden = true
		histogramIntensity.isHidden = true
		
		if modeSelection == "grayscale" {
			valueSlider.isHidden = true
		}
		if modeSelection == "intensity" {
			element.isHidden = false
			showHisButton.isHidden = false
			valueSlider.tintColor = .white
			
		}
		imageToShow = imageBeforeEdit!
		if modeSelection == "intensity" || modeSelection == "saturation" {
			imageToShow = EditImage().resizeImage(image: imageBeforeEdit!, targetSize: imageToEditView.frame.size)
		}
		if modeSelection == "rotate" {
			element.isHidden = false
			valueSlider.isHidden = true
			RGBOrRLeftButton.title = "Left Rotate"
			redOrFlipHorizontalButton.title = "Flip Horizontal"
			greenOrFlipVerticalButton.title = "Flip Vertical"
			blueOrRRightButton.title = "Right Rotate"
		}
		if modeSelection == "contrast" {
			showHisButton.isHidden = false
			valueSlider.isHidden = true
		}
		imageToEditView.image = imageToShow
		imageToEdit = imageToShow
		
	}
	
	func initSlider() {
		valueSlider.value = 0
	}
	
	func setGesture() {
		imageToEditView.isUserInteractionEnabled = true
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.imageLongPressed(_:)))
		longPressRecognizer.minimumPressDuration = 0.0
		imageToEditView.addGestureRecognizer(longPressRecognizer)
		
		histogramIntensity.isUserInteractionEnabled = true
		let singlePressRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hiddenHistogram(_:)))
		histogramIntensity.addGestureRecognizer(singlePressRecognizer)
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
			calHis()
		}
		else if sender.state == .began {
			print("UIGestureRecognizerStateBegan.")
			imageToEditView.image = imageBeforeEdit
			//Do Whatever You want on Began of Gesture
			calHis()
		}
		
	}
	
	func hiddenHistogram(_ sender: UIGestureRecognizer) {
		histogramIntensity.isHidden = true
		showHisButton.isHidden = false
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
		editImage()
	}
	
	@IBAction func RGBOrRLeftMode(_ sender: UIBarButtonItem) {
		if modeSelection != "intensity" && modeSelection != "rotate" {
			imageToShow = imageToEditView.image
			modeSelection = "intensity"
			valueSlider.value = intRGB
			valueSlider.tintColor = .white
		}
		if(modeSelection == "rotate") {
			rotateMode = "rLeft"
			editImage()
			print("Hello")
		}
	}
	
	@IBAction func redOrFlipHorizonMode(_ sender: UIBarButtonItem) {
		if modeSelection != "intensityRed" && modeSelection != "rotate" {
			imageToShow = imageToEditView.image
			valueSlider.value = intRed
			modeSelection = "intensityRed"
			valueSlider.tintColor = .red
		}
		if(modeSelection == "rotate") {
			rotateMode = "fHorizontal"
			editImage()
		}
	}
	
	@IBAction func greenOrFlipVerticMode(_ sender: UIBarButtonItem) {
		if modeSelection != "intensityGreen" && modeSelection != "rotate" {
			imageToShow = imageToEditView.image
			valueSlider.value = intGreen
			modeSelection = "intensityGreen"
			valueSlider.tintColor = .green
		}
		if(modeSelection == "rotate") {
			rotateMode = "fVertical"
			editImage()
		}
	}
	
	@IBAction func blueOrRRightMode(_ sender: UIBarButtonItem) {
		if modeSelection != "intensityBlue" && modeSelection != "rotate" {
			imageToShow = imageToEditView.image
			valueSlider.value = intBlue
			modeSelection = "intensityBlue"
			valueSlider.tintColor = .blue
		}
		if(modeSelection == "rotate") {
			rotateMode = "rRight"
			editImage()
		}
	}
	
	
	func editImage() {
		if modeSelection == "intensity" || modeSelection == "intensityRed" || modeSelection == "intensityGreen" || modeSelection == "intensityBlue" || modeSelection == "saturation" {
			imageToEditView.image = EditImage().changeIntensityOrSaturation(imageInput: imageToShow!, valueSlider: valueSlider.value, modeSelection: modeSelection)
			if modeSelection == "intensity" {
				intRGB = valueSlider.value
			} else if modeSelection == "intensityRed" {
				intRed = valueSlider.value
			} else if modeSelection == "intensityGreen" {
				intGreen = valueSlider.value
			} else {
				intBlue = valueSlider.value
			}
		} else if modeSelection == "averageFilter" || modeSelection == "gaussianFilter" || modeSelection == "medianFilter" || modeSelection == "sharpen" {
			imageToEditView.image = EditImage().filterImage(imageInput: imageToShow!, valueSlider: valueSlider.value, modeSelection: modeSelection)
		} else if modeSelection == "grayscale" {
			imageToEditView.image = EditImage().imageToGray(imageInput: imageToShow!)
		} else if modeSelection == "rotate" {
			imageToEditView.image = EditImage().imageRotateOrFlip(imageInput: imageToShow!, mode: rotateMode)
			print("rotate")
		} else if modeSelection == "contrast" {
			imageToEditView.image = EditImage().imageToAutoContrast(imageInput: imageToShow!)
		}
		calHis()
		imageToEdit = imageToEditView.image
	}
	
	func selectMode() -> UIImage {
		var image: UIImage?
		if modeSelection == "intensity" || modeSelection == "intensityRed" || modeSelection == "intensityGreen" || modeSelection == "intensityBlue" || modeSelection == "saturation" {
			image = EditImage().changeIntensityOrSaturation(imageInput: imageBeforeEdit!, valueSlider: valueSlider.value, modeSelection: modeSelection)
		} else if modeSelection == "averageFilter" || modeSelection == "gaussianFilter" || modeSelection == "medianFilter" || modeSelection == "sharpen" {
			image = EditImage().filterImage(imageInput: imageBeforeEdit!, valueSlider: valueSlider.value, modeSelection: modeSelection)
		} else if modeSelection == "grayscale" {
			valueSlider.isHidden = false
			image = EditImage().imageToGray(imageInput: imageBeforeEdit!)
		} else if modeSelection == "rotate" {
			image = EditImage().imageRotateOrFlip(imageInput: imageBeforeEdit!, mode: rotateMode)
		} else if modeSelection == "contrast" {
			image = EditImage().imageToAutoContrast(imageInput: imageBeforeEdit!)
		}
		
		return image!
	}
	
	@IBAction func showHistogram(_ sender: UIButton) {
		if showHisButton.isHidden == false {
			showHisButton.isHidden = true
			histogramIntensity.isHidden = false
			calHis()
		}
	}

	func calHis() {
		histogramIntensity.image = EditImage().calHistogram(imageInput: imageToEditView.image!)
	}
}
