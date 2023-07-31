# [XCTSkip your tests](https://developer.apple.com/videos/play/wwdc2020/10164)

## XCTSkip
Pass can now skip instead of just pass/fail

> `throw XCTSkip("{{Message}}")`

> `try XCTSkipIf({{condition}})`

> `try XCTSkipUnless({{condition}})`

Tests are greyed out when skipped

Bottom right button in navigator shows the skipped tests