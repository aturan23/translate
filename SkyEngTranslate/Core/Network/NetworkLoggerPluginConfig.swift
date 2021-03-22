//
//  NetworkLoggerPluginConfig.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Moya

enum NetworkLoggerPluginConfig {
    static let prettyLogging = NetworkLoggerPlugin.Configuration(
        formatter: NetworkLoggerPlugin.Configuration.Formatter(
            requestData: JSONDataToStringFormatter,
            responseData: JSONDataToStringFormatter),
        output: safeOutput,
        logOptions: [.verbose]
    )
    
    private static func JSONDataToStringFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? ""
        } catch {
            return String(data: data, encoding: .utf8) ?? "" // fallback to original data if it can't be serialized.
        }
    }


    private static func safeOutput(target: TargetType, items: [String]) {
        #if DEBUG
        for item in items {
            print(item, separator: ",", terminator: "\n")
        }
        #endif
    }
}
