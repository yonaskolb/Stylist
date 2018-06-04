# Style Properties
- [Types](#types): The types of values you can specify
- [Context](#context): Restrict how properties are applied
- [Properties](#properties): Built in properties

# Types
### Color
Colors can be specified in hex or name along with an optional alpha

- **Hex**: Can be written with or without a prepending #, with differing amounts of characters:
	- 3 (RGB)
	- 6 (RRGGBB)
	- 8 (RRGGBBAA) with the last 2 controlling alpha
- **Name**: The name of a built in UIColor name
- **Alpha**: If a color is suffixed with `:` and then a float from 0 to 1, an alpha is applied to the color.

These are all valid colors:

- `D22`
- `"#DD2222"`
- `DD2222AA`
- `DD2222:0.1`
- `white:0.5`
- `darkGray`

### Font
Fonts can be specified by font family, text style, system size, or system style. Size can be set by appending `:fontSize`

- **Font name**: `Ubuntu-Bold:20`
- **textStyle**: `title1`, `headline`
- **System**: `16`
- **System style**: `systemBold:14`, `systemThin:16`, `systemItalic:12`


The name of a font can also be referenced by variable and then still be given an explicit size: `$headingFont:20`

### Image
Images can be specified by name. If `none` is specified than an empty UIImage will be set

### LayoutAnchor
These are used for `widthAnchor` and `heightAnchor`. If string begins with `<=`, `>=` or `==` that relation will be used. If none is specified the constraint will default to `==`.

Examples:
	
- `<=30`
- `20`

Many other UIKit types are parsable too:

- String
- Int
- Double
- Bool
- Float
- CGFloat
- UIViewContentMode
- UIStackViewAlignment
- UIStackViewDistribution
- UILayoutConstraintAxis
- UIBarStyle
- UINavigationItem.LargeTitleDisplayMod
- UITabBarItemPositioning
- CGPoint
	- x, y: `10,10` 
- CGRect
 	- x, y, width, height: `10,10,30,30`
- CGSize
	- square: `5`
	- width, height: `10,20`
- UIOffset:
	- horizontal, vertical: `10,10` 
- UIEdgeInsets
	- all edges: `5`
	- leftRight, topBottom: `5,10`
	- top, left, bottom, right: `10,5,5,5`

# Context
There are a few ways to limit the scope of a property similar to media queries in CSS

### State

#### UIControlState
For properties that are specific to a UIControlState you can use the format

```yaml
property:controlState: value
```
for example: 

```yaml
textColor:highlighted: red
```

#### UIBarMetrics
For properties that are specific to a UIControlState you can use the format

```yaml
property:barMetrics: value
```
for example: 

```yaml
backgroundImage:compact: compact_bar
```

### Trait Collection

#### Device
Properties can be specific to a device using using the format: 

```yaml
property(device:UIUserInterfaceIdiom): value
```
for example: 

```yaml
font(device:iphone): MyFont:32
```

#### Size Class
Properties can be specified for a certain horizontal or vertical size class using the format: 

```yaml
property(horizontal/vertical:UIUserInterfaceSizeClass): value
```
for example: 

```yaml
font(h:regular): MyFont:32
```

All these contexts can be combined together
```yaml
font:highlighted(h:regular, v:compact, device:pad): MyFont:32
```

# Properties
- UIViewController
	- largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode
	- largeTitleDisplayMode: Bool 
- UIView
	- backgroundColor: Color
	- tintColor: Color
	- alpha: Double
	- borderColor: Color
	- cornerRadius: Double
	- clipsToBounds: Double
	- shadowOpacity: Double
	- shadowRadius: Double
	- shadowColor: Color
	- shadowOffset: CGSize
	- backgroundImagePattern: Image
	- contentMode: UIContentMode
	- visible: Bool (opposite of isHidden)
	- hidden: Bool (isHidden)
	- layoutMargins: UIEdgeInsets
- UIView constraints
	- widthAnchor: LayoutAnchor
	- heightAnchor: LayoutAnchor
	- aspectRatioAnchor: Double or a division (`0.5` or `1/2`)
- UIView frame
	- origin: CGPoint
	- size: CGSize
	- frame: CGRect 
- UIImageView
	- image: Image
- UIButton
	- backgroundImage:controlState: Image
	- imageEdgeInsets: UIEdgeInsets
	- titleEdgeInsets: UIEdgeInsets
	- contentEdgeInsets: UIEdgeInsets
	- textColor|titleColor: Color
	- font|titleFont: Font
- UISwitch:
	- onTintColor: Color
	- thumbTintColor: Color
- UILabel
	- font: Font
	- textColor: Color
	- text: String
- UITextView
	- font: Font
	- textColor: Color
	- text: String
- UITextField
	- font: Font
	- textColor: Color
	- text: String
- UIProgressBar
	- progressTintColor: Color
	- trackTintColor: Color
- UINavigationBar
	- barTintColor: Color
	- translucent: Bool (isTranslucent)
	- barStyle: UIBarStyle
	- shadowImage: Image
	- backgroundImage: Image
	- titleColor: Color
	- titleFont: Font
	- largeTitleColor: Color
	- largeTitleFont: Font
	- prefersLargeTitles: Bool
	- backIndicatorImage: Image
	- backIndicatorTransitionMaskImage: Image
- UITabBar:
	- barStyle: UIBarStyle
	- translucent: Bool (isTranslucent)
	- barTintColor: Color
	- shadowImage: Image
	- backgroundImage: Image
	- selectionIndicatorImage: Image
	- itemPositioning: UITabBarItemPositioning
	- unselectedItemTintColor: Color
- UISearchBar
	- backgroundImage: Image
- UIStackView
	- axis: UILayoutConstraintAxis
	- distribution: UIStackViewDistribution
	- spacing: CGFloat
	- alignment: UIStackViewAlignment
	- relativeMargins: Bool (isLayoutMarginsRelativeArrangement)
- UIBarItem
	- image: Image
- UIBarButtonItem
	- tintColor: Color
