import AMPopTip
import NotificationCenter
import UIKit

class TodayViewController: UIViewController, NCWidgetProviding {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        completionHandler(NCUpdateResult.newData)
    }
}
