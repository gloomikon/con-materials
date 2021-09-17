import UIKit

final class PhotoCell: UITableViewCell {
    @IBOutlet private var theImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    var isLoading: Bool {
        get { return activityIndicator.isAnimating }
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }

    func display(image: UIImage?) {
        theImageView.image = image
    }
}

