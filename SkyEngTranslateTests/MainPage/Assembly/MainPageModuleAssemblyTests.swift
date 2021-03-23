//
//  MainPageModuleAssemblyTests.swift
//  SkyEngTranslateTests
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit
import XCTest

@testable import SkyEngTranslate
import Swinject

class MainPageModuleAssemblyTests: XCTestCase {
    func testConfigureModuleForViewController() {
        //given
        let container = Container()
        let assembly = MainPageModuleAssembly(injection: container)

        //when
        let vc = assembly.assemble()

        guard let viewController = vc as? MainPageViewController else {
            XCTFail("Not a MainPageViewController")
            return
        }

        //then
        XCTAssertNotNil(viewController.output, "MainPageViewController should have ViewModel")
        XCTAssertTrue(viewController.output is MainPageViewModel, "output is not MainPageViewModel")
    }
}
