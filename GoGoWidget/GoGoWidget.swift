//
//  GoGoWidget.swift
//  GOGO
//
//  Created by Snippets on 9/5/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(Date(), style: .time)
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding(.leading, 20)
                Spacer()
                Image("logo_transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .padding(.trailing, 20)
            }
            .background(Color("background"))
            GeometryReader { geo in
                Image("map_placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
        }
        .widgetURL(URL(string: "gogoapp://open"))
        .containerBackground(.clear, for: .widget)
    }
}

struct MapWidget: Widget {
    let kind: String = "MapWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .configurationDisplayName("GOGO Widget")
        .description("Shows logo and map image. Tap to open the app.")
    }
}

#Preview {
    WidgetEntryView(entry: SimpleEntry(date: .now))
        .previewContext(WidgetPreviewContext(family: .systemMedium))
}
