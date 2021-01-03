import XCTest
@testable import WineRegionLib

extension RegionJson: Equatable {
    public static func == (lhs: RegionJson, rhs: RegionJson) -> Bool {
        lhs.title == rhs.title && lhs.children == rhs.children
    }
}
final class WineRegionLibTests: XCTestCase {


    func testFilterChildrenIncludeAll() {
        let four = RegionJson(title: "four", url: "", children: [])
        let three = RegionJson(title: "three", url: "", children: [])
        let two = RegionJson(title: "two", url: "", children: [four])
        let one = RegionJson(title: "one", url: "", children: [two, three])

        let results = one.filter(searchString: "one")
        XCTAssert(results.count == 1)
        XCTAssert(results.first == one)
    }

    func testFilterChildren() {
        let four = RegionJson(title: "four", url: "", children: [])
        let three = RegionJson(title: "three", url: "", children: [])
        let two = RegionJson(title: "two", url: "", children: [four])
        let one = RegionJson(title: "one", url: "", children: [two, three])

        let results = one.filter(searchString: "two")
        XCTAssert(results.count == 1)
        XCTAssert(results.first == two)
    }

    func testFilterChildrenMultipleResults() {
        let four = RegionJson(title: "four", url: "", children: [])
        let three = RegionJson(title: "three", url: "", children: [])
        let two = RegionJson(title: "two", url: "", children: [four])
        let one = RegionJson(title: "one", url: "", children: [two, three])

        let results = one.filter(searchString: "o")
        XCTAssert(results.count == 3)
        XCTAssert(results.contains(one))
        XCTAssert(results.contains(two))
        XCTAssert(results.contains(four))
    }

    func testFilterChildrenMultipleResults1() {
        let four = RegionJson(title: "four", url: "", children: [])
        let three = RegionJson(title: "three", url: "", children: [])
        let two = RegionJson(title: "two", url: "", children: [four])
        let one = RegionJson(title: "one", url: "", children: [two, three])

        let results = one.filter(searchString: "t")
        XCTAssert(results.count == 2)
        XCTAssert(results.contains(two))
        XCTAssert(results.contains(three))
    }

    func testSortChildren() throws {
        let decoder = JSONDecoder()

        guard let data = WineRegionLibTests.json.data(using: .utf8) else {
            XCTFail("failed to parse test payload")
            return
        }
        let franceRegion = try decoder.decode(RegionJson.self, from: data)

        // Since Barsac was intentially placed second, it should now be first. This proves sorting worked
        XCTAssertEqual(franceRegion.children?.first?.children?.first?.title, "Barsac")
    }

    static let json: String = """
    {
     "children": [
       {
         "children": [
           {
             "name": "Blaye",
             "title": "Blaye",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Blaye-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Barsac",
             "title": "Barsac",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Barsac-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Canon Fronsac",
             "title": "Canon Fronsac",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Canon-Fronsac-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Cerons",
             "title": "Cerons",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Cerons-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Cotes de Blaye",
             "title": "Cotes de Blaye",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Cotes-de-Blaye-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Cotes de Bordeaux",
             "title": "Cotes de Bordeaux",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Cotes-de-Bordeaux-PDO_Bordeaux_France.geojson"
           },
           {
             "name": "Cotes de Bordeaux St Macaire",
             "title": "Cotes de Bordeaux St Macaire",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Cotes-de-Bordeaux-St-Macaire-PDO_Bordeaux_France.geojson"
           },
           {
             "name": "Cotes de Bourg",
             "title": "Cotes de Bourg",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Cotes-de-Bourg-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Cremant de Bordeaux",
             "title": "Cremant de Bordeaux",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Cremant-de-Bordeaux-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Entre Deux Mers",
             "title": "Entre Deux Mers",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Entre-Deux-Mers-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Fronsac",
             "title": "Fronsac",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Fronsac-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Graves",
             "title": "Graves",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Graves-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Graves Superieures",
             "title": "Graves Superieures",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Graves-Superieures-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Graves of Vayres",
             "title": "Graves of Vayres",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Graves-of-Vayres-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Haut Medoc",
             "title": "Haut Medoc",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Haut-Medoc-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Lalande de Pomerol",
             "title": "Lalande de Pomerol",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Lalande-de-Pomerol-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Listrac Medoc",
             "title": "Listrac Medoc",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Listrac-Medoc-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Loupiac",
             "title": "Loupiac",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Loupiac-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Lussac St Emilion",
             "title": "Lussac St Emilion",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Lussac-St-Emilion-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Margaux",
             "title": "Margaux",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Margaux-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Medoc",
             "title": "Medoc",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Medoc-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Moulis en Medoc",
             "title": "Moulis en Medoc",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Moulis-en-Medoc-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Pauillac",
             "title": "Pauillac",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Pauillac-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Pessac Leognan",
             "title": "Pessac Leognan",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Pessac-Leognan-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Pomerol",
             "title": "Pomerol",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Pomerol-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Puisseguin St Emilion",
             "title": "Puisseguin St Emilion",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Puisseguin-St-Emilion-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "Sauternes",
             "title": "Sauternes",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Sauternes-PDO_Bordeaux_France.geojson"
           },
           {
             "name": "St Croix du Mont",
             "title": "St Croix du Mont",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/St-Croix-du-Mont-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "St Emilion",
             "title": "St Emilion",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/St-Emilion-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "St Emilion Grand Cru",
             "title": "St Emilion Grand Cru",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/St-Emilion-Grand-Cru-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "St Estephe",
             "title": "St Estephe",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/St-Estephe-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "St Foy Bordeaux",
             "title": "St Foy Bordeaux",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/St-Foy-Bordeaux-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "St Georges St Emilion",
             "title": "St Georges St Emilion",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/St-Georges-St-Emilion-AOP_Bordeaux_France.geojson"
           },
           {
             "name": "St Julien",
             "title": "St Julien",
             "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/St-Julien-AOP_Bordeaux_France.geojson"
           }
         ],
         "name": "Bordeaux",
         "title": "Bordeaux",
         "url": "https://raw.githubusercontent.com/rodericj/BordeauxWineRegions/master/Bordeaux-AOP_Bordeaux_France.geojson"
       }
     ],
     "name": "France",
     "title": "France",
     "url": "https://raw.githubusercontent.com/rodericj/WineRegionMaps/main/France/France.geojson"
    }


    """

    static var allTests = [
        ("testExample", testSortChildren),
    ]
}
