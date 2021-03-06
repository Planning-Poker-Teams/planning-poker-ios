//
//  PieChartView.swift
//  PlanningPoker
//
//  Created by Edward Byne on 27/01/2020.
//  Copyright © 2020 Christian Stangier. All rights reserved.
//

import SwiftUI

struct PieChartView: View {
    let colors: [Color] = [
        Color("Color-1"),
        Color("Color-2"),
        Color("Color-3"),
        Color("Color-4"),
        Color("Color-5"),
        Color("Color-6"),
        Color("Color-7"),
        Color("Color-8")
    ]

    var segmentData: [SegmentData]

    var segmentIndices: Range<Int> {
        return 0..<segmentData.count
    }

    @State var selectedSegmentIndex: Int?

    var body: some View {
        ZStack {
            ForEach(segmentIndices, id: \.self) { index in
                PieChartSegmentView(
                    data: self.segmentData[index],
                    isSelected: index == self.selectedSegmentIndex,
                    isAnotherSelected: self.selectedSegmentIndex != nil && index != self.selectedSegmentIndex,
                    color: self.colors[index % self.colors.count]
                )
                .animation(.spring(response: 0.4, dampingFraction: 0.6))
                .gesture(
                    TapGesture().onEnded { _ in
                        self.selectedSegmentIndex = self.selectedSegmentIndex == index ? nil : index
                    }
                )
            }
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(
            segmentData: [
                SegmentData(startAngle: 0, endAngle: 50, estimators: ["Hans", "Franz", "Johanna"], estimate: "3"),
                SegmentData(startAngle: 50, endAngle: 220, estimators: ["Hans", "Franz"], estimate: "12"),
                SegmentData(startAngle: 220, endAngle: 230, estimators: ["Hans"], estimate: "8"),
                SegmentData(startAngle: 230, endAngle: 240, estimators: ["Hans"], estimate: "0"),
                SegmentData(startAngle: 240, endAngle: 250, estimators: ["Hans", "Franz", "Johanna"], estimate: "13"),
                SegmentData(startAngle: 250, endAngle: 360, estimators: ["Hans", "Franz", "Johanna", "Franzi"], estimate: "???"),
            ]
        ).previewLayout(.fixed(width: 200.0, height: 200.0))
    }
}
