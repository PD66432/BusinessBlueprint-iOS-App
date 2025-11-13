import SwiftUI

struct ProgressMilestoneCard: View {
    let milestone: Milestone?
    let completionPercentage: Int
    let totalMilestones: Int
    let completedMilestones: Int
    
    private var daysUntilMilestone: Int {
        guard let milestone = milestone else { return 0 }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: milestone.dueDate)
        return max(components.day ?? 0, 0)
    }
    
    private var mintGreen: Color {
        Color(red: 0.0, green: 0.8, blue: 0.6)
    }
    
    private var progressGreen: Color {
        Color(red: 0.0, green: 0.85, blue: 0.65)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with gradient background
            VStack(spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    // Left side: Progress text
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Progress")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .textCase(.uppercase)
                            .tracking(0.5)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(completionPercentage)%")
                                .font(.system(size: 44, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Complete")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    Spacer()
                    
                    // Right side: Circular progress indicator
                    ZStack {
                        // Background circle
                        Circle()
                            .stroke(Color.white.opacity(0.15), lineWidth: 10)
                            .frame(width: 100, height: 100)
                        
                        // Progress circle with glow effect
                        Circle()
                            .trim(from: 0, to: CGFloat(completionPercentage) / 100)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.2, green: 1.0, blue: 0.7),
                                        Color(red: 0.0, green: 0.85, blue: 0.65)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                            )
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                            .shadow(color: Color(red: 0.0, green: 0.85, blue: 0.65).opacity(0.8), radius: 12, x: 0, y: 0)
                        
                        // Center icon
                        Image(systemName: "target")
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                    }
                }
                
                // Stats row
                HStack(spacing: 20) {
                    StatBadge(
                        value: "\(completedMilestones)",
                        label: "Milestones",
                        backgroundColor: Color.white.opacity(0.15)
                    )
                    
                    StatBadge(
                        value: "\(totalMilestones)",
                        label: "Total",
                        backgroundColor: Color.white.opacity(0.15)
                    )
                    
                    StatBadge(
                        value: "\(daysUntilMilestone)d",
                        label: "Until Next",
                        backgroundColor: Color.white.opacity(0.2)
                    )
                }
            }
            .padding(24)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        mintGreen,
                        mintGreen.opacity(0.85)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            // Bottom section with milestone details
            if let milestone = milestone {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Next Milestone")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .textCase(.uppercase)
                                .tracking(0.5)
                            
                            Text(milestone.title)
                                .font(.headline)
                                .foregroundColor(.black)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(milestone.dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption2)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.caption2)
                                    .foregroundColor(mintGreen)
                                Text("\(daysUntilMilestone) days left")
                                    .font(.caption2)
                                    .foregroundColor(mintGreen)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    
                    // Progress bar for milestone
                    if !milestone.completed {
                        VStack(spacing: 8) {
                            HStack(spacing: 4) {
                                let segmentCount = 10
                                let filledSegments = Int(CGFloat(completionPercentage) / 100.0 * CGFloat(segmentCount))
                                
                                ForEach(0..<segmentCount, id: \.self) { index in
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(
                                            index < filledSegments ?
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(red: 0.2, green: 1.0, blue: 0.7),
                                                    Color(red: 0.0, green: 0.85, blue: 0.65)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ) :
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.gray.opacity(0.15),
                                                    Color.gray.opacity(0.1)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(height: 8)
                                        .shadow(color: index < filledSegments ? Color(red: 0.0, green: 0.85, blue: 0.65).opacity(0.6) : Color.clear, radius: 4, x: 0, y: 0)
                                }
                            }
                            
                            HStack {
                                Text("Progress towards milestone")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("\(completionPercentage)%")
                                    .font(.caption2.weight(.semibold))
                                    .foregroundColor(Color(red: 0.0, green: 0.85, blue: 0.65))
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                            
                            Text("Milestone completed!")
                                .font(.caption2.weight(.semibold))
                                .foregroundColor(.green)
                            
                            Spacer()
                        }
                    }
                }
                .padding(20)
                .background(Color.white)
            }
        }
        .cornerRadius(20)
        .shadow(color: mintGreen.opacity(0.2), radius: 16, x: 0, y: 8)
    }
}

struct StatBadge: View {
    let value: String
    let label: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressMilestoneCard(
            milestone: Milestone(
                id: "1",
                businessIdeaId: "test",
                title: "Launch MVP",
                description: "Launch the first version of the product",
                dueDate: Calendar.current.date(byAdding: .day, value: 15, to: Date()) ?? Date(),
                completed: false,
                order: 1,
                createdAt: Date(),
                userId: "test"
            ),
            completionPercentage: 65,
            totalMilestones: 5,
            completedMilestones: 2
        )
        
        Spacer()
    }
    .padding(20)
    .background(Color(uiColor: .systemGray6))
}
