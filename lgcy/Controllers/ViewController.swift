import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topBarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initially hide the image view
        topBarImageView.isHidden = true
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        // Show the image view and set the image
        topBarImageView.image = UIImage(named: "yourImageName")
        topBarImageView.isHidden = false
    }
}
