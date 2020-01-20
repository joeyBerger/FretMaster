import Foundation
import UIKit

class DigitsInput: NSObject, UITextFieldDelegate {
    
    //let controller = ViewController(nibName: "ViewController", bundle: nil)
    //self.navigationController.pushViewController(controller, animated: true)
    
    var vc: MainViewController? = nil
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        let characters = Array(newText as String)
        
        if (characters.count == 0)
        {
            return true
        }
        
        if ((characters[characters.count-1].unicodeScalars.first?.value)! < 48 as UInt32 || (characters[characters.count-1].unicodeScalars.first?.value)! >= 58 as UInt32)
        {
            newText = textField.text! as NSString
            return false
        }
        
        let amount:String? = newText as String
        if let bpm = amount {
            vc!.met!.bpm = Double(bpm)!
        }
        //controller.bpm = Double(newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
