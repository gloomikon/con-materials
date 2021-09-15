import UIKit
import PlaygroundSupport

/*:
Tell the playground to continue running, even after it thinks execution has ended.
You need to do this when working with background tasks.
 */

PlaygroundPage.current.needsIndefiniteExecution = true

let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInteractive)
let semaphore = DispatchSemaphore(value: 2)

let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
let ids = [ 466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052 ]

var images: [UIImage] = []

let urls = ids.map { URL(string: "\(base)\($0)-jpeg.jpg")! }

queue.async(group: group) {
    urls.forEach { url in
        semaphore.wait()
        group.enter()

        let _ = URLSession.shared.dataTask(with: url) { data, _, error in
            defer {
                group.leave()
                semaphore.signal()
            }

            guard error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                return
            }

            images.append(image)
        }.resume()
    }
}

group.notify(queue: .main) {
    images[0]
}

PlaygroundPage.current.finishExecution()
