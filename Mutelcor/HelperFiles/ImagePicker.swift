//
//  ImagePicker.swift
//  Mutelcor
//
//  Created by  on 16/01/18.
//  Copyright © 2018 . All rights reserved.
//

import AssetsLibrary
import AVFoundation
import Photos

protocol ImagePickerDelegate: class {
    func getSelectedImage(capturedImage image: UIImage)
    func imagePickerControllerDidCancel()
}

class ImagePicker: NSObject {
    
    static let shared = ImagePicker()
    
    weak var imagePickerDelegate: ImagePickerDelegate?
    
    typealias ImagePickerDelegateController = (BaseViewController)
    
    func captureImage(on controller: ImagePickerDelegateController,
                      photoGallery: Bool = true,
                      camera: Bool = true,
                      viewForCustomCamera view: CustomCameraView? = nil) {
        
        let chooseOptionText =  ""//StringConstants.APP_TITLE.localized()
        let alertController = UIAlertController(title: chooseOptionText, message: nil, preferredStyle: .actionSheet)
        
        if photoGallery {
            
            let chooseFromGalleryText =  K_GALLERY_TITLE.localized
            let alertActionGallery = UIAlertAction(title: chooseFromGalleryText, style: .default) { _ in
                self.checkAndOpenLibrary(on: controller)
            }
            alertController.addAction(alertActionGallery)
        }
        
        if camera {
            
            let takePhotoText =  K_CAMERA_TITLE.localized
            let alertActionCamera = UIAlertAction(title: takePhotoText, style: .default) { action in
                self.checkAndOpenCamera(on: controller, viewForCustomCamera: view)
//                if SwifterSwift.isRunningOnSimulator {
//                    self.checkAndOpenLibrary(on: controller)
//                } else {
//                    self.checkAndOpenCamera(on: controller)
//                }
            }
            alertController.addAction(alertActionCamera)
        }
        
        let cancelText =  K_CANCEL_BUTTON.localized
        let alertActionCancel = UIAlertAction(title: cancelText, style: .cancel) { _ in
        }
        alertController.addAction(alertActionCancel)
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    func checkAndOpenCamera(on controller: ImagePickerDelegateController, viewForCustomCamera view: CustomCameraView? = nil) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
            
        case .authorized:
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            let sourceType = UIImagePickerControllerSourceType.camera
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                imagePicker.sourceType = sourceType
                if let customView = view{
                    imagePicker.showsCameraControls = false
                    imagePicker.cameraOverlayView = customView
                    customView.imagePicker = imagePicker
                    imagePicker.allowsEditing = false
                }else{
                    imagePicker.allowsEditing = false
                    imagePicker.showsCameraControls = true
                }
                controller.present(imagePicker, animated: true, completion: nil)
            } else {
                
                //                let cameraNotAvailableText = StringConstants.Camera_not_available.localized()
                //                presentAlert(title: nil, message: cameraNotAvailableText)
            }
            
        case .notDetermined:

            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { granted in
                
                if granted {
                    
                    mainQueue {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        
                        let sourceType = UIImagePickerControllerSourceType.camera
                        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                            
                            imagePicker.sourceType = sourceType
                            if imagePicker.sourceType == .camera {
                               
                                if let customView = view{
                                    imagePicker.showsCameraControls = false
                                    imagePicker.cameraOverlayView = customView
                                    customView.imagePicker = imagePicker
                                    imagePicker.allowsEditing = true
                                }else{
                                    imagePicker.allowsEditing = false
                                    imagePicker.showsCameraControls = true
                                }
                            }
                            controller.present(imagePicker, animated: true, completion: nil)
                            
                        } else {
                            //                            let cameraNotAvailableText = StringConstants.Camera_not_available.localized()
                            //                            presentAlert(title: nil, message: cameraNotAvailableText)
                        }
                    }
                }
            })
            
        case .restricted: return
//            alertPromptToAllowCameraAccessViaSetting(StringConstants.Youve_been_restricted_from_using_the_camera_on_this_device_Without_camera_access_this_feature_wont_work.localized())
            
        case .denied: return
//            alertPromptToAllowCameraAccessViaSetting(StringConstants.Please_change_your_privacy_setting_from_the_Settings_app_and_allow_access_to_camera_for.localized())
        }
    }
    
    func checkAndOpenLibrary(on controller: ImagePickerDelegateController) {
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
            
        case .notDetermined:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            let sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false
            controller.present(imagePicker, animated: true, completion: nil)
            
        case .restricted: return
//            alertPromptToAllowCameraAccessViaSetting(StringConstants.Youve_been_restricted_from_using_the_camera_on_this_device_Without_camera_access_this_feature_wont_work.localized())
            
        case .denied: return
//            alertPromptToAllowCameraAccessViaSetting(StringConstants.Please_change_your_privacy_setting_from_the_Settings_app_and_allow_access_to_camera_for.localized())
            
        case .authorized:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self//controller
            let sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.sourceType = sourceType
            controller.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func alertPromptToAllowCameraAccessViaSetting(_ message: String) {
        
        let alertText = "Alert"
        //let cancelText = ""//StringConstants.Cancel.localized()
        let settingsText = "Settings"
        
        let alert = UIAlertController.init(title: alertText, message: "", preferredStyle: .alert)//UIAlertController(title: alertText, message: message, defaultActionButtonTitle: cancelText)
        alert.addAction(UIAlertAction.init(title: settingsText, style: .destructive, handler: nil))
//        alert.addAction(title: settingsText, style: UIAlertActionStyle.destructive)
//        alert.show()
    }
}

extension ImagePicker : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){

        guard let choosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        self.imagePickerDelegate?.getSelectedImage(capturedImage: choosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        self.imagePickerDelegate?.imagePickerControllerDidCancel()
    }
}

