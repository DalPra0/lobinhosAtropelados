//
//  GimoWidgetBundle.swift
//  GimoWidget
//
//  Created by Lucas Dal Pra Brascher on 07/07/25.
//

import WidgetKit
import SwiftUI

@main
struct GimoWidgetBundle: WidgetBundle {
    var body: some Widget {
        GimoWidget()
        AddTaskWidget()
        GimoWidgetControl()
        GimoWidgetLiveActivity()
    }
}
