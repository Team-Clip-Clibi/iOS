//
//  MyPageNotificationView.swift
//  OneThing
//
//  Created by 윤동주 on 5/9/25.
//

import SwiftUI

struct MyPageNotificationView: View {
    
    @AppStorage("notificationEnabled") private var notificationEnabled: Bool = false
    
    @Environment(\.myPageCoordinator) var myPageCoordinator
    
    @Binding var store: MyPageNotificationStore
    
    var body: some View {
        
        OTBaseView(String(describing: Self.self)) {
            
            VStack(spacing: 0) {
                
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
                                
                                await self.store.send(.updateNotificationEnabled(true))
                            }
                            
                            HapticManager.shared.impact(style: .soft)
                        } else {
                            Task {
                                await self.store.send(.updateNotificationEnabled(false))
                            }
                        }
                    }
                }
                .padding(.horizontal, 17)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .navigationBar(
            title: "알림 설정",
            hidesBottomSeparator: false,
            onBackButtonTap: {
                self.myPageCoordinator.pop()
            }
        )
    }
}

#Preview {
    let myPageNotificationStoreForPreivew = MyPageNotificationStore(updateUserNotifyUseCase: UpdateUserNotifyUseCase())
    MyPageNotificationView(store: .constant(myPageNotificationStoreForPreivew))
}
