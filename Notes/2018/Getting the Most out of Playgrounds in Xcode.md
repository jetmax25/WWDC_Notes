# [Gettint the Most out of Playgrounds](https://developer.apple.com/videos/play/wwdc2018/402/)

## [Markdown Reference](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html)

## Playground Support
`import PlaygroundSupport`

Viewing a live view or view controller `PlaygroundPage.current.liveView = myView` 

## Markup Text
Can toggle in either 
    * Editor -> Show Rendered Markup 
    * Inpector (top right) -> Render Documentation Checkbox

3 Levels of heading supported rather than the standard 6

## Sources 
Can add swift to either top level source file or page source files 
Sources are compiled as seperate modules

## Resources
Also top level or per page
Use in resource folder

Showing an image in markup
> `//:![alternate text](MyPicture.jpg "hover title" width="200" height="150")`

can also use in code 
>`let image = UIImage(named: MyPicture)`

Can also include video
>`![alternate text](MyVideo.mp4 poster = "MyPoster.jpg" width="50" height="50)`

Can use standard resource finder
>`let videoURL = Bundle.main.url(forResource: "MyVideo", withExtension: "mp4")`


## Step By Step
blue line on left side shows what is ready
can press the play button on that side to execute up to that line
must execute on a top level line

Shift + Return - run up to current line
When editing code above the blue line the playground resets automatically

Can write new code bellow executed code to keep executing without resetting

## Custom Playground Display Convertible
Non optimized types - display based on Custom String Convertable
* Without - structure
* With - display description

implement protocol `CustomPlaygroundDisplayConvertible` to choose what is displayed
> ```
> extension MyType: CustomPlaygroundDisplayConvertible {
>   var playgroundDescription: Any {  }
> }

Can be Textual or Graphical

Some types already have implementation

example: 
> ```
>extension MyType: CustomPlaygroundDisplayConvertible {
>    var playgroundDescription: Any {
>        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
>        view.backgroundColor = color
>       
>        let label = UILabel()
>        label.font = label.font.withSize(32)
>        label.textAlignment = .center
>        label.text = String(value)
>        
>        view.addSubview(label)
>        label.frame = view.bounds
>        
>        return view
>    }
>}
>
>let test = MyType(value: 5, color: .blue)

## Using Custom Frameworks In Playgrounds
Try adding a playground to a project or workspace itself

Once a playground is added to a project it can access the project/framework

Must build before running

Check built products directy to see if everything worked
> File -> Project Settings -> Advanced -> Click products directory

## Troubleshooting