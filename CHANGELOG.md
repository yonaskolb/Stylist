
## 0.2.0

#### Added
- Added support for styling `UIViewController` #7
- Added support for `UIViewController` in style containment selectors #7
- Added support for accessing sub objects in a style like `view`, `viewController`, `tabBar`, `navigationBar`, `toolBar`, `next`, `previous`, `superview`, and `parent` #7
- Made `UIView`, `UIBarItem` and `UIViewController` styles editable in the IB property inspector
- Added support for specifying multiple styles in IB by comma seperating them #6
- Added more stylable properties

#### Changed
- Styles are applied sorted by specifity #5

#### Fixed
- Fixed some project objects sometimes having duplicate ids
- Fixed the initial styling after watching a file being animated

[Commits](https://github.com/yonaskolb/XcodeGen/compare/0.1...0.2)

## 0.1.0
First official release