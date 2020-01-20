//
//  EventParser.swift
//  PlanningPoker
//
//  Created by Edward Byne on 17/01/2020.
//  Copyright © 2020 Christian Stangier. All rights reserved.
//

import Foundation

final class EventParser {
    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601WithoutTimezone)
        return decoder
    }()

    static func parse(_ jsonString: String) -> Any? {
        let jsonData = jsonString.data(using: .utf8)!
        let baseEvent = try! decoder.decode(BaseEvent.self, from: jsonData)

        switch baseEvent.eventType {
            case .userJoined:
                return try? decoder.decode(UserJoined.self, from: jsonData)
            case .userLeft:
                return try? decoder.decode(UserLeft.self, from: jsonData)
            case .startEstimation:
                return try? decoder.decode(RequestStartEstimation.self, from: jsonData)
            case .estimate:
                return try? decoder.decode(UserEstimate.self, from: jsonData)
            case .userHasEstimated:
                return try? decoder.decode(UserHasEstimated.self, from: jsonData)
            case .showResult:
                return try? decoder.decode(RequestShowEstimationResult.self, from: jsonData)
            case .estimationResult:
                return try? decoder.decode(EstimationResult.self, from: jsonData)
            case .keepAlive:
                return try? decoder.decode(HeartBeat.self, from: jsonData)
        }
    }

    static func serialize(_ event: Encodable) -> String {
        let dictionary = event.dictionary
        let data = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        return String(decoding: data, as: UTF8.self)
    }
}

struct JSON {
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatter.iso8601WithoutTimezone)
        return encoder
    }()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }

    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}