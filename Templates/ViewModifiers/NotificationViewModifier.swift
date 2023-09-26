/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI

enum BannerType {
    case info
    case warning
    case success
    case error

    var tintColor: Color {
        switch self {
        case .info:
            return Color(UIColor.tintColor)
        case .success:
            return Color.green
        case .warning:
            return Color.yellow
        case .error:
            return Color.red
        }
    }
}

struct BannerData: Equatable {
    var caption: String
    var description: String
    var type: BannerType
    var timeout: Double = 4
}

/// Notification View.
struct NotificationViewModifier: ViewModifier {
        
    @Binding var data: BannerData?
    @Binding var show: Bool

    @State var timer: Timer? = nil

    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data!.caption)
                                .bold()
                            Text(data!.description)
                                .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                        }
                        Spacer()
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(data!.type.tintColor)
                    .cornerRadius(8)
                    Spacer()
                }
                .padding()
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                .onTapGesture {
                    show = false
                }
            }
        }
        .animation(.easeInOut, value: show)
        .onChange(of: show) { newValue in
            rescheduleTimer()
        }
        .onChange(of: data) { newValue in
            rescheduleTimer()
        }

    }
    
    private func rescheduleTimer() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        if show {
            timer = Timer.scheduledTimer(withTimeInterval: data!.timeout, repeats: false) { timer in
                show = false
                timer.invalidate()
                self.timer = nil
            }
        }
    }
}

func notificationViewModifier(data: Binding<BannerData?>, show: Binding<Bool>) -> some View {
    EmptyView().modifier(NotificationViewModifier(data: data, show: show))
}

struct NotificationViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        notificationViewModifier(data: .constant(BannerData(caption: "Caption",
                                                            description: "Description",
                                                            type: .info)),
                                 show: .constant(true))
    }
}

