//
//  GimoWidgetLiveActivity.swift
//  GimoWidget
//
//  Created by Lucas Dal Pra Brascher on 07/07/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct GimoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var emoji: String
    }

    var name: String
}

struct GimoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GimoWidgetAttributes.self) { context in
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GimoWidgetAttributes {
    fileprivate static var preview: GimoWidgetAttributes {
        GimoWidgetAttributes(name: "World")
    }
}

extension GimoWidgetAttributes.ContentState {
    fileprivate static var smiley: GimoWidgetAttributes.ContentState {
        GimoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: GimoWidgetAttributes.ContentState {
         GimoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: GimoWidgetAttributes.preview) {
   GimoWidgetLiveActivity()
} contentStates: {
    GimoWidgetAttributes.ContentState.smiley
    GimoWidgetAttributes.ContentState.starEyes
}
