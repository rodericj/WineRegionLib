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

            // This maps to the geoJson field ava_id
            public var description: String {
                switch self {
                case .napa:
                    return "napa_valley"
                //                    case .santaCruz:
                //                        return "santa_cruz_mountains"
                case .centralCoast:
                    return "central_coast"
                //                    case .saintHelena:
                //                        return "saint__helena"
                case .mendocinoCounty:
                    return "mendocino"
                case .dryCreekValley:
                    return "dry_creek_valley"
                }
            }


            public var url: URL {
                return URL(string: "https://raw.githubusercontent.com/rodericj/ava/master/avas_by_state/CA_avas.geojson")!
            }
            case mendocinoCounty = "Mendocino County"
            case napa = "Napa Valley"
            case centralCoast
            case dryCreekValley = "Dry Creek Valley"
        }
    }
}
