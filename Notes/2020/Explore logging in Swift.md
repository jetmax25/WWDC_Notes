[Explore logging in Swift](https://developer.apple.com/videos/play/wwdc2020/10168/)

Record events that are archived for later usage


>`import os`
>`let logger = Logger(subsystem:"com.example.pickledGames", category: "testCat")`
>`logger.log("Started a task")`

Logs are not converted to a string

Any type conforming to `CustomStringConvertable`

Nonnumeric values are redacted by default unless `privacy .public`
> `logger.log("Username is \(userName, privacy: .public)")`

Retrieve logs from device on the command line 

>`%log collect --device --start '2020-06-22 9:41:00' --output myProject.logarchive`

View and filter log archives in Console.app

Debug Levels 
* **Debug** - Usefult only durring debugging
* **Info** - Helpful but not essential for troubleshooting
* **Notice(Default)** - Essential for troubleshooting
* **Error** - Error seen during execution
* **Fault** - Bug in program

More percistance but less peformance as it goes down 

Redact data with equality preserving hash
>`logger.log("\({{sensitiveData}}, privacy: .private(mask: .hash")")`