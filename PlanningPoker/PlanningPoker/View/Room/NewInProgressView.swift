//
//  NewInProgressView.swift
//  PlanningPoker
//
//  Created by Edward Byne on 22/01/2020.
//  Copyright © 2020 Christian Stangier. All rights reserved.
//

import SwiftUI

struct NewInProgressView: View {
    let possibleEstimates = ["0", "1", "2", "3", "5", "8", "13", "20", "40", "100", "???"]

    static let threshold: CGFloat = 100

    @State private var offset = CGSize.zero
    @State private var draggedCardIndex = 0

//        ["3", "5", "8"],
//        ["13", "20", "40"],
//        ["100", "???"],
//    ]
//
//    var currentTaskName: String?
//    var participantEstimate: String?
//    let onEstimate: (String) -> Void
//    let onShowResult: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Text("Threshold: \(self.offset.height)")
                
                ZStack {
                    ForEach(0..<possibleEstimates.count, id: \.self) { index in
                        PokerCardView(value: self.possibleEstimates[index])
                            .rotationEffect(
                                Angle(
                                    degrees: self.calculateAngle(
                                        index,
                                        totalCards: self.possibleEstimates.count,
                                        isCardDragged: self.draggedCardIndex == index
                                    )
                                ),
                                anchor: .bottom
                            )
                            .animation(.spring())
                            .offset(self.draggedCardIndex == index ? self.offset : .zero)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        self.draggedCardIndex = index
                                        self.offset = gesture.translation
                                    }
                                    .onEnded { _ in
                                        if abs(self.offset.height) > NewInProgressView.threshold {
                                            // remove the card
                                        } else {
                                            self.offset = .zero
                                        }
                                    }
                            )
                    }
                }
            }
        }
    }

    private func calculateAngle(_ index: Int, totalCards: Int, isCardDragged: Bool = false) -> Double {
        let percent = !isCardDragged ? Int(1) : Int(floor(abs(self.offset.height) / NewInProgressView.threshold))

        let middleCardIndex = Int(floor(Double(totalCards) / Double(2)))

        if index < middleCardIndex {
            return Double((middleCardIndex - index) * -10 * percent)
        }

        if index > middleCardIndex {
            return Double((index - middleCardIndex) * 10 * percent)
        }

        return 0
    }
}

struct NewInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        NewInProgressView(
//            participantEstimate: "5",
//            onEstimate: { _ in },
//            onShowResult: {}
        )
    }
}