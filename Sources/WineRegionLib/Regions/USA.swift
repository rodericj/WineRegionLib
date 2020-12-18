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
        public enum Napa: String, AppelationDescribable, CaseIterable {

            public var description: String { rawValue.appelationDescription }
            public var url: URL { rawValue.appelationURL }

            case napaValley = "napa_valley"
            case stHelena = "st__helena"
            case losCarneros = "los_carneros"

            case central_coast
            case north_coast
            case sierra_foothills
            case south_coast
            case san_francisco_bay
            case paso_robles
            case monterey
            case lodi
            case sonoma_coast
            case madera
            case antelope_valley_of_the_california_high_desert
            case el_dorado
            case santa_cruz_mountains
            case northern_sonoma
            case santa_clara_valley
            case mendocino
            case livermore_valley
            case clear_lake
            case petaluma_gap
            case santa_ynez_valley
            case russian_river_valley
            case malibu_coast
            case san_antonio_valley
            case cucamonga_valley
            case santa_maria_valley
            case sonoma_valley
            case trinity_lakes
            case capay_valley
            case temecula_valley
            case ramona_valley
            case mendocino_ridge
            case clements_hills
            case mokelumne_river
            case dry_creek_valley
            case alexander_valley
            case sloughhouse
            case borden_ranch
            case dunnigan_hills
            case clarksburg
            case paso_robles_estrella_district
            case paso_robles_highlands_district
            case anderson_valley
            case alta_mesa
            case adelaida_district
            case cosumnes_river
            case creston_district
            case san_benito
            case yorkville_highlands
            case squaw_valley_miramonte
            case arroyo_grande_valley
            case covelo
            case tracy_hills
            case knights_valley
            case fountaingrove_district
            case sta__rita_hills
            case ben_lomond_mountain
            case diablo_grande
            case san_lucas
            case arroyo_seco
            case fort_ross_seaview
            case red_hills_lake_county
            case redwood_valley
            case lamorinda
            case inwood_valley
            case potter_valley
            case jahant
            case san_juan_creek
            case eagle_peak_mendocino_county
            case fair_play
            case happy_canyon_of_santa_barbara
            case san_bernabe
            case chalk_hill
            case los_olivos_district
            case el_pomar_district
            case edna_valley
            case north_yuba
            case santa_lucia_highlands
            case carmel_valley
            case green_valley_of_russian_river
            case suisun_valley
            case templeton_gap_district
            case san_miguel_district
            case paicines
            case moon_mountain_district_sonoma_county
            case santa_margarita_ranch
            case paso_robles_geneseo_district
            case solano_county_green_valley
            case mt_veeder
            case paso_robles_willow_creek_district
            case dos_rios
            case high_valley
            case rockpile
            case california_shenandoah_valley
            case howell_mountain
            case calistoga
            case atlas_peak
            case hames_valley
            case fiddletown
            case coombsville
            case big_valley_district_lake_county
            case manton_valley
            case oak_knoll_district_of_napa_valley
            case san_pasqual_valley
            case kelsey_bench_lake_county
            case sierra_pelona_valley
            case leona_valley
            case chalone
            case spring_mountain_district
            case yountville
            case bennett_valley
            case mt__harlan
            case ballard_canyon
            case willow_creek
            case rutherford
            case cienega_valley
            case oakville
            case york_mountain
            case alisos_canyon
            case sonoma_mountain
            case guenoc_valley
            case chiles_valley
            case diamond_mountain_district
            case merritt_island
            case pine_mountain_cloverdale_peak
            case wild_horse_valley
            case stags_leap_district
            case salado_creek
            case Pacheco_Pass
            case san_ysidro_district
            case lime_kiln_valley
            case mcdowell_valley
            case seiad_valley
            case saddle_rock__malibu
            case river_junction
            case benmore_valley
            case malibu_newton_canyon
            case cole_ranch
        }
    }
    public enum Sonoma: String, AppelationDescribable, CaseIterable {
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


    public enum CentralCoast: String, AppelationDescribable, CaseIterable {
        public var description: String { rawValue.appelationDescription }
        public var url: URL { rawValue.appelationURL }

        case pasoRobles = "paso_robles"
        case santaYnezValley = "santa_ynez_valley"
    }
}
}
