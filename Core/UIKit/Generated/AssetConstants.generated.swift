// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum PFAssets {
  public static let accentColor = ColorAsset(name: "AccentColor")
  public static let binarioCell = ImageAsset(name: "BinarioCell")
  public static let bullsAndCowsCell = ImageAsset(name: "BullsAndCowsCell")
  public static let floodFillCell = ImageAsset(name: "FloodFillCell")
  public static let slovusCell = ImageAsset(name: "SlovusCell")
  public static let ticTacToeCell = ImageAsset(name: "TicTacToeCell")
  public static let o = ImageAsset(name: "O")
  public static let x = ImageAsset(name: "X")
  public static let americanFlag = ImageAsset(name: "americanFlag")
  public static let arrowUP = ImageAsset(name: "arrowUP")
  public static let gameElementColor = ColorAsset(name: "gameElementColor")
  public static let numbersBackground = ColorAsset(name: "numbersBackground")
  public static let numbersFieldBackground = ColorAsset(name: "numbersFieldBackground")
  public static let viewColor = ColorAsset(name: "viewColor")
  public static let binarioImage = ImageAsset(name: "binarioImage")
  public static let bulbNumbers = ImageAsset(name: "bulbNumbers")
  public static let bull = ImageAsset(name: "bull")
  public static let bullCowImage = ImageAsset(name: "bullCowImage")
  public static let coin = ImageAsset(name: "coin")
  public static let cow = ImageAsset(name: "cow")
  public static let diamond = ImageAsset(name: "diamond")
  public static let empty = ImageAsset(name: "empty")
  public static let facebook = ImageAsset(name: "facebook")
  public static let floodFillImage = ImageAsset(name: "floodFillImage")
  public static let globe = ImageAsset(name: "globe")
  public static let gmail = ImageAsset(name: "gmail")
  public static let iconDark = ImageAsset(name: "icon_dark")
  public static let iconLight = ImageAsset(name: "icon_light")
  public static let labelGame = ImageAsset(name: "labelGame")
  public static let letter = ImageAsset(name: "letter")
  public static let message = ImageAsset(name: "message")
  public static let numbersImage = ImageAsset(name: "numbersImage")
  public static let padlock = ImageAsset(name: "padlock")
  public static let plusNumbers = ImageAsset(name: "plusNumbers")
  public static let rating = ImageAsset(name: "rating")
  public static let russianFlag = ImageAsset(name: "russianFlag")
  public static let slovusImage = ImageAsset(name: "slovusImage")
  public static let telegram = ImageAsset(name: "telegram")
  public static let tikTakToeImage = ImageAsset(name: "tikTakToeImage")
  public static let userImage0 = ImageAsset(name: "userImage0")
  public static let userImage1 = ImageAsset(name: "userImage1")
  public static let userImage2 = ImageAsset(name: "userImage2")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
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
