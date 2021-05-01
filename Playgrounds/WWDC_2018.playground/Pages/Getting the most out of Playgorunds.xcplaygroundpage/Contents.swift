/*:
 # [Gettint the Most out of Playgrounds](https://developer.apple.com/videos/play/wwdc2018/402/)

 ## [Markdown Reference](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html)
 */

import UIKit
import PlaygroundSupport

//: Setting a view to live view
let myView = UIView(frame: CGRect(x: 50, y: 50, width: 50, height: 50))
myView.backgroundColor = .blue
PlaygroundPage.current.liveView = myView

//: Setting a VC to live view
let myVC = UIViewController()
myVC.view.backgroundColor = .green
PlaygroundPage.current.liveView = myVC

//: !["whoops"](Anna_Art.jpg "hover title" width="200" height="150")

//: try running these line by line using the blue line numbers at the left
print("Line 1")

print("Line 4")

print("Line 3")

//: ## CustomPlaygroundDisplayConvertible
//: Cust `CustomPlaygroundDisplayConvertible` and `var playgroundDescription: Any`
struct MyType {
    let value: Int
    let color: UIColor
}

extension MyType: CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = color
        
        let label = UILabel()
        label.font = label.font.withSize(32)
        label.textAlignment = .center
        label.text = String(value)
        
        view.addSubview(label)
        label.frame = view.bounds
        
        return view
    }
}

let test = MyType(value: 5, color: .blue)
