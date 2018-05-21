#  Stylist 🎨

[![Build Status](https://img.shields.io/circleci/project/github/yonaskolb/Stylist.svg?style=for-the-badge)](https://circleci.com/gh/yonaskolb/Stylist)
[![license](https://img.shields.io/github/license/yonaskolb/Stylist.svg?style=for-the-badge)](https://github.com/yonaskolb/Stylist/blob/master/LICENSE)

Stylist lets you define UI styles in a hot-reloadable external yaml or json theme file

- ✅ Define styles in **external themes**
- ✅ Apply styles through code or **Interface Builder**
- ✅ **Hotload** themes to see results immediatly without recompiling
- ✅ **Swap** entire themes on the fly
- ✅ Built in style properties for all popular **UIKit** classes
- ✅ Reference **variables** for commonly used properties
- ✅ Reference **styles** in other styles for a customizable heirachy
- ✅ Define **custom** strongly type properties and custom parsing to set any property you wish

Example theme:

```yaml
variables:
  primaryColor: DB3B3B
  headingFont: Ubuntu
styles:
  primaryButton:
    backgroundImage: buttonBack
    backgroundImage:highlighted: buttonBack-highlighted
    textColor: 55F
    textColor:highlighted: white
    contentEdgeInsets: [10,5]
    font(device:iphone): $headingFont:16
    font(device:ipad): $headingFont:22
  secondaryButton:
    backgroundColor: $primaryColor
    cornerRadius: 10
    textColor: white
    font: 20
    contentEdgeInsets: 6
  sectionHeading:
    font: title 2
    color: darkGray
  themed:
    tintColor: $primaryColor
  mainSection:
    styles: [themed]
```

## ⬇️ Installing

#### Cocoapods
Add the following to your `podfile`

```
pod 'Stylist', :git=> 'https://github.com/yonaskolb/Stylist'
```

## 🎨 Theme
A theme file has a list of `variables` and a list of `styles` each referenced by name.
Variables can be referenced in styles using `$variableName`.

To set a style on a UIView, simply set it's `style` property:

```swift
myView.style = "myStyle"
```
A style can also be set in Interface Builder in the property inspector.


To load a Theme simply call:

```swift
Stylist.shared.load(path: pathToFile)
```

You can load multiple themes, and they will all be applied as long as they have different paths

## 🖌 Style Properties
Many UIKit views and bar buttons have built in properties that you can set. These can be viewed in [Style Properties](Docs/StyleProperties.MD).
Each style can also reference an array of other styles that will be merged in order

## 🔥 Hot Reloading
You can choose to watch a file, which means that whever that file is changed the styles are reloaded. The file can be a local file on disk or a remote file.
This can be very useful while developing, as you can make changes on your device without recompiling and see the results instantly! To watch a file simply call `watch` on stylist and pass in a URL:

```swift
Stylist.shared.watch(url: fileOrRemoteURL, animateChanges: true) { error in
  print("An error occured while loading or parsing the file")
}
```
If an error occurs at any time the `parsingError` callback will be called with a `ThemeError`, which will tell you exactly what went wrong including any formatting errors on invalid references. This means you can save an invalid theme without worrying that things will blow up.

To stop watching the file, you can call `stop()` on the `FileWatcher` that is returned.

Note that if a style property was present and you then remove it, Stylist cannot revert the change so that property will remain in the previous state.

## ⚙️ Custom Properties
Custom properties and parsers can also be added to let you configure anything you wish in a strongly typed way:

```swift
Stylist.shared.addProperty("textTransform") { (view: MyView, value: PropertyValue<MyProperty>) in
    view.myProperty = value.value
}
```
`addProperty` takes a style name a simply generic closure that sets your property on your view. This closure can contain any other logic you wish. The view can be NSObject and the property must conform to `StyleValue` which is a simply protocol:

```swift
public protocol StyleValue {
    associatedtype ParsedType
    static func parse(value: Any) -> ParsedType?
}
```

Many different types of properties are already supported and listed here in [Style Property Types](Docs/StyleProperties.MD#types)

The `PropertyValue` that get's passed into the closure will have a `value` property containing your parsed value. It also has a `context` which contains [property query values](Docs/StyleProperties.MD#queries) like device type,  UIControlState and UIBarMetrics.

When a theme is loaded or when a style is set on a view, these custom properties will be applied if the view type and property name match.

## 👥 Attributions

This tool is powered by:

- [KZFileWatchers](https://github.com/krzysztofzablocki/KZFileWatchers)
- [Yams](https://github.com/jpsim/Yams)

## 👤 Contributions
Pull requests and issues are welcome

## 📄 License

Stylist is licensed under the MIT license. See [LICENSE](LICENSE) for more info.
