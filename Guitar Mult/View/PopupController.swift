import AMPopTip
import Foundation

class PopupController {
    let vc: MainViewController?
    let tutorialPopup = PopTip()
    let reminderPopup = PopTip()
    let resultButtonPopup = PopTip()
    var resultButtonView: UIView?
    var resultButtonPopupVisible = false

    init(ivc: MainViewController) {
        vc = ivc

        tutorialPopup.textColor = UIColor.white
        tutorialPopup.bubbleColor = defaultColor.ResultBubbleColor //UIColor(red: 80 / 255, green: 184 / 255, blue: 231 / 255, alpha: 1.0) //
        tutorialPopup.shouldDismissOnTap = false
        tutorialPopup.shouldDismissOnTapOutside = false
        tutorialPopup.animationOut = 0.15

        tutorialPopup.layer.zPosition = vc!.getLayer(ilayer: "PopOverLayer")

        reminderPopup.textColor = UIColor.white
        reminderPopup.bubbleColor = defaultColor.ResultBubbleColor

        resultButtonPopup.textColor = UIColor.white
        resultButtonPopup.bubbleColor = defaultColor.ResultBubbleColor //UIColor.red

        resultButtonPopup.layer.zPosition = vc!.getLayer(ilayer: "PopOverLayer")
        resultButtonPopup.dismissHandler = { _ in
            self.resultButtonPopupVisible = false
        }
        resultButtonPopup.appearHandler = { _ in
            self.resultButtonPopupVisible = true
        }
    }

    @objc func startTestReminder(itime: Double) {
        vc!.wt.waitThen(itime: itime, itarget: self, imethod: #selector(enactTestReminder) as Selector, irepeats: false, idict: ["arg1": 0 as AnyObject])
    }

    @objc func enactTestReminder(timer _: Timer) {
        let c = vc!.view.convert(vc!.periphButtonArr[0].frame, from: vc!.PeripheralStackView)
        reminderPopup.show(text: "Start Test When Ready!", direction: .left, maxWidth: 200, in: vc!.view, from: c)
    }

    func setResultButtonPopupText(itextArr: [String]) {
        let textSpacing = 30
        let c = vc!.view.convert(vc!.periphButtonArr[0].frame, from: vc!.PeripheralStackView)
        let popoverSize = (c.maxX - vc!.TempoDownButton.frame.maxX) * 0.72
        resultButtonView?.removeFromSuperview()
        resultButtonView = UIView(frame: CGRect(x: 0, y: 0, width: Int(popoverSize), height: itextArr.count * textSpacing))

        for (i, _) in itextArr.enumerated() {
            let popoverText = UILabel()
            popoverText.frame = CGRect(x: 0, y: i * textSpacing, width: Int(popoverSize), height: textSpacing)
            popoverText.textAlignment = NSTextAlignment.center
            popoverText.text = itextArr[i]
            popoverText.layer.zPosition = 2.0
            popoverText.textColor = UIColor.white
            resultButtonView!.addSubview(popoverText)
        }
        resultButtonPopup.hide()
    }

    func showResultButtonPopup() {
        if !resultButtonPopupVisible {
            var mid = vc!.ResultButton.frame
            mid = mid.offsetBy(dx: 0.0, dy: 10.0)
            resultButtonPopup.show(customView: resultButtonView!, direction: .down, in: vc!.view, from: mid)
        } else {
            resultButtonPopup.hide()
        }
    }
}
