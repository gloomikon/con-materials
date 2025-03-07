import UIKit
import PlaygroundSupport

/*:
 Tell the playground to continue running, even after it thinks execution has ended.
 You need to do this when working with background tasks.
 */

PlaygroundPage.current.needsIndefiniteExecution = true

let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInitiated)

queue.async(group: group) {
    print("Start job 1")
    Thread.sleep(until: Date().addingTimeInterval(10))
    print("End job 1")
}

queue.async(group: group) {
    print("Start job 2")
    Thread.sleep(until: Date().addingTimeInterval(2))
    print("End job 2")
}

if group.wait(timeout: .now() + 5) == .timedOut {
    print("I got tired of waiting")
} else {
    print("All the jobs have completed")
}

PlaygroundPage.current.finishExecution()
