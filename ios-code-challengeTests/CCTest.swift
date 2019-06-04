//
//  CCTest.swift
//  ios-code-challengeTests
//
//  Created by Rudy Matos on 6/4/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import XCTest
@testable import ios_code_challenge

class CCTest: XCTestCase {

    func testQueryParamTypeShouldBeAddressWithInit(){
        let queryParam = QueryParam()
        XCTAssertEqual(queryParam.type, QueryParam.QueryType.address)
    }

    func testQueryParamShouldContainDefaultAddressWhenInit(){
        let queryParam = QueryParam()
        XCTAssertEqual(queryParam.location, "5550 West Executive Dr. Tampa, FL 33609")
    }
    
    func testQueryParamShouldChangeTypeWhenAssigningLatitudeAndLogitude(){
        var queryParam = QueryParam()
        XCTAssertEqual(queryParam.type, QueryParam.QueryType.address)
        queryParam.set(latitude: 0, longitude: 0)
        XCTAssertEqual(queryParam.type, QueryParam.QueryType.location)
    }

    
    func testQueryParamShouldContainLocationValueWhenIsAddressType(){
        let queryParam = QueryParam()
        XCTAssertNotNil(queryParam.getQueryDict()["location"])
    }
    
    
    func testQueryParamShouldContainNotLocationValueWhenIsNotAddressType(){
        var queryParam = QueryParam()
        queryParam.set(latitude: 0, longitude: 0)
        XCTAssertNil(queryParam.getQueryDict()["location"])
    }
    
    func testQueryParamShouldContainLatAndLonWhenIsLocationType(){
        var queryParam = QueryParam()
        queryParam.set(latitude: 0, longitude: 0)
        XCTAssertNotNil(queryParam.getQueryDict()["latitude"])
        XCTAssertNotNil(queryParam.getQueryDict()["longitude"])
    }

}
