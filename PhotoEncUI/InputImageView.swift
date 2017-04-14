//
//  InputImageView.swift
//  PhotoEncUI
//
//  Created by FelisDJ on 3/29/2560 BE.
//  Copyright © 2560 Jackthip Pureesatian. All rights reserved.
//

import UIKit

protocol sourceImageDelegate {
	func sourceSelect(selectionSource: String)
}

class InputImageView: UIView {
	
	var delegate: sourceImageDelegate?
	
	var selfViewShow: Bool!
	var buttonGallery: UIButton!
	var buttonCamera: UIButton!
	var imageSelection: UIImage?
	
	var imagePicker = UIImagePickerController()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .white
		self.alpha = 0.8
		self.tag = 100
		self.isUserInteractionEnabled = true
		
		self.selfViewShow = false
		
		buttonGallery = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: self.frame.size.height))
		buttonGallery.setTitle("Gallery", for: UIControlState.normal)
		buttonGallery.setTitleColor(.blue, for: UIControlState.normal)
		buttonGallery.addTarget(self, action:#selector(chooseImageFromGallery(_:)), for: .touchUpInside)
		self.addSubview(buttonGallery)
		
		buttonCamera = UIButton(frame: CGRect(x: self.frame.size.width/2, y: 0, width: self.frame.size.width/2, height: self.frame.size.height))
		buttonCamera.setTitle("Camera", for: UIControlState.normal)
		buttonCamera.setTitleColor(.blue, for: UIControlState.normal)
		buttonCamera.addTarget(self, action:#selector(chooseImageFromCamera(_:)), for: .touchUpInside)
		self.addSubview(buttonCamera)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	func chooseImageFromGallery(_ sender: UIButton) {
		self.delegate?.sourceSelect(selectionSource: "Gallery")
	}
	
	func chooseImageFromCamera(_ sender: UIButton) {
		self.delegate?.sourceSelect(selectionSource: "Camera")
	}
	
}
