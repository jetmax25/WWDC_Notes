# [Write tests to fail](https://developer.apple.com/videos/play/wwdc2020/10091)

## Test Result Bundle

Append launch arguments to app in setup
> `app.launchArguments.append("-launchArg")`

> `if CommandLine.arguments.contains("-LaunchArg") { }`

Can put tests in framework or package

Use `XCTUnwrap` as a guard let + `XCTAssertNotNil`, throws error if nil
`try XCTUnrap({{item}}, {{message}}`

use a string associated value with an error description in order to get a more readible error

`XCTContext.runActivity(name: String) { }` sets a block of code for tracing
Can add attachments to param