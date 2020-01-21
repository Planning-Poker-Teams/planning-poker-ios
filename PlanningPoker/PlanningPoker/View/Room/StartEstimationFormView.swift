//
//  StartEstimationFormView.swift
//  PlanningPoker
//
//  Created by Christian Stangier on 21.01.20.
//  Copyright © 2020 Christian Stangier. All rights reserved.
//

import SwiftUI

struct StartEstimationFormView: View {
    @State var newTaskName: String = ""
    let onStartEstimation: (String) -> Void

    var body: some View {
        VStack {
            TextField("Task name", text: self.$newTaskName)
            Button(action: { self.onStartEstimation(self.newTaskName) }) {
                Text("Start")
            }
        }
    }
}

struct StartEstimationFormView_Previews: PreviewProvider {
    static var previews: some View {
        StartEstimationFormView(
            onStartEstimation: { _ in }
        )
    }
}