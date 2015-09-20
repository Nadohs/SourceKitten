//
//  ClangTranslationUnitTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-12.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import SourceKittenFramework
import XCTest

let fixturesDirectory = (__FILE__ as NSString).stringByDeletingLastPathComponent + "/Fixtures/"

class ClangTranslationUnitTests: XCTestCase {
    func testParsesObjectiveCHeaderFilesAndXcodebuildArguments() {
        let headerFiles = [
            "a.h",
            "b.hpp",
            "c.hh"
        ]
        let xcodebuildArguments = [
            "arg1",
            "arg2"
        ]
        let (parsedHeaderFiles, parsedXcodebuildArguments) = parseHeaderFilesAndXcodebuildArguments(headerFiles + xcodebuildArguments)
        XCTAssertEqual(parsedHeaderFiles, headerFiles.map({$0.absolutePathRepresentation()}), "Objective-C header files should be parsed")
        XCTAssertEqual(parsedXcodebuildArguments, xcodebuildArguments, "xcodebuild arguments should be parsed")
    }

    func testBasicObjectiveCDocs() {
        let headerFiles = [fixturesDirectory + "Musician.h"]
        let compilerArguments = ["-x", "objective-c", "-isysroot", sdkPath()]
        let tu = ClangTranslationUnit(headerFiles: headerFiles, compilerArguments: compilerArguments)
        let escapedFixturesDirectory = fixturesDirectory.stringByReplacingOccurrencesOfString("/", withString: "\\/")
        let comparisonString = (tu.description + "\n").stringByReplacingOccurrencesOfString(escapedFixturesDirectory, withString: "")
        let expectedOutput = File(path: fixturesDirectory + "Musician.json")!.contents
        XCTAssertEqual(comparisonString, expectedOutput, "Objective-C docs should match expected ouput")
    }
}
