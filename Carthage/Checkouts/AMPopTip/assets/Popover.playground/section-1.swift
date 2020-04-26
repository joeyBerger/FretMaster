// Playground - noun: a place where people can play

import UIKit

enum PopoverTip {
    case Up
    case Down
    case Left
    case Right
}

class Popover: UIView {
    var text: NSString
    var radius: CGFloat
    var padding: CGFloat
    var direction: PopoverTip
    var containerView: UIView
    var textBound: CGRect
    var tipPosition: CGPoint
    var tipSize: CGSize
    var paragraphStyle: NSMutableParagraphStyle

    init(text: NSString, fromFrame: CGRect, direction: PopoverTip, maxWidth: CGFloat, inView: UIView) {
        self.text = text
        radius = 4
        padding = 6
        containerView = inView
        self.direction = direction
        tipSize = CGSize(width: 16, height: 16)
        textBound = CGRectZero
        tipPosition = CGPointZero
        paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.alignment = .Center

        var rect = CGRectZero

        super.init(frame: rect)

        loadDefaults()

        // The text bound is the rect that contains the label, it will be drawn at (padding, padding)
        textBound = text.boundingRectWithSize(CGSize(width: maxWidth, height: FLT_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "Futura", size: 12)], context: nil)

        textBound.origin = CGPoint(x: padding, y: padding)

        // The rect includes the text, padding and arrow
        switch self.direction {
        case .Down, .Up:
            rect.size = CGSize(width: textBound.size.width + padding * 2.0, height: textBound.size.height + padding * 2.0 + tipSize.height)

            var x = fromFrame.origin.x + fromFrame.size.width / 2 - rect.size.width / 2
            if x < 0 { x = 0 }
            if x + rect.size.width > containerView.frame.size.width { x = containerView.frame.size.width - rect.size.width }
            rect.origin = CGPoint(x: x, y: fromFrame.origin.y + fromFrame.size.height)

        case .Left, .Right:
            rect.size = CGSize(width: textBound.size.width + padding * 2.0 + tipSize.height, height: textBound.size.height + padding * 2.0)
        }

        frame = rect

        backgroundColor = UIColor.clearColor()

        // TODO: init the other direction
        switch self.direction {
        case .Down:
            tipPosition = CGPoint(
                x: fromFrame.origin.x + fromFrame.size.width / 2 - rect.origin.x,
                y: fromFrame.origin.y + fromFrame.size.height - rect.origin.y
            )
            textBound.origin = CGPoint(x: textBound.origin.x, y: textBound.origin.y + tipSize.height)
            layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            layer.position = CGPoint(x: layer.position.x, y: layer.position.y - rect.height / 2)
        case .Up:
            tipPosition = CGPoint(
                x: fromFrame.origin.x + fromFrame.size.width / 2,
                y: fromFrame.origin.y
            )
        case .Left:
            tipPosition = CGPoint(
                x: fromFrame.origin.x,
                y: fromFrame.origin.y + fromFrame.size.height / 2
            )
        case .Right:
            tipPosition = CGPoint(
                x: fromFrame.origin.x + fromFrame.size.width,
                y: fromFrame.origin.y + fromFrame.size.height / 2
            )
        }
    }

    func show() {
        transform = CGAffineTransformMakeScale(0, 0)
        containerView.addSubview(self)
        UIView.animateWithDuration(0.5, animations: {
            self.transform = CGAffineTransformIdentity
        })
    }

    func loadDefaults() {
        // TODO: load defaults if there's no appearance data
    }

    override func drawRect(rect _: CGRect) {
        let arrow = UIBezierPath()

        var baloonFrame: CGRect
        switch direction {
        case .Down:
            baloonFrame = CGRect(x: 0, y: tipSize.height, width: frame.width, height: frame.height - tipSize.height)

            arrow.moveToPoint(tipPosition)
            arrow.addLineToPoint(CGPoint(x: tipPosition.x - tipSize.width / 2, y: tipPosition.y + tipSize.height))
            arrow.addLineToPoint(CGPoint(x: tipPosition.x + tipSize.width / 2, y: tipPosition.y + tipSize.height))
            tipPosition
            UIColor.redColor().setFill()
            arrow.fill()

        case .Up:
            baloonFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - tipSize.height)
        case .Left:
            baloonFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - tipSize.height)
        case .Right:
            baloonFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - tipSize.height)
        }

        let path = UIBezierPath(roundedRect: baloonFrame, cornerRadius: radius)

        UIColor.redColor().setFill()
        path.fill()

        let titleAttributes = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: UIFont(name: "Futura", size: 12),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
        ]

        text.drawInRect(textBound, withAttributes: titleAttributes)
    }

    func degrees_to_radians(degrees: CGFloat) -> CGFloat { return ((3.14159265359 * degrees) / 180.0) }
}

let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 640))
let label = UILabel(frame: CGRect(x: 10, y: 300, width: 300, height: 100))
label.backgroundColor = UIColor.greenColor()
view.addSubview(label)

var popover = Popover(text: "Hi!\nI'm a popover", fromFrame: label.frame, direction: .Down, maxWidth: 320, inView: view)

popover.show()
view
