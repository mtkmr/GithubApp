//
//  GithubAPIError.swift
//  GithubApp
//
//  Created by Masato Takamura on 2021/08/31.
//

import Foundation

enum GithubAPIError: Error {
    case network
    case server
    case invalidParameter
    case noResponse
    case noData
    case decode
}

extension GithubAPIError: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidParameter:
            return "パラメータが適切ではありません"
        case .decode:
            return "データの変換に失敗しました"
        case .network:
            return "ネットワークの接続を確認してください"
        case .server:
            return "サーバーでエラーが発生しました。しばらくしてからお試しください。"
        case .noResponse:
            return "レスポンスがありません"
        case .noData:
            return "データが見つかりませんでした"
        }
    }
}
