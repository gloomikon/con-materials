import UIKit

class TiltShiftTableViewController: UITableViewController {

    private let queue = OperationQueue()
    private var urls: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let plist = Bundle.main.url(
                forResource: "Photos",
                withExtension: "plist"
        ),
              let contents = try? Data(contentsOf: plist),
              let serial = try? PropertyListSerialization.propertyList(
                from: contents,
                format: nil),
              let serialUrls = serial as? [String] else {
            print("Something went horribly wrong!")
            return
        }

      urls = serialUrls.compactMap(URL.init)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal", for: indexPath) as! PhotoCell
        cell.display(image: nil)

        let op = NetworkImageOperation(url: urls[indexPath.row])
        op.completionBlock = {
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell
                else { return }

                cell.isLoading = false
                cell.display(image: op.image)
            }
        }

        queue.addOperation(op)

        return cell
    }
}
