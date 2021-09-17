import UIKit

class TiltShiftTableViewController: UITableViewController {
  private let queue = OperationQueue()
  private var urls: [URL] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
      let contents = try? Data(contentsOf: plist),
      let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
      let serialUrls = serial as? [String] else {
        print("Something went horribly wrong!")
        return
    }

    urls = serialUrls.compactMap { URL(string: $0) }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return urls.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "normal", for: indexPath) as! PhotoCell
    cell.display(image: nil)
    cell.isLoading = true

    let downloadOperation = NetworkImageOperation(url: urls[indexPath.row])
    let tiltShiftOperation = TiltShiftOperation()
    tiltShiftOperation.onImageProcessed = { image in
      guard let cell = tableView.cellForRow(at: indexPath)
        as? PhotoCell else {
        return
      }

      cell.isLoading = false
      cell.display(image: image)
    }

    tiltShiftOperation.addDependency(downloadOperation)

//    tiltShiftOperation.completionBlock = {
//      DispatchQueue.main.async {
//        guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell else { return }
//
//        cell.isLoading = false
//
//        cell.display(image: tiltShiftOperation.image)
//      }
//    }

    queue.addOperation(downloadOperation)
    queue.addOperation(tiltShiftOperation)

    return cell
  }
}
