# [Tirange test failures with XCTissue](https://developer.apple.com/videos/play/wwdc2020/10687/)
 
 * Gray caught error means that the issue happened bellow but not at the line of code
 * Red annotation means it is the actual point of failure 
 * Test report breakdown has arrow to code to code or chain to open code in assitent 

## Swift Errors In Tests
tests themselves can throw
> `func testExample() throws {`
>   `try codeThatThrows()`    
> `}`

Set up and tear down with errors instead of standard set up and take down

## Rich Failure Objects
Object `XCTIssue`

* Failure Message
* File Path
* Line Number
* "Expected" flag


* Distinct Types
* Detailed Description
* Associated Error
* Attachments

`XCTAttachment` - captures arbitraty data

Recording XCTIssues
>```
> open class XCTestCase: XCTest {
>   open func record(_ issue: XCTIssue)
> }

## Failure Call Stacks
XCTIssue captures and symbolicates call stacks
possibly dont need to pass in line and file

## Advanced Workflows
>```
> func assertSomething(about: Data, file: staticString = #filePath, line: UInt = #line) {
>   // Call out to custom validation function
>   if !isValid(data) {
>       
>       //create issue declare with var for mutability
>       var issue = XCTIssue(type: .assertionFailure, compactDescription: "Invalid Data")
>       
>       //Attach invalid data
>       issue.add(XCTAttachment(data: data))
>       
>       //Capture the call site location as the point of failure
>       let location = XCTSourceCodeLocation(filePath: file, lineNumber: line)
>       issue.sourceCodeContext = XCTSourceCodeContext(location: location)
>
>       //Record the issue
>       self.record(issue) 
>   }    
>}

Can override record to add stuff like attachments or logging