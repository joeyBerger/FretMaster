import AMPopTip
import Foundation
import StoreKit

class PurchasePopover: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var vc: MainViewController?
    var background = SpringImageView()
    var mainButton = SpringButton()
    var buttonText = SpringLabel()
    var titleText = SpringLabel()
    var subTitleText = SpringLabel()
    var subText = [SpringLabel()]
    var xButton = SpringButton()

    var popoverVisible = false
    var mainPopoverState = ""
    
    var myProduct: SKProduct?

    convenience init() {
        self.init(ivc: nil)
    }

    init(ivc: UIViewController?) {
        vc = ivc as? MainViewController
        super.init(nibName: nil, bundle: nil)
        fetchProducts()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupPopover(_ inavigationController: UINavigationController) {
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        
        let width = screenWidth*0.95
        let height:CGFloat = 450
        
        background.frame = CGRect(x: (screenWidth-width)/2, y: (screenHeight - height)/2, width: width, height: height)
        background.layer.zPosition = 500
        background.backgroundColor = defaultColor.MenuButtonColor
        background.layer.cornerRadius = 20
        
        let buttonHeight:CGFloat = 65, buttonBuffer:CGFloat = 20, buttonWidth:CGFloat = background.frame.width*0.7
        mainButton.frame = CGRect(x: (background.frame.width-buttonWidth)/2, y: background.frame.maxY - buttonHeight - buttonBuffer , width: buttonWidth, height: buttonHeight)
        mainButton.layer.zPosition = 501
        mainButton.backgroundColor = defaultColor.FretMarkerSuccess
        
        mainButton.layer.shadowColor = UIColor.black.cgColor
        mainButton.layer.shadowOffset = CGSize(width: 2, height: 5)
        mainButton.layer.shadowRadius = 2
        mainButton.layer.shadowOpacity = 0.6
        mainButton.layer.cornerRadius = 8
        mainButton.addTarget(self, action: #selector(handleButtonPress), for: .touchDown)
        
        buttonText.frame = mainButton.frame
        buttonText.text = "🔥＄2.99 🔥"
        buttonText.layer.zPosition = 502
        buttonText.textAlignment = .center
        buttonText.font = buttonText.font.withSize(25)
        buttonText.textColor = defaultColor.MenuButtonTextColor
        vc!.styler!.addStandardLabelShadow(buttonText)
        
        titleText.frame = CGRect(x: background.frame.minX,y: background.frame.minY+20,width: background.frame.width, height: 65)
        titleText.text = "Guitar Mult"
        titleText.layer.zPosition = 502
        titleText.textAlignment = .center
//        titleText.font = UIFont(name:"MrsSheppards-Regular",size:50)
        titleText.font = UIFont(name:"Arizonia-Regular",size:50)
        titleText.textColor = defaultColor.FretMarkerStandard
        titleText.layer.shadowColor = UIColor.black.cgColor
        titleText.layer.shadowRadius = 3.0
        titleText.layer.shadowOpacity = 1.0
        titleText.layer.shadowOffset = CGSize(width: 4, height: 4)
        titleText.layer.masksToBounds = false
        
        subTitleText.frame = CGRect(x: background.frame.minX,y: titleText.frame.maxY,width: background.frame.width, height: 100)
        subTitleText.text = "UNLOCK MORE FEATURES!"
        subTitleText.layer.zPosition = 502
        subTitleText.textAlignment = .center
        subTitleText.font = buttonText.font.withSize(30+0)
        subTitleText.textColor = defaultColor.MenuButtonTextColor
        vc!.styler!.addStandardLabelShadow(subTitleText)

        let subTextText = ["👍 UNLOCK ALL LEVELS!","😃 COMPLETE ACCESS TO APP!","❤️ ALL FUTURE UPDATES FREE!"]
        let subTextHeight:CGFloat = 50, subTextWidth:CGFloat = width * 0.95, subTextBuffer:CGFloat = 50
        for i in 0..<3 {
            subText.append(SpringLabel())
//            subText[i].frame = CGRect(x: (background.frame.width-subTextWidth)/2, y: subTitleText.frame.maxY+CGFloat(i)*subTextBuffer, width: background.frame.width, height: subTextHeight)
            subText[i].frame = CGRect(x: (screenWidth-subTextWidth)/2, y: subTitleText.frame.maxY+CGFloat(i)*subTextBuffer, width: subTextWidth, height: subTextHeight)
            subText[i].adjustsFontSizeToFitWidth = true
            subText[i].text = subTextText[i]
            subText[i].layer.zPosition = 502
            subText[i].textAlignment = .center
            subText[i].font = subText[i].font.withSize(20+3)
            subText[i].textColor = defaultColor.MenuButtonTextColor
            vc!.styler!.addStandardLabelShadow(subText[i])
        }

        let buttonSize:CGFloat = 30
        xButton.frame = CGRect(x: background.frame.maxX-buttonSize*1.5, y: background.frame.minY+buttonSize/2, width: buttonSize, height: buttonSize)
        xButton.layer.zPosition = 502
        let image = UIImage(named: "icons8-multiply-50")
        xButton.setImage(image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        xButton.imageView?.tintColor = defaultColor.MenuButtonTextColor
        xButton.imageView?.alpha = 1.0
        xButton.addTarget(self, action: #selector(handleXButtonPress), for: .touchDown)
        vc!.view.addSubview(xButton)
        
        removeFromView()
    }

    @objc func handleButtonPress() {
        
        //handle purchase
        guard let myProduct = myProduct else {
            return
        }
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: myProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            return
        }
        
        #if DEBUG
            onSucessfullPurchaseCompleted()
        #else
        
        #endif
    }
    
    func onSucessfullPurchaseCompleted() {
        appUnlocked = "1.0"
        UserDefaults.standard.set(appUnlocked, forKey: "appUnlocked")
//        UserDefaults.standard.set(volume.volumeTypes[volStr], forKey: volStr)
        vc!.navigationController?.popViewController(animated: false)
    }
    
    @objc func handleXButtonPress() {
        let t:Any = 0
        vc!.closeMainPopover(t)
        vc!.navigationController?.popViewController(animated: false)
    }

    func removeFromView() {
        background.removeFromSuperview()
        mainButton.removeFromSuperview()
        buttonText.removeFromSuperview()
        titleText.removeFromSuperview()
        subTitleText.removeFromSuperview()
        xButton.removeFromSuperview()
        for text in subText {
            text.removeFromSuperview()
        }
    }

    func addToView() {
        popoverVisible = true
        vc!.view.addSubview(background)
        vc!.view.addSubview(mainButton)
        vc!.view.addSubview(buttonText)
        vc!.view.addSubview(titleText)
        vc!.view.addSubview(subTitleText)
        vc!.view.addSubview(xButton)
        for text in subText {
            vc!.view.addSubview(text)
        }
        background.setAndPlayAnim("paywallFadeIn")
        mainButton.setAndPlayAnim("paywallFadeIn")
        titleText.setAndPlayAnim("paywallFadeIn")
        subTitleText.setAndPlayAnim("paywallFadeIn")
        xButton.setAndPlayAnim("paywallFadeIn")
        buttonText.setAndPlayAnim("paywallFadeIn")
        for (_,text) in subText.enumerated() {
            text.setAndPlayAnim("paywallFadeIn")
        }
    }

    func fadePopver() {
        background.setAndPlayAnim("fadeOnPopoverDismiss")
    }

    func setupPopoverText(isubtitle: String, isubText: [String]) {
        subTitleText.text = isubtitle
        for text in subText {
            text.text = ""
        }
        for (i,subtext) in isubText.enumerated() {
            subText[i].text = subtext
        }
    }
    
    //In-app purchases: https://www.youtube.com/watch?v=qyKmpr9EjwU
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: ["com.GuitarMult.unlockfeatures"])
        request.delegate = self
        request.start()
        print("in fetch products")
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product =   response.products.first {
            myProduct = product
            print(product.productIdentifier)
            print(product.price)
            print(product.localizedTitle)
            print(product.localizedDescription)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print("paymentQueue",transaction.transactionState)
            switch transaction.transactionState {
            case .purchasing:
                //do nothing
                break
            case .purchased, .restored:
                let t:Any = 0
                vc!.closeMainPopover(t)
                onSucessfullPurchaseCompleted()
                print("purchase pressed!!")
                
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            default :
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
}
