//
//  NetworkDataProvider.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Moya

final class NetworkDataProvider<Target: TargetType> {
    typealias Completion = (APIResult<Moya.Response>) -> Void
    
    private let networkReachibilityChecker: NetworkReachabilityChecking?
    private let dataProvider: MoyaProvider<Target>
    
    init(networkReachibilityChecker: NetworkReachabilityChecking?,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         plugins: [PluginType] = []) {
        self.networkReachibilityChecker = networkReachibilityChecker
        dataProvider = MoyaProvider(stubClosure: stubClosure, plugins: plugins)
    }
    
    func request<T: Codable>(_ target: Target, completion: @escaping (APIResult<T>) -> Void) {
        guard networkReachibilityChecker?.isReachable == true else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.failure(.networkFail))
            }
            return
        }
        dataProvider.request(target) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                completion(self.decode(response))
            case .failure(let error):
                if let reason = error.failureReason {
                    completion(.failure(.serverError(reason: reason)))
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
    
    func requestData(_ target: Target, completion: @escaping (APIResult<Data>) -> Void) {
        guard networkReachibilityChecker?.isReachable == true else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion(.failure(.networkFail))
            }
            return
        }
        dataProvider.request(target) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                if let reason = error.failureReason {
                    completion(.failure(.serverError(reason: reason)))
                } else {
                    completion(.failure(.unknownError))
                }
            }
        }
    }
    
    private func decode<T: Codable>(_ response: Response) -> APIResult<T> {
        if let data = String(decoding: response.data, as: UTF8.self).data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
           let _ = jsonObject as? JSONStandard {
            let withoutReasonResponse = try? response.map(T.self)
            if let response = withoutReasonResponse {
                return .success(response)
            }
            let networkError: NetworkError = .unknownError
            return .failure(networkError)
        } else {
            return .failure(.incorrectJSON)
        }
    }
}
