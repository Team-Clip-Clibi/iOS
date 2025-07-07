//
//  AttendeesCheckView.swift
//  OneThing
//
//  Created by 오현식 on 6/10/25.
//

import SwiftUI

struct AttendeesCheckView: View {
    
    enum Constants {
        enum Text {
            static let attendeesCheckTitle: String = "오늘 참석하지 않은 멤버가 있나요?"
            static let noShowMembersTitle: String = "참석하지 않은 멤버를 선택해주세요"
        }
    }
    
    let members: [MemberInfo]
    
    @Binding var isAttendeesSelected: Bool
    @Binding var selectedAttendees: [AttendeesInfo]
    
    @Binding var isNoShowMembersSelected: Bool
    @Binding var selectedNoShowMembers: [MemberInfo]
    
    @State private var hasNoShowMembers: Bool = false
    
    var body: some View {
        
        VStack {
            
            Text(Constants.Text.attendeesCheckTitle)
                .otFont(.subtitle1)
                .foregroundStyle(.gray800)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer().frame(height: 16)
            
            MultipleOnlyTextBoxView<AttendeesInfo>(
                state: .init(
                    items: AttendeesInfo.allCases.map { .init(item: $0) },
                    selectionLimit: 1,
                    changeWhenIsReachedLimit: true
                ),
                isReachedLimit: .constant(false),
                isSelected: $isAttendeesSelected,
                selectedItems: $selectedAttendees,
                cols: [GridItem()],
                alignment: .leading
            )
            .onChange(of: self.selectedAttendees) { _, new in
                guard let selectedAttendees = new.last else { return }
                
                self.hasNoShowMembers = selectedAttendees == .hasNoAttendees
            }
            
            if self.hasNoShowMembers {
                
                Spacer().frame(height: 24)
                
                Rectangle()
                    .fill(.gray200)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                
                Spacer().frame(height: 24)
                
                Text(Constants.Text.noShowMembersTitle)
                    .otFont(.subtitle2)
                    .foregroundStyle(.gray800)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer().frame(height: 16)
                
                MultipleCheckBoxView<MemberInfo>(
                    viewType: .meeting,
                    state: .init(items: self.members.map { .init(item: $0) }),
                    isReachedLimit: .constant(false),
                    isSelected: $isNoShowMembersSelected,
                    selectedItems: $selectedNoShowMembers
                )
            }
        }
    }
}

#Preview {
    AttendeesCheckView(
        members: [],
        isAttendeesSelected: .constant(false),
        selectedAttendees: .constant([]),
        isNoShowMembersSelected: .constant(false),
        selectedNoShowMembers: .constant([])
    )
}
