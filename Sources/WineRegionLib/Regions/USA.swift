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
            case atlas_peak
            case calistoga
            case chiles_valley
            case coombsville
            case diamond_mountain_district
            case howell_mountain
            case mt_veeder
            case oak_knoll_district_of_napa_valley
            case oakville
            case rutherford
            case spring_mountain_district
            case napaValley = "napa_valley"
            case stHelena = "st__helena"
            case stags_leap_district
            case wild_horse_valley
            case yountville
        }

        public enum Other: String, AppelationDescribable, CaseIterable {
            case losCarneros = "los_carneros"
            case central_coast
            case alexander_valley
            case alisos_canyon
            case alta_mesa
            case antelope_valley_of_the_california_high_desert
            case ben_lomond_mountain
            case borden_ranch
            case capay_valley
            case clarksburg
            case clements_hills
            case cosumnes_river
            case covelo
            case cucamonga_valley
            case diablo_grande
            case dos_rios
            case dunnigan_hills
            case inwood_valley
            case jahant
            case leona_valley
            case lodi
            case madera
            case malibu_coast
            case malibu_newton_canyon
            case manton_valley
            case merritt_island
            case mokelumne_river
            case north_coast
            case northern_sonoma
            case petaluma_gap
            case river_junction
            case saddle_rock__malibu
            case salado_creek
            case santa_cruz_mountains
            case seiad_valley
            case sierra_foothills
            case sierra_pelona_valley
            case sloughhouse
            case south_coast
            case squaw_valley_miramonte
            case tracy_hills
            case trinity_lakes
            case willow_creek
            case york_mountain
        }

        public enum SierraFoothills: String, AppelationDescribable, CaseIterable {
            case california_shenandoah_valley
            case el_dorado
            case fair_play
            case fiddletown
            case north_yuba
        }

        public enum NorthCoast: String, AppelationDescribable, CaseIterable {
            case alexanderValley = "alexander_valley"
            case anderson_valley
            case benmore_valley
            case bennett_valley
            case big_valley_district_lake_county
            case chalk_hill
            case clear_lake
            case cole_ranch
            case dry_creek_valley
            case eagle_peak_mendocino_county
            case fort_ross_seaview
            case fountaingrove_district
            case green_valley_of_russian_river
            case guenoc_valley
            case high_valley
            case kelsey_bench_lake_county
            case knights_valley
            case mcdowell_valley
            case mendocino
            case mendocino_ridge
            case moon_mountain_district_sonoma_county
            case pine_mountain_cloverdale_peak
            case potter_valley
            case red_hills_lake_county
            case redwood_valley
            case rockpile
            case russian_river_valley
            case solano_county_green_valley
            case sonoma_coast
            case sonoma_mountain
            case sonoma_valley
            case suisun_valley
            case yorkville_highlands

        }

        public enum SouthCoast: String, AppelationDescribable, CaseIterable {
            case ramona_valley
            case san_pasqual_valley
            case temecula_valley
        }

        public enum Sonoma: String, AppelationDescribable, CaseIterable {
            case sonomaValley = "sonoma_valley"
            case northernSonoma = "northern_sonoma"
            case oakville
            case dryCreekValley = "dry_creek_valley"
            case petalumaGap = "petaluma_gap"
            case mendocino
        }

        public enum PasoRobles: String, AppelationDescribable, CaseIterable {
            case paso_robles
            case paso_robles_estrella_district
            case paso_robles_geneseo_district
            case paso_robles_highlands_district
            case paso_robles_willow_creek_district
        }

        public enum CentralCoast: String, AppelationDescribable, CaseIterable {
            case ballard_canyon
            case carmel_valley
            case adelaida_district
            case arroyo_grande_valley
            case cienega_valley
            case arroyo_seco
            case chalone
            case creston_district
            case edna_valley
            case el_pomar_district
            case hames_valley
            case happy_canyon_of_santa_barbara
            case lamorinda
            case lime_kiln_valley
            case livermore_valley
            case los_olivos_district
            case monterey
            case mt__harlan
            case pacheco_Pass
            case paicines
            case san_antonio_valley
            case san_benito
            case san_bernabe
            case san_francisco_bay
            case san_juan_creek
            case san_lucas
            case san_miguel_district
            case santa_ynez_valley
            case san_ysidro_district
            case santa_clara_valley
            case santa_lucia_highlands
            case santa_margarita_ranch
            case santa_maria_valley
            case sta__rita_hills
            case templeton_gap_district
        }
    }


}

extension RawRepresentable where RawValue == String {
    public var description: String { rawValue.appelationDescription }
    public var url: URL { rawValue.appelationURL }
}
