//
//  ImagePicker.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 03.04.2023.
//

import UIKit

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static let defaultPicker = ImagePicker()
    
    var picker: UIImagePickerController!
    var completion: ((_ imageData: Data?) -> ())?
    
    func getImage(in viewcontroller: UIViewController, completion: ((_ imageData: Data?) -> ())?) {
        
        self.completion = completion
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        viewcontroller.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageData = (info[.originalImage] as? UIImage)?.pngData()
        completion?(imageData)
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss (animated: true)
    }
    
}
