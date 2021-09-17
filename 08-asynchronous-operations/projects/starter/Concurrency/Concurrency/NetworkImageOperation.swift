import UIKit

typealias ImageOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
    var image: UIImage?

    private let url: URL
    private let completion: ImageOperationCompletion

    init(url: URL, completion: ImageOperationCompletion = nil) {
        self.url = url
        self.completion = completion

        super.init()
    }

    convenience init?(string: String, completion: ImageOperationCompletion = nil) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url, completion: completion)
    }

    override func main() {
        URLSession.shared.dataTask(with: url) { [weak self] data, responce, error in
            guard let self = self else {
                return
            }

            defer {
                self.state = .finished
            }

            if let completion = self.completion {
                completion(data, responce, error)
                return
            }

            guard let data = data, error == nil else {
                return
            }

            self.image = UIImage(data: data)

        }.resume()
    }

}
