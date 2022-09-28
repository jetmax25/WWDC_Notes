//: [Previous](@previous)

import Foundation
import UIKit
import XCTest

/*: ## [Embrace Expected Failures in XCTest](https://developer.apple.com/videos/play/wwdc2021/10207/)

### Disable
Can disable in the scheme
 
Best for curating collection of tests
 
### XCTSkip
executes until skip is called
 manage configuration based limitations
 */
try XCTSkipUnless(UIDevice.current.userInterfaceIdiom == .pad, "Only supports iPad")
/*:
 
### XCTestExpectFailure
 - for when a failure is expected
 - test  goes to mixed state when failed
 - Allows multiple calls per test
 - Supports Nesting
 - for shared code use closure based api to lmit effects of nesting
 */
XCTExpectFailure("Fix Valid User Issue")

func testMyFunction() throws {
    let options = XCTExpectFailure.Options
    options.issueMatcher = { issue in
        return issue.type == .assertionFailure
    }
    
    #if os(macOS)
    options.isEnabled = false
    #endif
    XCTExpectFailure("Fix myFunction", options: options)
    XCTAssert(myFunction())
}

/*:
- Deterministic
    - enviorment
    - device type
    - os version
- Non Deterministic
    - timing
    - ordering
    - concurency
 
disabling Is strict allows test to pass if non deterministic
 
 `options.isStrict`
 `XCTExpectFailure("fix myfucntion", strict: false)`
 */

//:[Next](@next)
