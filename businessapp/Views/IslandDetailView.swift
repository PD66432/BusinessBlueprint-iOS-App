import SwiftUI
import EventKit

struct IslandDetailView: View {
    let island: Island
    @ObservedObject var viewModel: IslandTimelineViewModel
    let onComplete: () -> Void
    
    @State private var showAddNote = false
    @State private var showAddReminder = false
    @State private var noteText = ""
    @State private var reminderTitle = ""
    @State private var reminderMessage = ""
    @State private var reminderDate = Date()
    @State private var addToCalendar = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [island.type.color.opacity(0.3), island.type.color.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Island Header
                        IslandHeaderCard(island: island)
                        
                        // Notes Section
                        NotesSection(
                            notes: viewModel.getNotesFor(islandId: island.id),
                            onAddNote: { showAddNote = true },
                            onDeleteNote: { noteId in
                                viewModel.deleteNote(id: noteId)
                            }
                        )
                        
                        // Reminders Section
                        RemindersSection(
                            reminders: viewModel.reminders.filter { $0.islandId == island.id },
                            onAddReminder: { showAddReminder = true },
                            onCompleteReminder: { reminderId in
                                viewModel.completeReminder(id: reminderId)
                            },
                            onDeleteReminder: { reminderId in
                                viewModel.deleteReminder(id: reminderId)
                            }
                        )
                        
                        // Complete Island Button
                        if !island.isCompleted {
                            Button {
                                onComplete()
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "flag.checkered")
                                    Text("Complete Island")
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [.green, .blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle(island.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAddNote) {
                AddNoteSheet(
                    noteText: $noteText,
                    onSave: {
                        viewModel.addNote(content: noteText, islandId: island.id)
                        noteText = ""
                        showAddNote = false
                    },
                    onCancel: {
                        noteText = ""
                        showAddNote = false
                    }
                )
            }
            .sheet(isPresented: $showAddReminder) {
                AddReminderSheet(
                    title: $reminderTitle,
                    message: $reminderMessage,
                    date: $reminderDate,
                    addToCalendar: $addToCalendar,
                    onSave: {
                        viewModel.addReminder(
                            title: reminderTitle,
                            message: reminderMessage,
                            scheduledDate: reminderDate,
                            islandId: island.id,
                            addToCalendar: addToCalendar
                        )
                        
                        // Add to system calendar if requested
                        if addToCalendar {
                            requestCalendarAccess { granted in
                                if granted {
                                    addEventToCalendar(
                                        title: reminderTitle,
                                        notes: reminderMessage,
                                        startDate: reminderDate
                                    )
                                }
                            }
                        }
                        
                        reminderTitle = ""
                        reminderMessage = ""
                        reminderDate = Date()
                        addToCalendar = false
                        showAddReminder = false
                    },
                    onCancel: {
                        reminderTitle = ""
                        reminderMessage = ""
                        reminderDate = Date()
                        addToCalendar = false
                        showAddReminder = false
                    }
                )
            }
        }
    }
    
    // MARK: - Calendar Functions
    private func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        let eventStore = EKEventStore()
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    private func addEventToCalendar(title: String, notes: String, startDate: Date) {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.notes = notes
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(3600) // 1 hour duration
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // Add alarm 15 minutes before
        let alarm = EKAlarm(relativeOffset: -900) // 15 minutes
        event.addAlarm(alarm)
        
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Error saving event to calendar: \(error)")
        }
    }
}

// MARK: - Island Header Card
struct IslandHeaderCard: View {
    let island: Island
    
    var body: some View {
        VStack(spacing: 16) {
            Text(island.type.icon)
                .font(.system(size: 80))
            
            Text(island.title)
                .font(.system(size: 28, weight: .bold))
            
            Text(island.description)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if island.isCompleted, let completedDate = island.completedAt {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    Text("Completed \(completedDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Notes Section
struct NotesSection: View {
    let notes: [ProgressNote]
    let onAddNote: () -> Void
    let onDeleteNote: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Notes", systemImage: "note.text")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    onAddNote()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            
            if notes.isEmpty {
                Text("No notes yet. Add one to track your progress!")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            } else {
                ForEach(notes) { note in
                    NoteCard(note: note, onDelete: {
                        onDeleteNote(note.id)
                    })
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Note Card
struct NoteCard: View {
    let note: ProgressNote
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "note")
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(note.content)
                    .font(.body)
                
                Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Reminders Section
struct RemindersSection: View {
    let reminders: [AppReminder]
    let onAddReminder: () -> Void
    let onCompleteReminder: (String) -> Void
    let onDeleteReminder: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Reminders", systemImage: "bell.fill")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    onAddReminder()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
            
            if reminders.isEmpty {
                Text("No reminders set. Add one to stay on track!")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            } else {
                ForEach(reminders) { reminder in
                    ReminderCard(
                        reminder: reminder,
                        onComplete: {
                            onCompleteReminder(reminder.id)
                        },
                        onDelete: {
                            onDeleteReminder(reminder.id)
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Reminder Card
struct ReminderCard: View {
    let reminder: AppReminder
    let onComplete: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                onComplete()
            } label: {
                Image(systemName: reminder.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(reminder.isCompleted ? .green : .orange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.body)
                    .strikethrough(reminder.isCompleted)
                
                Text(reminder.message)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(reminder.scheduledDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                    
                    if reminder.notifyViaCalendar {
                        Image(systemName: "calendar.badge.plus")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(reminder.isCompleted ? Color.gray.opacity(0.1) : Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Add Note Sheet
struct AddNoteSheet: View {
    @Binding var noteText: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextEditor(text: $noteText)
                    .frame(minHeight: 200)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                    .disabled(noteText.isEmpty)
                }
            }
        }
    }
}

// MARK: - Add Reminder Sheet
struct AddReminderSheet: View {
    @Binding var title: String
    @Binding var message: String
    @Binding var date: Date
    @Binding var addToCalendar: Bool
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Reminder Details") {
                    TextField("Title", text: $title)
                    TextField("Message", text: $message, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Schedule") {
                    DatePicker("Date & Time", selection: $date, in: Date()...)
                    
                    Toggle("Add to Calendar", isOn: $addToCalendar)
                }
                
                if addToCalendar {
                    Section {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text("This will create an event in your device calendar with a 15-minute reminder.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

#Preview {
    IslandDetailView(
        island: Island(
            title: "Launch",
            description: "Launch your business!",
            position: CGPoint(x: 100, y: 100),
            type: .milestone
        ),
        viewModel: IslandTimelineViewModel(),
        onComplete: {}
    )
}
