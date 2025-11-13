import SwiftUI

struct CompletedTaskCard: View {
    let goal: DailyGoal
    
    private var mintGreen: Color {
        Color(red: 0.0, green: 0.8, blue: 0.6)
    }
    
    private var priorityColor: Color {
        switch goal.priority.lowercased() {
        case "high":
            return Color(red: 1.0, green: 0.3, blue: 0.3)
        case "medium":
            return Color(red: 1.0, green: 0.7, blue: 0.0)
        default:
            return Color(red: 0.6, green: 0.8, blue: 1.0)
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkmark indicator
            ZStack {
                Circle()
                    .fill(mintGreen.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(mintGreen)
            }
            
            // Task info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(goal.title)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.black)
                        .lineLimit(1)
                    
                    // Priority badge
                    Text(goal.priority.capitalized)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(priorityColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(priorityColor.opacity(0.1))
                        .cornerRadius(4)
                }
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(goal.dueDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    if !goal.description.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.text")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(goal.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Completion badge
            VStack(alignment: .trailing, spacing: 4) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 18))
                    .foregroundColor(mintGreen)
                
                Text("Done")
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(mintGreen)
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    VStack(spacing: 12) {
        CompletedTaskCard(
            goal: DailyGoal(
                id: "1",
                businessIdeaId: "test",
                title: "Read poem & answer questions",
                description: "English Literature assignment",
                dueDate: Date(timeIntervalSinceNow: -86400),
                completed: true,
                priority: "Medium",
                createdAt: Date(),
                userId: "test"
            )
        )
        
        CompletedTaskCard(
            goal: DailyGoal(
                id: "2",
                businessIdeaId: "test",
                title: "Create a comic strip with a story",
                description: "Social Studies project",
                dueDate: Date(timeIntervalSinceNow: -172800),
                completed: true,
                priority: "High",
                createdAt: Date(),
                userId: "test"
            )
        )
        
        Spacer()
    }
    .padding(20)
    .background(Color(uiColor: .systemGray6))
}
