//
//  BaseTargetType.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Moya

protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    
    public var baseURL: URL {
        return URL(string: "https://dictionary.skyeng.ru")!
    }
    
    public var path: String {
        return "/public/v1/words/"
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var validate: Bool {
        return true
    }
}

