# Stylist

Stylist lets you define UI styles in a hotloadable external yaml or json file

- ✅ **Group styles** in a human readable way
- ✅ Apply styles through code or **Interface Builder**
- ✅ **Hotload** styles to see results immediatly without compiling
- ✅ Built in style properties for all popular **UIKit** classes
- ✅ Reference **variables** for commonly used properties
- ✅ Reference **styles** in other styles for a customizable heirachy
- ✅ Define **custom** properties and custom parsing to set any property you wish

Example style file:

```yaml
variables:
  primaryColor: DB3B3B
  headingFont: Ubuntu
styles:
  primaryButton:
    backgroundImage: buttonBack
    textColor: 55F
    contentEdgeInsets: [10,5]
    font: $headingFont:16
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
```

## Style Properties
Many UIKit views and bar buttons have built in properties that you can set. These can be viewed in [Style Properties](docs/StyleProperties.MD).

Custom properties and parsers can also be defined to let you configure anything you wish
