import SwiftUI

struct IslandTimelineView: View {
    @StateObject private var viewModel = IslandTimelineViewModel()
    @EnvironmentObject private var businessPlanStore: BusinessPlanStore
    @State private var selectedIsland: Island?
    @State private var showAIChat = false
    
    var body: some View {
        ZStack(alignment: .top) {
            TimelineBackgroundView()
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 32) {
                    TimelineHeaderView(
                        journeyName: currentJourneyTitle,
                        currentStageTitle: currentStageTitle,
                        completionRate: completionRate,
                        onOpenCurrent: openCurrentStage,
                        onChat: { showAIChat = true }
                    )
                    .padding(.top, 16)
                    
                    let stages = stageMetadata()
                    ForEach(Array(stages.enumerated()), id: \.element.id) { index, metadata in
                        TimelineItemView(
                            metadata: metadata,
                            previousStatus: index > 0 ? stages[index - 1].status : nil,
                            isLast: index == stages.count - 1,
                            onTap: {
                                selectedIsland = metadata.island
                            }
                        )
                    }
                    
                    Spacer(minLength: 80)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 160)
            }
            
            VStack {
                Spacer()
                JourneySummaryCard(
                    completed: completedCount,
                    total: max(viewModel.islands.count, 1)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .sheet(item: $selectedIsland) { island in
            IslandDetailView(
                island: island,
                viewModel: viewModel,
                onComplete: {
                    viewModel.completeIsland(id: island.id)
                    viewModel.moveToNextIsland()
                }
            )
        }
        .sheet(isPresented: $showAIChat) {
            AIProgressAssistantView(viewModel: viewModel)
        }
        .onAppear {
            setupTimeline()
            viewModel.connectToStore(businessPlanStore)
        }
    }
}

// MARK: - Computed Helpers
private extension IslandTimelineView {
    var currentJourneyTitle: String {
        if let idea = businessPlanStore.selectedBusinessIdea {
            return idea.title
        }
        return "Your Business Journey"
    }
    
    var currentStageTitle: String {
        if let stage = viewModel.islands[safe: viewModel.currentIslandIndex] {
            return stage.title
        }
        return viewModel.islands.first?.title ?? "Getting Started"
    }
    
    var completionRate: Double {
        guard !viewModel.islands.isEmpty else { return 0 }
        return Double(completedCount) / Double(viewModel.islands.count)
    }
    
    var completedCount: Int {
        if !viewModel.journeyProgress.completedIslandIds.isEmpty {
            return viewModel.journeyProgress.completedIslandIds.count
        }
        let completedByIndex = viewModel.islands.enumerated().filter { index, island in
            index < viewModel.currentIslandIndex || island.isCompleted
        }
        return completedByIndex.count
    }
    
    func stageMetadata() -> [StageMetadata] {
        viewModel.islands.enumerated().map { index, island in
            let status = status(for: index, island: island)
            return StageMetadata(
                island: island,
                index: index,
                status: status,
                alignment: alignment(for: index)
            )
        }
    }
    
    func status(for index: Int, island: Island) -> StageStatus {
        if island.isCompleted || viewModel.journeyProgress.completedIslandIds.contains(island.id) {
            return .completed
        }
        if index == viewModel.currentIslandIndex {
            return .current
        }
        if index < viewModel.currentIslandIndex {
            return .completed
        }
        return .locked
    }
    
    func alignment(for index: Int) -> StageAlignment {
        if index == 0 { return .center }
        return index.isMultiple(of: 2) ? .right : .left
    }
    
    func openCurrentStage() {
        guard let current = viewModel.islands[safe: viewModel.currentIslandIndex] else { return }
        selectedIsland = current
    }
    
    func setupTimeline() {
        if let idea = businessPlanStore.selectedBusinessIdea {
            viewModel.syncWithDashboard(businessIdea: idea)
        } else if let firstIdea = businessPlanStore.businessIdeas.first {
            businessPlanStore.selectIdea(firstIdea)
            viewModel.syncWithDashboard(businessIdea: firstIdea)
        }
    }
}

// MARK: - Safe Array Indexing
private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

// MARK: - Supporting Types
private struct StageMetadata: Identifiable {
    let island: Island
    let index: Int
    let status: StageStatus
    let alignment: StageAlignment
    
    var id: String { island.id }
}

private enum StageStatus {
    case locked
    case current
    case completed
}

private enum StageAlignment {
    case left
    case center
    case right
}

// MARK: - Background
private struct TimelineBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.91, green: 0.98, blue: 0.93),
                Color(red: 0.85, green: 0.96, blue: 0.92),
                Color(red: 0.95, green: 0.97, blue: 0.99)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .overlay(
            VStack(spacing: 40) {
                ForEach(0..<6, id: \.self) { index in
                    Capsule()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: CGFloat.random(in: 40...120), height: 14)
                        .blur(radius: 30)
                        .opacity(0.2)
                        .offset(x: index.isMultiple(of: 2) ? -140 : 140)
                }
            }
        )
    }
}

// MARK: - Header
private struct TimelineHeaderView: View {
    let journeyName: String
    let currentStageTitle: String
    let completionRate: Double
    let onOpenCurrent: () -> Void
    let onChat: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(journeyName.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.green.opacity(0.7))
                    Text(currentStageTitle)
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.primary)
                        .lineLimit(2)
                    Text("Stay on your streak! \(Int(completionRate * 100))% complete")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
                Spacer()
                Button(action: onChat) {
                    Image(systemName: "bubble.left.and.exclamationmark.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .padding(14)
                        .background(Circle().fill(Color.green.opacity(0.7)))
                        .shadow(color: Color.green.opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(.plain)
            }
            
            ProgressView(value: completionRate)
                .tint(Color.green)
                .shadow(color: Color.green.opacity(0.3), radius: 6, x: 0, y: 3)
            
            Button(action: onOpenCurrent) {
                HStack {
                    Text("Continue")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(.headline)
                }
                .foregroundStyle(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.green)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 14)
        )
    }
}

// MARK: - Timeline Item
private struct TimelineItemView: View {
    let metadata: StageMetadata
    let previousStatus: StageStatus?
    let isLast: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if let previousStatus {
                TimelineConnector(color: connectorColor(for: previousStatus))
                    .frame(width: 12, height: 46)
                    .frame(maxWidth: .infinity)
            } else {
                Spacer(minLength: 12)
            }
            
            HStack(alignment: .top) {
                if metadata.alignment == .left {
                    stageBadge
                    Spacer(minLength: 48)
                } else if metadata.alignment == .right {
                    Spacer(minLength: 48)
                    stageBadge
                } else {
                    Spacer()
                    stageBadge
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            
            if !isLast {
                TimelineConnector(color: connectorColor(for: metadata.status))
                    .frame(width: 12, height: 46)
                    .frame(maxWidth: .infinity)
            } else {
                Spacer(minLength: 8)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: metadata.status)
    }
    
    private var stageBadge: some View {
        TimelineStageBadge(
            island: metadata.island,
            status: metadata.status,
            alignment: metadata.alignment,
            action: onTap
        )
    }
    
    private func connectorColor(for status: StageStatus) -> Color {
        switch status {
        case .completed:
            return Color.green.opacity(0.8)
        case .current:
            return Color.green.opacity(0.6)
        case .locked:
            return Color.gray.opacity(0.3)
        }
    }
}

// MARK: - Timeline Stage Badge
private struct TimelineStageBadge: View {
    let island: Island
    let status: StageStatus
    let alignment: StageAlignment
    let action: () -> Void
    
    @State private var bounce = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(backgroundGradient)
                        .frame(width: 88, height: 88)
                        .shadow(color: shadowColor, radius: status == .locked ? 3 : 12, x: 0, y: 8)
                    Circle()
                        .strokeBorder(borderGradient, lineWidth: 4)
                        .frame(width: 88, height: 88)
                    Image(systemName: iconName)
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(iconColor)
                        .scaleEffect(status == .current && bounce ? 1.08 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.9).repeatForever(autoreverses: true),
                            value: bounce
                        )
                }
                
                Text(island.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(textColor)
                    .multilineTextAlignment(textAlignment)
                    .lineLimit(2)
                    .frame(maxWidth: 160)
            }
        }
        .buttonStyle(.plain)
        .disabled(status == .locked)
        .onAppear {
            if status == .current { bounce = true }
        }
    }
    
    private var backgroundGradient: LinearGradient {
        switch status {
        case .completed:
            return LinearGradient(colors: [Color(red: 0.34, green: 0.73, blue: 0.38), Color(red: 0.23, green: 0.62, blue: 0.29)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .current:
            return LinearGradient(colors: [Color(red: 0.56, green: 0.86, blue: 0.42), Color(red: 0.27, green: 0.7, blue: 0.33)], startPoint: .top, endPoint: .bottom)
        case .locked:
            return LinearGradient(colors: [Color(red: 0.82, green: 0.83, blue: 0.85), Color(red: 0.76, green: 0.77, blue: 0.79)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    private var borderGradient: LinearGradient {
        switch status {
        case .completed:
            return LinearGradient(colors: [Color.white.opacity(0.6), Color.white.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .current:
            return LinearGradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .locked:
            return LinearGradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    private var iconName: String {
        switch island.type {
        case .start:
            return "star.fill"
        case .milestone:
            return "flag.fill"
        case .treasure:
            return "gift.fill"
        case .regular:
            return "book.fill"
        }
    }
    
    private var iconColor: Color {
        switch status {
        case .locked:
            return Color.white.opacity(0.7)
        default:
            return Color.white
        }
    }
    
    private var textColor: Color {
        switch status {
        case .locked:
            return Color.gray.opacity(0.7)
        default:
            return Color.primary
        }
    }
    
    private var textAlignment: TextAlignment {
        switch alignment {
        case .left:
            return .leading
        case .right:
            return .trailing
        case .center:
            return .center
        }
    }
    
    private var shadowColor: Color {
        switch status {
        case .locked:
            return Color.black.opacity(0.08)
        case .current:
            return Color.green.opacity(0.45)
        case .completed:
            return Color.green.opacity(0.35)
        }
    }
}

// MARK: - Connector
private struct TimelineConnector: View {
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(color)
    }
}

// MARK: - Journey Summary Card
private struct JourneySummaryCard: View {
    let completed: Int
    let total: Int
    
    private var completionText: String {
        "\(completed) of \(total) stages completed"
    }
    
    private var percentageText: String {
        guard total > 0 else { return "0%" }
        let ratio = Double(completed) / Double(total)
        return "\(Int(ratio * 100))%"
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Journey Progress")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(completionText)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(percentageText)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.green)
                ProgressView(value: total == 0 ? 0 : Double(completed) / Double(total))
                    .progressViewStyle(.linear)
                    .tint(Color.green)
                    .frame(width: 120)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 12)
        )
    }
}
