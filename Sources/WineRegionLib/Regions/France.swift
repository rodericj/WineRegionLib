//
//  File.swift
//  
//
//  Created by Roderic Campbell on 12/4/20.
//

import Foundation

public enum BordeauxAppelation: String, WineRegionDescribable {
    public var url: URL {
        switch self {
        case .stJulien:
            return URL(string: "https://github.com/rodericj/BordeauxWineRegions/raw/master/St-Julien-AOP_Bordeaux_France.geojson")!
        }
    }

    public var description: String {
        switch self {
        case .stJulien:
            return "Saint Julien"
        }
    }
    case stJulien = "St. Julien"
}
public enum BordeauxSubRegion: String, WineRegionDescribable, Hashable {

    public var description: String {
        switch self {

        case .hautMedoc:
            return "Haut-Medoc"
        case .listracMedoc:
            return "listracMedoc"
        case .moulisEnMedoc:
            return "moulisEnMedoc"
        case .médoc:
            return "Medoc"
        }
    }

    case hautMedoc
    case listracMedoc
    case moulisEnMedoc
    case médoc = "Médoc"//(BordeauxAppelation)
    public var url: URL {
        switch self {

        case .médoc:
            return URL(string: "https://github.com/rodericj/BordeauxWineRegions/raw/master/Medoc-AOP_Bordeaux_France.geojson")!

        case .moulisEnMedoc:
            return URL(string: "https://github.com/rodericj/BordeauxWineRegions/raw/master/Moulis-en-Medoc-AOP_Bordeaux_France.geojson")!

        case .listracMedoc:
            return URL(string: "https://github.com/rodericj/BordeauxWineRegions/raw/master/Listrac-Medoc-AOP_Bordeaux_France.geojson")!

        case .hautMedoc:
            return URL(string: "https://github.com/rodericj/BordeauxWineRegions/raw/master/Haut-Medoc-AOP_Bordeaux_France.geojson")!
        }
    }
}

public struct France {
    public static let title = "France"
    public struct Burgundy {
        public static let title = "Burgundy"
        public enum Appelation: String, AppelationDescribable {
            public var description: String {
                switch self {
                case .coteDeBeaune,
                     .volay1erCru,
                     .aloxCorton1erCru: return "Beaune"
                case .notStJulien: return "Saint Julien"
                }
            }

            public var url: URL {
                switch self {
                case .notStJulien:
                    return URL(string: "https://github.com/rodericj/BordeauxWineRegions/raw/master/St-Julien-AOP_Bordeaux_France.geojson")!
                case .coteDeBeaune, .volay1erCru, .aloxCorton1erCru:
                    return URL(string: "https://github.com/rodericj/WineRegionMaps/raw/main/France/Burgundy/CoteDeBeaune.geojson")!
                }
            }
            case notStJulien
            case coteDeBeaune
            case volay1erCru = "Volnay 1er Cru"
            case aloxCorton1erCru = "Aloxe-Corton 1er Cru"
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
                    let rootURLString = "https://github.com/rodericj/BordeauxWineRegions/raw/master/"
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
