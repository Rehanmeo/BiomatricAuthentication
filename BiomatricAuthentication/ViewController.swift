//
//  ViewController.swift
//  BiomatricAuthentication
//
//  Created by Muhammad Rehan on 5/17/22.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    
    let context = LAContext()
    var strMessage = String()
    var err: NSError?
    
    @IBOutlet weak var imageAuth: UIImageView!
    @IBOutlet weak var authBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        controllerSetUI()
    }


}

extension ViewController {
    
    func controllerSetUI(){
        authentication()
        authenticationAction()
    }
    
    func authenticationAction(){
        
        self.authBtn.addAction(UIAction(handler: { _ in
            
            print("hello")
            if self.context.canEvaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                error: &self.err) {
                self.context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics, localizedReason: self.strMessage, reply: { [unowned self] (success, error) -> Void in
                        DispatchQueue.main.async {
                            if( success ) {
                                //Fingerprint recognized
                                // Do whatever action you want to perform
                                print("successful")
                            } else {
                                //If not recognized then
                                if let error = error {
                                    let strMessage = self.errorMessage(errorCode: error._code)
                                    print(strMessage)
                                }
                            }
                        }
                    })
            }
        }), for: .touchUpInside)
    }
    
    func authentication(){
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &err) {
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err) {
                switch context.biometryType {
                case .faceID:
                    self.strMessage = "Set your face to authenticate"
                    self.imageAuth.image = UIImage(named: "face")
                    break
                case .touchID:
                    self.strMessage = "Set your finger to authenticate"
                    self.imageAuth.image = UIImage(named: "touch")
                    break
                case .none:
                    print("none")
                    //description = "none
                    break
                default:
                    print(err?.localizedDescription ?? "")
                    break
                }
            }else {
                
                // Device cannot use biometric authentication
                
                if let err = err {
                    // calling error message function based on the error type
                    let strMessage = self.errorMessage(errorCode: err._code)
                    print("Error: \(strMessage)")
                }
            }
        }else{
            if let err = err {
                let strMessage = self.errorMessage(errorCode: err._code)
                print("Error: \(strMessage)")
            }
        }
    }
    
    // Error Messages work
    func errorMessage(errorCode:Int) -> String{

        var strMessage = ""

        switch errorCode {
        case LAError.authenticationFailed.rawValue:
          strMessage = "Authentication Failed"

        case LAError.userCancel.rawValue:
          strMessage = "User Cancel"

        case LAError.userFallback.rawValue:
          strMessage = "User Fallback"

        case LAError.systemCancel.rawValue:
          strMessage = "System Cancel"

        case LAError.passcodeNotSet.rawValue:
          strMessage = "Passcode Not Set"
        case LAError.biometryNotAvailable.rawValue:
          strMessage = "TouchI DNot Available"

        case LAError.biometryNotEnrolled.rawValue:
          strMessage = "TouchID Not Enrolled"

        case LAError.biometryLockout.rawValue:
          strMessage = "TouchID Lockout"

        case LAError.appCancel.rawValue:
          strMessage = "App Cancel"

        case LAError.invalidContext.rawValue:
          strMessage = "Invalid Context"

        default:
          strMessage = "Some error found"

        }

        return strMessage

    }
    
}
