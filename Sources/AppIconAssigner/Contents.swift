//
//  File 2.swift
//  
//
//  Created by Hannes Oud on 19.04.20.
//

import Foundation
import CoreGraphics

struct Contents: Decodable {

    var images: [ImageEntry]
}

struct ImageEntry: Decodable {

    let size: CGSize
    let idiom: String
    let filename: String
    let scale: Int
    var pixelSize: CGSize { CGSize(width: self.size.width * CGFloat(self.scale), height: self.size.height * CGFloat(self.scale)) }

    enum CodingKeys: String, CodingKey {
        case size, idiom, filename, scale
    }

    internal init(size: CGSize, idiom: String, filename: String, scale: Int) {
        self.size = size
        self.idiom = idiom
        self.filename = filename
        self.scale = scale
    }

    // MARK: - Codable

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImageEntry.CodingKeys.self)
        let sizeString: String = try container.decode(String.self, forKey: .size)
        let scaleString: String = try container.decode(String.self, forKey: .scale)
        let idiom: String = try container.decode(String.self, forKey: .idiom)
        let filename: String = try container.decode(String.self, forKey: .filename)

        let sizeComponents = sizeString.components(separatedBy: "x").map { Double($0) }
        guard sizeComponents.count == 2 else { throw "Size not decodable \(sizeString)" }

        let size = CGSize(width: sizeComponents[0]!, height: sizeComponents[1]!)
        guard let scale = Int(scaleString.trimmingCharacters(in: .init(charactersIn: "x"))) else { throw "Scale not decodable \(scaleString)" }

        self.init(size: size, idiom: idiom, filename: filename, scale: scale)
    }

    // currently not used
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Self.CodingKeys.self)
        try container.encode(self.filename, forKey: .filename)
        try container.encode(self.idiom, forKey: .idiom)
        try container.encode("\(x: self.size.width)x\(x: self.size.height)", forKey: .size)
        try container.encode("\(self.scale)x", forKey: .scale)
    }

}

extension String: Error { }

private extension String.StringInterpolation {

    /// Append a number with maximum of 1 floating point fraction digit
    mutating func appendInterpolation(x: CGFloat) {
        let formatter = NumberFormatter()
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        self.appendInterpolation(formatter.string(from: NSNumber(value: Double(x))))
    }
}
