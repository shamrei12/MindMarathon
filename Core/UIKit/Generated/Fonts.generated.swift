// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
public typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
public enum PFFontFamily {
  public enum SFProText {
    public static let bold = FontConvertible(name: "SFProText-Bold", family: "SF Pro Text", path: "SF-Pro-Text-Bold.otf")
    public static let boldItalic = FontConvertible(name: "SFProText-BoldItalic", family: "SF Pro Text", path: "SF-Pro-Text-BoldItalic.otf")
    public static let heavy = FontConvertible(name: "SFProText-Heavy", family: "SF Pro Text", path: "SF-Pro-Text-Heavy.otf")
    public static let heavyItalic = FontConvertible(name: "SFProText-HeavyItalic", family: "SF Pro Text", path: "SF-Pro-Text-HeavyItalic.otf")
    public static let italic = FontConvertible(name: "SFProText-Italic", family: "SF Pro Text", path: "SF-Pro-Text-RegularItalic.otf")
    public static let light = FontConvertible(name: "SFProText-Light", family: "SF Pro Text", path: "SF-Pro-Text-Light.otf")
    public static let lightItalic = FontConvertible(name: "SFProText-LightItalic", family: "SF Pro Text", path: "SF-Pro-Text-LightItalic.otf")
    public static let medium = FontConvertible(name: "SFProText-Medium", family: "SF Pro Text", path: "SF-Pro-Text-Medium.otf")
    public static let mediumItalic = FontConvertible(name: "SFProText-MediumItalic", family: "SF Pro Text", path: "SF-Pro-Text-MediumItalic.otf")
    public static let regular = FontConvertible(name: "SFProText-Regular", family: "SF Pro Text", path: "SF-Pro-Text-Regular.otf")
    public static let semibold = FontConvertible(name: "SFProText-Semibold", family: "SF Pro Text", path: "SF-Pro-Text-Semibold.otf")
    public static let semiboldItalic = FontConvertible(name: "SFProText-SemiboldItalic", family: "SF Pro Text", path: "SF-Pro-Text-SemiboldItalic.otf")
    public static let all: [FontConvertible] = [bold, boldItalic, heavy, heavyItalic, italic, light, lightItalic, medium, mediumItalic, regular, semibold, semiboldItalic]
  }
  public static let allCustomFonts: [FontConvertible] = [SFProText.all].flatMap { $0 }
  public static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

public struct FontConvertible {
  public let name: String
  public let family: String
  public let path: String

  #if os(macOS)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public func swiftUIFont(size: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  public func swiftUIFont(fixedSize: CGFloat) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, fixedSize: fixedSize)
  }

  @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
  public func swiftUIFont(size: CGFloat, relativeTo textStyle: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
    return SwiftUI.Font.custom(self, size: size, relativeTo: textStyle)
  }
  #endif

  public func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate func registerIfNeeded() {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: family).contains(name) {
      register()
    }
    #elseif os(macOS)
    if let url = url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      register()
    }
    #endif
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

public extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    font.registerIfNeeded()
    self.init(name: font.name, size: size)
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, size: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size)
  }
}

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public extension SwiftUI.Font {
  static func custom(_ font: FontConvertible, fixedSize: CGFloat) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, fixedSize: fixedSize)
  }

  static func custom(
    _ font: FontConvertible,
    size: CGFloat,
    relativeTo textStyle: SwiftUI.Font.TextStyle
  ) -> SwiftUI.Font {
    font.registerIfNeeded()
    return custom(font.name, size: size, relativeTo: textStyle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
