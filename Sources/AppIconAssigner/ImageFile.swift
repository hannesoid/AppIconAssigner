//
//  File 2.swift
//  
//
//  Created by Hannes Oud on 19.04.20.
//

import Foundation
import CoreGraphics


struct ImageFile {

    let url: URL
    let pixelSize: CGSize

    init?(url: URL) {
        guard url.isFileURL else { return nil }
        guard let size = Self.imageSizeUsingCGImageProperties(url: url) else { return nil }

        self.url = url
        self.pixelSize = size
    }

    static func imageSizeUsingCGImageProperties(url: URL) -> CGSize? {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }

        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else { return nil }
        guard let width = properties[kCGImagePropertyPixelWidth] as? CGFloat, let height = properties[kCGImagePropertyPixelHeight] as? CGFloat else { return nil }

        let orientation: CGImagePropertyOrientation = (properties[kCGImagePropertyOrientation] as? CGImagePropertyOrientation.RawValue).flatMap(CGImagePropertyOrientation.init) ?? CGImagePropertyOrientation.up
        func fixOrientation(size: CGSize, orientation: CGImagePropertyOrientation) -> CGSize {
            switch orientation {
            case .up, .upMirrored, .down, .downMirrored:
                return CGSize(width: size.width, height: size.height)
            case .leftMirrored, .left, .right, .rightMirrored:
                return CGSize(width: size.height, height: size.width)
            }
        }

        let size = fixOrientation(size: CGSize(width: width, height: height), orientation: orientation)
        return size
    }
}
