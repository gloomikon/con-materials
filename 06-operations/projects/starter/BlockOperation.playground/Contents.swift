import Foundation

let sentence = "Ray’s courses are the best!"
let wordOperation = BlockOperation()

for word in sentence.split(separator: " ") {
  wordOperation.addExecutionBlock {
    print(word)
    sleep(2)
  }
}

wordOperation.completionBlock = {
  print("Thank you for your patronage!")
}

duration {
  wordOperation.start()
}
