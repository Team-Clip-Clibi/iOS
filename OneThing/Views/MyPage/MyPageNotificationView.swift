//
//  MyPageNotificationView.swift
//  OneThing
//
//  Created by 윤동주 on 5/9/25.
//

import SwiftUI

struct MyPageNotificationView: View {
    
    @AppStorage("notificationEnabled") private var notificationEnabled: Bool = false
    
    @Binding var pathManager: OTAppPathManager
    @Binding var viewModel: MyPageNotificationViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            OTNavigationBar(
                leftButtonType: .back,
                title: "알림 설정",
                phase: 0,
                leftAction: {
                    _ = self.pathManager.myPagePaths.popLast()
                }
            )
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("알림 수신 설정")
                        .otFont(.body1)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray800)
                    
                    Text("서비스 이용 및 공지, 이벤트 등")
                        .otFont(.caption1)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray600)
                }
                Spacer()
                OTToggle(isOn: $notificationEnabled)
                .onChange(of: notificationEnabled) { oldValue, newValue in
                    if newValue {
                        Task {
                            let status = await withCheckedContinuation { continuation in
                                UNUserNotificationCenter.current().getNotificationSettings { settings in
                                    continuation.resume(returning: settings.authorizationStatus)
                                }
                            }
                            
                            if status != .authorized || status == .provisional, status != .ephemeral {
                                notificationEnabled = false
                                guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                                await UIApplication.shared.open(appSettingsURL, options: [:])
                                return
                            }
                            
                            NotificationManager.shared.setNotificationEnabled(isEnabled: true)
                        }
                    } else {
                        NotificationManager.shared.setNotificationEnabled(isEnabled: false)
                    }
                    if newValue {
                        HapticManager.shared.impact(style: .soft)
                    }
                }
            }
            .padding(.horizontal, 17)
            .padding(.top, 20)
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MyPageNotificationView(
        pathManager: .constant(OTAppPathManager()),
        viewModel: .constant(MyPageNotificationViewModel())
    )
}
