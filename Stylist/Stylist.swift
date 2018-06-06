//
//  Stylist.swift
//  Stylist
//
//  Created by Yonas Kolb on 18/8/17.
//  Copyright © 2017 Stylist. All rights reserved.
//

import Foundation
import KZFileWatchers

public class Stylist {

    public static let shared = Stylist()

    var styleables: [WeakContainer<AnyObject>] = []

    var properties: [StyleProperty] = []
    var objects: [StyleObject] = []

    public var themes: [String: Theme] = [:] {
        didSet {
            // combine all theme styles and sort by specificity
            styles = themes.values.reduce([]) { $0 + $1.styles }.sorted()
        }
    }

    private var styles: [StyleSelector] = []

    init() {
        addDefaultProperties()
        UIView.setupSwizzling()
        UIViewController.setupSwizzling()
    }

    func addDefaultProperties() {
        properties += View.styleProperties
        properties += UIBarItem.styleProperties
        properties += UIViewController.styleProperties

        objects += UIViewController.styleObjects
        objects += View.styleObjects
    }

    public func addProperty(_ property: StyleProperty) {
        properties.append(property)
    }

    public func addObject(_ object: StyleObject) {
        objects.append(object)
    }

    public func clear() {
        styleables = []
        themes = [:]
        properties = []
        addDefaultProperties()
    }

    func getValidProperties(name: String, view: Any) -> [StyleProperty] {
        return properties.filter { $0.canStyle(name: name, view: view) }
    }

    func apply(style: StyleSelector, animateChanges: Bool = false) {
        styleables.compactMap { $0.value as? Styleable }
            .forEach { styleable in
                guard style.applies(to: styleable) else { return }
                if animateChanges {
                    UIView.animate(withDuration: 0.2) {
                        if let view = styleable as? UIView, let parent = view.superview {
                            parent.layoutIfNeeded()
                        }
                        self.apply(style: style.style, to: styleable)
                    }
                } else {
                    apply(style: style.style, to: styleable)
                }
        }
    }

    func apply(theme: Theme, animateChanges: Bool = false) {
        for style in theme.styles.sorted() {
            apply(style: style, animateChanges: animateChanges)

            for property in style.style.properties {
                if !properties.contains(where: { $0.name == property.name }) {
                    print("Theme contains unknown property: \(property.name)")
                }
            }
        }
    }

    func apply(style: Style, to styleable: Any) {

        for styleProperty in style.properties {

            guard styleProperty.context.styleContext.targets(styleable: styleable) else { continue }

            let properties = getValidProperties(name: styleProperty.name, view: styleable)
            for property in properties {
                do {
                    try property.apply(styleable, styleProperty)
                } catch {
                    print("Could not parse property: \(error)")
                }
            }
        }

        for (name, subStyle) in style.subStyles {
            for styleableProperty in objects {
                if styleableProperty.canStyle(name: name, view: styleable),
                    let styleable = styleableProperty.getStyleable(styleable) {
                    apply(style: subStyle, to: styleable)
                }
            }
        }
    }

    /// Style a Styleable class
    ///
    /// - Parameter styleable: The class to style. eg a UIView
    public func style(_ styleable: Styleable) {
        if !styleables.contains(where: { $0.value === styleable}) {
            styleables.append(WeakContainer(styleable))
        }
        for style in styles {
            guard style.applies(to: styleable) else { continue }
            apply(style: style.style, to: styleable)
        }
    }

    /// Loads a Theme from a file
    ///
    /// - Parameter path: the path to the file. Can be either a yaml or json file
    /// - Throws: throws if the file is not found or parsing fails
    public func load(path: String) throws {
        let theme = try Theme(path: path)
        addTheme(theme, name: path)
    }

    /// Adds a Theme with a name
    public func addTheme(_ theme: Theme, name: String) {
        themes[name] = theme
        apply(theme: theme)
    }

    /// Watch a Theme file and automatically reload and applies if there are changes
    ///
    /// - Parameters:
    ///   - url: the url to the Theme. This can be a local file url or a remote url
    ///   - animateChanges: whether to apply a small UIView animation when new changes are applied
    ///   - parsingError: is called if there was an error parsing the theme.
    ///     It contains finge grained info about why the theme was invalid
    /// - Returns: The file watcher, which can later be stopped
    /// - Throws: An error is thrown if the file couldn't be watched
    @discardableResult
    public func watch(url: URL, animateChanges: Bool = true, parsingError: @escaping (ThemeError) -> Void) -> FileWatcherProtocol {
        let fileWatcher: FileWatcherProtocol
        if url.isFileURL {
            fileWatcher = FileWatcher.Local(path: url.path)
        } else {
            fileWatcher = FileWatcher.Remote(url: url)
        }

        var hasLoaded = false
        let stylist = self
        do {
            try fileWatcher.start { result in
                switch result {
                case .noChanges:
                    break
                case let .updated(data):
                    do {
                        let theme = try Theme(data: data)
                        self.themes[url.path] = theme
                        stylist.apply(theme: theme, animateChanges: animateChanges && hasLoaded)
                        hasLoaded = true
                    } catch let error as ThemeError {
                        parsingError(error)
                    } catch {
                        // unknown error occured
                    }
                }
            }
        } catch {
            parsingError(ThemeError.notFound)
        }
        return fileWatcher
    }
}

struct WeakContainer<T: AnyObject> {
    weak var value: T?

    init(_ value: T) {
        self.value = value
    }
}
