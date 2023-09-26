/*
 * Copyright © 2023 THALES. All rights reserved.
 */

import SwiftUI

struct ProgressData: Equatable {
    var caption: String
    var description: String?
}

struct ProgressViewModifier: ViewModifier {
        
    @Binding var data: ProgressData?
    @Binding var show: Bool

//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            if show {
//                VStack {
//                    Spacer()
//                    VStack(spacing: 24) {
//                        VStack(alignment: .center) {
//                            if let caption = data!.caption {
//                                Text(caption).bold()
//                            }
//
//                            if let description = data!.description {
//                                Text(description)
//                                    .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
//                            }
//
//                        }
//                        ProgressView().tint(Color.white)
//                    }
//                    .foregroundColor(Color.white)
//                    .padding(32)
//                    .background(Color("ColorAccentBlue"))
//                    .cornerRadius(8)
//                    Spacer()
//                }
//                .padding()
//                .transition(AnyTransition.opacity)
//                .onTapGesture {
//                    show = false
//                }
//            }
//        }
//        .animation(.easeInOut, value: show)
//
//    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(data!.caption)
                                .bold()
                            if let description = data!.description {
                                Text(description)
                                    .font(Font.system(size: 15, weight: Font.Weight.light, design: Font.Design.default))
                            }
                        }
                        Spacer()
                        ProgressView().tint(Color.white)
                    }
                    .foregroundColor(Color.white)
                    .padding(12)
                    .background(Color("ColorAccentBlue"))
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
    }
}

func progressViewModifier(data: Binding<ProgressData?>, show: Binding<Bool>) -> some View {
    EmptyView().modifier(ProgressViewModifier(data: data, show: show))
}

struct ProgressViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        progressViewModifier(data: .constant(ProgressData(caption: "caption")),
                             show: .constant(true))
    }
}

