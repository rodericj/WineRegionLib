//
//  File.swift
//  
//
//  Created by Roderic Campbell on 12/5/20.
//

import Foundation

public struct USA {
    public static let title = "USA"
    public struct California {
        public static let title = "California"
        public enum Appelation: String, AppelationDescribable, CaseIterable {
            public var description: String {
                rawValue
            }

            public var url: URL {
                let root = "https://raw.githubusercontent.com/rodericj/ava/master/avas/"
                return URL(string: "\(root)\(rawValue).geojson")!
            }
            case mendocino
            case napaValley = "napa_valley"
            case dryCreekValley = "dry_creek_valley"
            case stHelena = "st__helena"
            case northernSonoma = "northern_sonoma"
            case oakville
            case pasoRobles = "paso_robles"
            case petalumaGap = "petaluma_gap"
            case losCarneros = "los_carneros"
            case santaYnezValley = "santa_ynez_valley"
            case sonomaValley = "sonoma_valley"
            case alexanderValley = "alexander_valley"
        }
    }
}
