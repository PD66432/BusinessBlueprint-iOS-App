import SwiftUI

struct NextTaskCard: View {
    let task: DailyGoal?
    let onTaskTap: () -> Void
    
    private var mintGreen: Color {
        Color(red: 0.0, green: 0.8, blue: 0.6)
    }
    
    private var statusColor: Color {
        guard let task = task else { return .gray }
        
        switch task.priority.lowercased() {
        case "high":
            return Color(red: 1.0, green: 0.3, blue: 0.3)
        case "medium":
            return Color(red: 1.0, green: 0.7, blue: 0.0)
        default:
            return Color(red: 0.6, green: 0.8, blue: 1.0)
        }
    }
    
    private var daysUntilDue: Int {
        guard let task = task else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: task.dueDate)
        return components.day ?? 0
    }
    
    private var isOverdue: Bool {
        return daysUntilDue < 0
    }
    
    var body: some View {
        if let task = task {
            Button(action: onTaskTap) {
                VStack(spacing: 0) {
                    // Header with priority indicator
                    HStack(spacing: 12) {
                        // Priority badge
                        VStack(spacing: 4) {
                            Circle()
                                .fill(statusColor)
                                .frame(width: 12, height: 12)
                            
                            Text(task.priority.capitalized)
                                .font(.caption2.weight(.semibold))
                                .foregroundColor(statusColor)
                        }
                        
                        // Task info
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Next Task")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            Text(task.title)
                                .font(.headline)
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        // Due date indicator
                        VStack(alignment: .trailing, spacing: 4) {
                            if isOverdue {
                                HStack(spacing: 4) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                    Text("Overdue")
                                        .font(.caption2.weight(.semibold))
                                        .foregroundColor(.red)
                                }
                            } else {
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundColor(mintGreen)
                                    Text(daysUntilDue == 0 ? "Today" : "\(daysUntilDue)d")
                                        .font(.caption2.weight(.semibold))
                                        .foregroundColor(mintGreen)
                                }
                            }
                            
                            Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    
                    // Task description (if available)
                    if !task.description.isEmpty {
                        Divider()
                            .padding(.horizontal, 20)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "doc.text")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 1)
                                
                                Text(task.description)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            // Action buttons
                            HStack(spacing: 12) {
                                Button {
                                    onTaskTap()
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: "checkmark.circle")
                                            .font(.caption)
                                        Text("View Details")
                                            .font(.caption.weight(.semibold))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(mintGreen.opacity(0.1))
                                    .foregroundColor(mintGreen)
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(20)
                        .background(Color(uiColor: .systemGray6))
                    }
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        } else {
            // Empty state
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 32))
                    .foregroundColor(mintGreen)
                
                Text("No tasks yet")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text("All caught up! Create a new task to get started.")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        NextTaskCard(
            task: DailyGoal(
                id: "1",
                businessIdeaId: "test",
                title: "Research target market",
                description: "Conduct research on target market demographics and preferences",
                dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                completed: false,
                priority: "High",
                createdAt: Date(),
                userId: "test"
            ),
            onTaskTap: {}
        )
        
        NextTaskCard(
            task: nil,
            onTaskTap: {}
        )
        
        Spacer()
    }
    .padding(20)
    .background(Color(uiColor: .systemGray6))
}
