//
//  EventHandler.swift
//  PlanningPoker
//
//  Created by Christian Stangier on 17.01.20.
//  Copyright © 2020 Christian Stangier. All rights reserved.
//

import Foundation

public struct AppState {
    var estimationStatus: EstimationStatus = .notStarted
    var participant: Participant?
    var otherParticipants: [Participant] = []
    var roomName: String?
    var currentTaskName: String?
    var estimationStart: Date?

    enum EstimationStatus {
        case notStarted
        case inProgress
        case ended
    }
}

struct Participant: Identifiable {
    var id: UUID = UUID()
    var name: String
    var hasEstimated: Bool = false
    var currentEstimate: String?
}

public class EventHandler {
    public static func handle(_ anyEvent: Any, state: AppState) -> AppState {
        switch anyEvent {
        case let event as UserJoined:
            let alreadyHasParticipant = state.otherParticipants.contains {
                $0.name == event.userName
            }

            if alreadyHasParticipant {
                return state
            }

            let newParticipants = state.otherParticipants +
                [Participant(name: event.userName)]

            return AppState(
                estimationStatus: state.estimationStatus,
                participant: state.participant,
                otherParticipants: newParticipants,
                roomName: state.roomName,
                currentTaskName: state.currentTaskName,
                estimationStart: state.estimationStart
            )

        case let event as UserLeft:
            let newParticipants =
                state.otherParticipants.filter {
                    $0.name != event.userName
                }
            return AppState(
                estimationStatus: state.estimationStatus,
                participant: state.participant,
                otherParticipants: newParticipants,
                roomName: state.roomName,
                currentTaskName: state.currentTaskName,
                estimationStart: state.estimationStart
            )

        case let event as RequestStartEstimation:
            return AppState(
                estimationStatus: .inProgress,
                participant: state.participant,
                otherParticipants: state.otherParticipants,
                roomName: state.roomName,
                currentTaskName: event.taskName,
                estimationStart: event.startDate
            )

        case let event as UserHasEstimated:
            func markAsEstimatedIfNecessary(participant: Participant) -> Participant {
                if participant.name == event.userName {
                    return Participant(name: participant.name, hasEstimated: true)
                }
                return participant
            }

            return AppState(
                estimationStatus: state.estimationStatus,
                participant: state.participant.map(markAsEstimatedIfNecessary),
                otherParticipants: state.otherParticipants.map(markAsEstimatedIfNecessary),
                roomName: state.roomName,
                currentTaskName: state.currentTaskName,
                estimationStart: state.estimationStart
            )

        case let event as EstimationResult:
            func updateEstimateIfNecessary(participant: Participant) -> Participant {
                let participantEstimate = event.estimates.first { estimate in
                    estimate.userName == participant.name
                }
                guard participantEstimate != nil else {
                    return participant
                }

                return Participant(
                    name: participant.name,
                    hasEstimated: true,
                    currentEstimate: participantEstimate!.estimate
                )
            }

            return AppState(
                estimationStatus: .ended,
                participant: state.participant.map(updateEstimateIfNecessary),
                otherParticipants: state.otherParticipants.map(updateEstimateIfNecessary),
                roomName: state.roomName,
                currentTaskName: state.currentTaskName,
                estimationStart: state.estimationStart
            )

        case is HeartBeat:
            return state

        default:
            print("Ignoring event", anyEvent)
            return state
        }
    }
}
