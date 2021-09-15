import UIKit
import PlaygroundSupport

/*:
 Tell the playground to continue running, even after it thinks execution has ended.
 You need to do this when working with background tasks.
 */

PlaygroundPage.current.needsIndefiniteExecution = true

let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInitiated)

let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
let ids = [ 466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052 ]

var images: [UIImage] = []

let urls = ids.map { URL(string: "\(base)\($0)-jpeg.jpg")! }

let dispatchGroup = DispatchGroup()

DispatchQueue.global(qos: .utility).async(group: dispatchGroup) {
    urls.forEach { url in
        dispatchGroup.enter()

        let _ = URLSession.shared.dataTask(with: url) { data, _, error in
            defer { dispatchGroup.leave() }

            guard error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                return
            }

            images.append(image)
        }.resume()
    }
}

dispatchGroup.notify(queue: .main) {
    images[0]
}
