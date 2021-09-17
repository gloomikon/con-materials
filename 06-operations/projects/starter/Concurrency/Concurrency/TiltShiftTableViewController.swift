import UIKit

class TiltShiftTableViewController: UITableViewController {
    private let queue = OperationQueue()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal", for: indexPath) as! PhotoCell
        cell.display(image: nil)

        let name = "\(indexPath.row).png"
        let image = UIImage(named: name)!

        let op = TiltShiftOperation(image: image)
        op.completionBlock = {
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath)
                        as? PhotoCell else { return }

                cell.isLoading = false
                cell.display(image: op.outputImage)
            }
        }

        queue.addOperation(op)

        return cell
    }
}
