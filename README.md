# Stylist

Stylist lets you define UI styles in a hotloadable external yaml or json file

- ✅ **Group** styles in a human readable way
- ✅ Apply styles through code or **Interface Builder**
- ✅ **Hotload** styles file to see results immediatly without compiling
- ✅ Built in style properties for all popular **UIKit** classes
- ✅ **Reference variables** in your style file that let you specify commonly used properties
- ✅ **Reference styles** in other styles
- ✅ Define **custom** properties and custom parsing to set any property you wish

Example style file:

```yaml
variables:
  primaryColor: DB3B3B
  headingFont: Ubuntu
styles:
  primaryButton:
    backgroundColor: $primaryColor
    cornerRadius: 10
    textColor: white
    font: 20
    contentEdgeInsets: 6
  secondaryButton:
    backgroundImage: buttonBack
    textColor: 55F
    contentEdgeInsets: [10,5]
    font: $headingFont:16
  sectionHeading:
    font: title 2
    color: darkGray
  themed:
    tintColor: $primaryColor		
```

Many UIKit views have bar buttons have build in properties that you can set. These can be viewed in [Style Properties](docs/StyleProperties.MD)
