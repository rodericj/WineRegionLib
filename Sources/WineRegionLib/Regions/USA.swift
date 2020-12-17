//
//  File.swift
//  
//
//  Created by Roderic Campbell on 12/5/20.
//

import Foundation

fileprivate extension String {
    var appelationDescription: String {
        // Ultimately this capitalizes the string and splits on the capitals so "abcDeFG" becomes "Abc De Fg"
        capitalizeAndSplit()
            .capitalized
            .replacingOccurrences(of: "P D O", with: "PDO")
            .replacingOccurrences(of: "_", with: "")
            .replacingOccurrences(of: "  ", with: " ")
    }

    var appelationURL: URL {
        let root = "https://raw.githubusercontent.com/rodericj/ava/master/avas/"
        return URL(string: "\(root)\(self).geojson")!
    }
}

public struct USA {
    public static let title = "USA"
    public struct California {
        public struct Napa {
            public enum Appelation: String, AppelationDescribable, CaseIterable {

                public var description: String { rawValue.appelationDescription }
                public var url: URL { rawValue.appelationURL }
                
                case napaValley = "napa_valley"
                case stHelena = "st__helena"
                case losCarneros = "los_carneros"
            }
        }
        public struct Sonoma {
            public enum Appelation: String, AppelationDescribable, CaseIterable {
                public var description: String { rawValue.appelationDescription }
                public var url: URL { rawValue.appelationURL }

                case sonomaValley = "sonoma_valley"
                case northernSonoma = "northern_sonoma"
                case oakville
                case dryCreekValley = "dry_creek_valley"
                case petalumaGap = "petaluma_gap"
                case alexanderValley = "alexander_valley"
                case mendocino
            }
        }

        public struct CentralCoast {
            public enum Appelation: String, AppelationDescribable, CaseIterable {
                public var description: String { rawValue.appelationDescription }
                public var url: URL { rawValue.appelationURL }

                case pasoRobles = "paso_robles"
                case santaYnezValley = "santa_ynez_valley"
            }
        }
    }
}
