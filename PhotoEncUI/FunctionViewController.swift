//
//  FunctionViewController.swift
//  PhotoEncUI
//
//  Created by FelisDJ on 1/29/2560 BE.
//  Copyright © 2560 Jackthip Pureesatian. All rights reserved.
//

import UIKit

protocol selectFunctionDelegate {
	func userSelect(selection: UIImage)
}

class FunctionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, returnImageDelegate {
	
	var imageToEdit: UIImage?
	
	@IBOutlet weak var functionListView: UICollectionView!
	
	var functionList: Array = ["intensity","saturation","contrast","grayscale","averageFilter","gaussianFilter","medianFilter","sharpen","crop","rotate"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

		functionListView.delegate = self
		functionListView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	var delegate: selectFunctionDelegate? = nil

	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// Set the number of items in your collection view.
		return functionList.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		// Access
		let cell = functionListView.dequeueReusableCell(withReuseIdentifier: "functionCell", for: indexPath) as! functionListCell
		// Do any custom modifications you your cell, referencing the outlets you defined in the Custom cell file.
		cell.backgroundColor = UIColor.black
		cell.layer.borderColor = UIColor.lightGray.cgColor
		cell.layer.borderWidth = 1
		cell.tag = indexPath.item
		cell.functionName.text = "\(functionList[indexPath.item])"
		
		return cell
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		assert(sender as? UICollectionViewCell != nil, "sender is not a collection view")
		if segue.identifier == "showDetailFunction" {
			let functionDetailSelectionView = segue.destination as! DetailFunctionViewController
			let cell = sender as! UICollectionViewCell
			print(cell.tag)
			functionDetailSelectionView.delegate = self
			functionDetailSelectionView.modeSelection = "\(functionList[cell.tag])"
			functionDetailSelectionView.imageBeforeEdit = imageToEdit!
			
		}

	}

	func changedImage(image: UIImage) {
		self.delegate?.userSelect(selection: image)

	}
	
	@IBAction func backToMain(_ sender: Any) {
		dismissView()
	
	}
	
	func dismissView () {
		dismiss(animated: true, completion: nil)
	}
	
}
