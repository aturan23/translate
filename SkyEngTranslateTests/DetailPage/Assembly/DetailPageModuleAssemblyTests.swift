//
//  DetailPageModuleAssemblyTests.swift
//  SkyEngTranslateTests
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit
import XCTest

@testable import SkyEngTranslate
import Swinject

class DetailPageModuleAssemblyTests: XCTestCase {
    func testConfigureModuleForViewController() {
        //given
        let container = Container()
        let assembly = DetailPageModuleAssembly(injection: container)

        //when
        let vc = assembly.assemble()

        guard let viewController = vc as? DetailPageViewController else {
            XCTFail("Not a DetailPageViewController")
            return
        }

        //then
        XCTAssertNotNil(viewController.output, "DetailPageViewController should have ViewModel")
        XCTAssertTrue(viewController.output is DetailPageViewModel, "output is not DetailPageViewModel")
    }
}
