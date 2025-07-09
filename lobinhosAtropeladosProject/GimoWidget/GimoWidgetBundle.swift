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
    @WidgetBundleBuilder
    var body: some Widget {
        GimoWidget()
        AddTaskWidget()
        GimoWidgetLiveActivity()

        if #available(iOSApplicationExtension 18.0, *) {
            GimoWidgetControl()
        }
    }
}

