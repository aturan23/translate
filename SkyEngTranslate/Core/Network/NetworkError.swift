//
//  NetworkError.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

enum NetworkError: Error {
    case incorrectJSON
    case networkFail
    case serverError(reason: String)
    case unknownError
}

extension NetworkError {
    
    var message: String {
        switch self {
        case .serverError(let reason):
            return reason
        case .networkFail:
            return "Нет интернета"
        default:
            return "Произошла непредвиденная ошибка. Пожалуйста попробуйте еще раз"
        }
    }
}
