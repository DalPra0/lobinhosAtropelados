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
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct GimoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GimoWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
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
