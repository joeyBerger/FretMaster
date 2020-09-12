import CoreData
import UIKit

class ImageChooserViewController: UIViewController {
    var bgImage = UIImageView()
    var selectedBackground = "menu"
    let flickr = Unsplash()
    let changeButton = UIButton()
    let acceptButton = UIButton()
    var imageChanged = false
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupButtons()
        setupActivityIndicator()
    }

    func setupBackground() {
        if let image = backgroundImage.images[selectedBackground]! {
            bgImage.image = image
        } else {
            bgImage.image = backgroundImage.returnImage(selectedBackground)
        }

        bgImage.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
        bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        view.insertSubview(bgImage, at: 0)
    }

    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func setupButtons() {
        let buttons = [changeButton, acceptButton]
        let title = ["CHANGE", "ACCEPT"]
        let color = [defaultColor.MenuButtonColor, defaultColor.AcceptColor]

        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let screenHeight = screenRect.size.height
        let width: CGFloat = screenWidth * 0.72
        let height: CGFloat = 70
        let yBuffer: CGFloat = 190
        let buttonBuffer = 100

        for (i, button) in buttons.enumerated() {
            button.frame = CGRect(x: screenWidth * 0.5 - width / 2, y: screenHeight - height - yBuffer + CGFloat(buttonBuffer * i), width: width, height: height)
            button.backgroundColor = color[i]
            button.layer.cornerRadius = 10
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 0.0
            button.layer.masksToBounds = false
            button.setTitle(title[i], for: .normal)
            button.tintColor = defaultColor.MenuButtonTextColor
            button.titleLabel?.font = .systemFont(ofSize: 18)
            view.addSubview(button)
        }
        buttons[0].addTarget(self, action: #selector(onChangeButtonDown), for: .touchDown)
        buttons[1].addTarget(self, action: #selector(onAcceptButtonDown), for: .touchDown)
    }

    @objc func onChangeButtonDown() {
        controlButtonState(false)
        activityIndicator.startAnimating()
        flickr.unsplashSearch(for: (backgroundImage.searchStrings[selectedBackground]?.randomElement())!) { imageURL, error in
            if error != nil {
                // handle error
                self.displayAlert()
            } else {
                self.flickr.unsplashImageDownload(for: imageURL!.full) { image, errorStr in
                    if errorStr == nil {
                        self.bgImage.image = image
                        backgroundImage.images[self.selectedBackground] = image
                        self.controlButtonState(true)
                        self.imageChanged = true
                        self.activityIndicator.stopAnimating()
                    } else {
                        // handle error
                        self.displayAlert()
                    }
                }
            }
        }
    }

    func saveImage(data: Data) {
        let fetchRequest: NSFetchRequest<ImageData> = ImageData.fetchRequest()
        if let results = try? globalDataController.viewContext.fetch(fetchRequest) {
            for image in results {
                if selectedBackground == image.id! {
                    globalDataController.viewContext.delete(image)
                    break
                }
            }
        }

        let imageInstance = ImageData(context: globalDataController.viewContext)
        imageInstance.backgroundImage = data
        imageInstance.id = selectedBackground
        do {
            try globalDataController.viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    @objc func onAcceptButtonDown() {
        if imageChanged {
            backgroundImage.images[selectedBackground] = bgImage.image
            saveImage(data: bgImage.image!.pngData()!)
        }
        navigationController?.popViewController(animated: false)
    }

    func controlButtonState(_ enabled: Bool) {
        changeButton.isEnabled = enabled
        acceptButton.isEnabled = enabled
    }

    func handleError() {
        activityIndicator.stopAnimating()
        controlButtonState(true )
    }

    func displayAlert() {
        let alert = UIAlertController(title: "Error Retrieving Image", message: "Please try again", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in self.handleError() }))
        present(alert, animated: true, completion: nil)
    }
}
