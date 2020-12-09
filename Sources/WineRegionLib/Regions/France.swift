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
        public static let title = "Bordeaux"
        public struct Medoc {
            public static let title = "Medoc"
            public enum Appelation: String, AppelationDescribable, CaseIterable {
                // Note: The is used as geojson's first feature's property's name
                public var description: String {
                    switch self {
                    case .medoc: return "Medoc"
                    case .stJulien: return "Saint Julien"
                    case .hautMedoc: return "Haut-Medoc"
                    case .stEsteph: return "Saint-Estephe"
                    case .margaux: return "Margaux"
                    case .moulisEnMedoc: return "Moulis-en-Médoc"
                    case .pauillac: return "Pauillac"
                    case .sauternes: return "Sauternes"
                    case .graves: return "Graves"
                    }
                }

                public var url: URL {
                    let rootURLString = "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master"
                    let fileName: String
                    switch self {
                    case .stJulien:
                        fileName = "St-Julien-AOP_Bordeaux_France.geojson"
                    case .medoc:
                        fileName = "Medoc-AOP_Bordeaux_France.geojson"
                    case .hautMedoc:
                        fileName = "Haut-Medoc-AOP_Bordeaux_France.geojson"
                    case .stEsteph:
                        fileName = "St-Estephe-AOP_Bordeaux_France.geojson"
                    case .margaux:
                        fileName = "Margaux-AOP_Bordeaux_France.geojson"
                    case .moulisEnMedoc:
                        fileName = "Moulis-en-Medoc-AOP_Bordeaux_France.geojson"
                    case .pauillac:
                        fileName = "Pauillac-AOP_Bordeaux_France.geojson"
                    case .sauternes:
                        fileName = "Sauternes-PDO_Bordeaux_France.geojson"
                    case .graves:
                        fileName = "Graves-AOP_Bordeaux_France.geojson"
                    }
                    return URL(string: "\(rootURLString)/\(fileName)")!
                }
                case stJulien = "St. Julien"
                case medoc
                case hautMedoc = "Haut-Médoc"
                case stEsteph = "St. Estèphe"
                case margaux = "Margaux"
                case moulisEnMedoc = "Moulis en Médoc"
                case pauillac = "Pauillac"
                case sauternes = "Sauternes"
                case graves = "Graves"
            }
        }
    }

}
