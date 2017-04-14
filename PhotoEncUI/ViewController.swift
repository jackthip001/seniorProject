//
//  ViewController.swift
//  PhotoEncUI
//
//  Created by FelisDJ on 1/22/2560 BE.
//  Copyright © 2560 Jackthip Pureesatian. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, selectFunctionDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, sourceImageDelegate {

	@IBOutlet weak var mainScrollImage: scrollImage!
	@IBOutlet weak var imageToEdit: UIImageView!
	
	var inputImageViewShow: Bool = false
	var editedImage: UIImage?
	let imagePicker = UIImagePickerController()
	let testView: InputImageView = InputImageView(frame: CGRect(x: 5, y: 40, width: 160, height: 100))
	
	func userSelect(selection: UIImage) {
		editedImage = selection
		imageToEdit.image = editedImage
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.mainScrollImage.minimumZoomScale = 1.0
		self.mainScrollImage.maximumZoomScale = 5.0
		
		let aSelector: Selector = #selector(removeSubview)
		let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
		self.view.addGestureRecognizer(tapGesture)
		
		print("First Page")
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageToEdit
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showFunction" {
			let functionSelectionView: FunctionViewController = segue.destination as! FunctionViewController
			functionSelectionView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
			functionSelectionView.delegate = self
			functionSelectionView.imageToEdit = imageToEdit.image
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
	{
		let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		imageToEdit.contentMode = .scaleAspectFit //3
		imageToEdit.image = chosenImage //4
		dismiss(animated:true, completion: nil) //5
		editedImage = chosenImage
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func sourceSelect(selectionSource: String){
		print("sourceSelected")
		imagePicker.delegate = self
		if(selectionSource == "Gallery") {
			if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
				print("Button capture")

				imagePicker.allowsEditing = false
				imagePicker.sourceType = .photoLibrary
				imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
				present(imagePicker, animated: true, completion: nil)
			}
		} else if (selectionSource == "Camera") {
			if UIImagePickerController.isSourceTypeAvailable(.camera) {
				
				imagePicker.allowsEditing = false
				imagePicker.sourceType = UIImagePickerControllerSourceType.camera
				imagePicker.cameraCaptureMode = .photo
				imagePicker.modalPresentationStyle = .fullScreen
				present(imagePicker, animated: true, completion: nil)
			}
		}
		removeSubview()
	}
	
	func removeSubview() {
		print("Start remove subview")
		if let viewWithTag = testView.viewWithTag(100) {
			viewWithTag.removeFromSuperview()
			testView.selfViewShow = false
		} else {
		print("No")
		}
	}

	@IBAction func sourceInputImage(_ sender: Any) {

		if(!testView.selfViewShow) {
			testView.delegate = self
			self.view.addSubview(testView)
			testView.selfViewShow = true
			print("Show Subview")
		} else {
			removeSubview()
		}
		
	}

	func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			// we got back an error!
			let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		} else {
			let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
	
	@IBAction func saveImage(_ sender: UIBarButtonItem) {
		UIImageWriteToSavedPhotosAlbum(imageToEdit.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
	}

}

