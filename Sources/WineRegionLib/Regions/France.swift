//
//  File.swift
//  
//
//  Created by Roderic Campbell on 12/4/20.
//

import Foundation


public struct France {
    public static let title = "France"
    public struct Burgundy {
        public static let title = "Burgundy"
        public enum Appelation: String, AppelationDescribable, CaseIterable {
            public var description: String {
                switch self {
                case .coteDeBeaune: return "Beaune"
                }
            }

            public var url: URL {
                switch self {
                case .coteDeBeaune:
                    return URL(string: "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/France/Burgundy/CoteDeBeaune.geojson")!
                }
            }
            case coteDeBeaune
        }
    }
    public struct Bordeaux {
        public func appelation(named: String) -> AppelationDescribable? {
            switch named {
            case "St. Julien":
                return Appelation.st_Julien
            default:
                return nil
            }
        }
        public static let title = "Bordeaux"
        public enum Appelation: String, AppelationDescribable, CaseIterable {

            public var description: String {

                // Ultimately this capitalizes the string and splits on the capitals so "abcDeFG" becomes "Abc De Fg"
                // We also replace P D O with PDO and a few other simple replacements

                let doctoredString = rawValue.capitalizeAndSplit()
                return doctoredString
                    .capitalized
                    .replacingOccurrences(of: "P D O", with: "PDO")
                    .replacingOccurrences(of: "_", with: "")
                    .replacingOccurrences(of: "  ", with: " ")
            }

            private var urlableName: String {
                self.rawValue
                    .capitalizeFirst
                    .replacingOccurrences(of: "_", with: "-")
                    .appending("-AOP_Bordeaux_France.geojson")
                    .replacingOccurrences(of: "PDO-Bordeaux-France-AOP_Bordeaux_France", with: "PDO_Bordeaux_France") // A very specific edge case
            }

            public var url: URL {
                print(urlableName)
                switch self {
                default:
                    return URL(string: "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/\(urlableName)")!
                }
            }

            case barsac
            case blaye
            case bordeaux
            case canon_Fronsac
            case cerons
            case cotes_de_Blaye
            case cotes_de_Bordeaux_St_Macaire_PDO_Bordeaux_France
            case cotes_de_Bourg
            case entre_Deux_Mers
            case fronsac
            case graves
            case graves_Superieures
            case Haut_Medoc
            case lalande_de_Pomerol
            case listrac_Medoc
            case loupiac
            case lussac_St_Emilion
            case margaux
            case medoc
            case moulis_en_Medoc
            case pauillac
            case pessac_Leognan
            case pomerol
            case puisseguin_St_Emilion
            case sauternes_PDO_Bordeaux_France
            case st_Croix_du_Mont
            case st_Emilion
            case st_Estephe
            case st_Foy_Bordeaux
            case st_Georges_St_Emilion
            case st_Julien


        }
    }

}
