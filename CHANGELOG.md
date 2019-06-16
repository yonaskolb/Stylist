
#### Master

## 0.3.0

#### Changed
- Updated to Swift 5
- Updated dependencies
- Don't calculate styles on a view if it is removed from its superview

[Commits](https://github.com/yonaskolb/XcodeGen/compare/0.2.2...0.3.0)

## 0.2.2

#### Changed
- Updated dependencies

[Commits](https://github.com/yonaskolb/XcodeGen/compare/0.2.1...0.2.2)

## 0.2.1

#### Fixed
- Fixed Carthage installations #9 thanks @drekka

[Commits](https://github.com/yonaskolb/XcodeGen/compare/0.2.0...0.2.1)

## 0.2.0

#### Added
- Added support for styling `UIViewController` #7
- Added support for `UIViewController` in style containment selectors #7
- Added support for accessing sub objects in a style like `view`, `viewController`, `tabBar`, `navigationBar`, `toolBar`, `next`, `previous`, `superview`, and `parent` #7
- Made `UIView`, `UIBarItem` and `UIViewController` styles editable in the IB property inspector
- Added support for specifying multiple styles in IB by comma separating them #6
- Added more styleable properties
- Added support for named colors from Asset Catalog #7

#### Changed
- Styles are applied sorted by specificity #5

#### Fixed
- Fixed nested style references

[Commits](https://github.com/yonaskolb/XcodeGen/compare/0.1.0...0.2.0)

## 0.1.0
First official release
