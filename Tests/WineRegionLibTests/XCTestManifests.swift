import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(WineRegionLibTests.allTests),
    ]
}
#endif
