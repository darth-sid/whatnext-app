//
//  ContentView.swift
//  whatnext
//
//  Created by Sid Ajay on 8/8/24.
//

import SwiftUI
import SwiftData

let bg_color = Color(.black)
let inactive = Color(.gray)
let clock_color = Color(.green)
let contrast_color = Color(.white)
let prompt_color = Color(.gray)

struct TaskRow: View {
    @Bindable var task: Task
    var body: some View {
        HStack {

            Text("")
            TextField("", text: $task.content,
                      prompt: Text("What's next?")
                        .foregroundStyle(prompt_color)
                        /*.opacity(0.5)*/)
                .foregroundStyle(contrast_color)
                .multilineTextAlignment(.center)
                .tint(contrast_color)
            if task.timed {
                HStack {
                    Spacer()
                        .padding(.horizontal)
                    ZStack {
                        Text(task.time,style:.time).foregroundStyle(contrast_color).opacity(0.5)
                        DatePicker("", selection: $task.time, displayedComponents: .hourAndMinute).opacity(0.01000001)
                    }
                }
            }
            Button{
                task.toggleTime()
                print("btn")
            } label: {
                if task.alarm {
                    Image(systemName: "alarm").resizable()
                        .foregroundColor(clock_color)
                        .bold()
                }
                else {
                    Image(systemName: "clock").resizable()
                        .foregroundColor(task.timed ? clock_color : inactive)
                        .bold()
                }
            }.buttonStyle(PlainButtonStyle())
            .frame(width: 20.0, height: 20.0)
            
        }.frame(height:40)
    }
}

struct ContentView: View {
    @State var settingsToggle: Bool = false
    @State var blur = 0.0
    var body: some View {
        ZStack {
            bg_color
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PrimaryView(settingsToggle: $settingsToggle).blur(radius: blur).animation(.snappy, value: blur)
            if settingsToggle{
                SettingsView(settingsToggle: $settingsToggle)
                    .onAppear {
                        blur = 3.0
                    }
                    .onDisappear {
                        blur = 0.0
                    }
            }
        }
    }
}

struct PrimaryView: View {
    @Binding var settingsToggle: Bool
    @Environment(\.modelContext) var modelContext
    @Query var tasks: [Task]
    
    var body: some View {
        VStack {
            
            Text("What Next")
                .bold(true)
                .font(.title)
                .foregroundStyle(contrast_color)
            
            Spacer()
            
            List {
                ForEach(Array(tasks), id: \.id){task in
                    TaskRow(task: task)
                        .swipeActions{
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                removeTask(task: task)
                            }
                            Button("Complete", systemImage: "checkmark", role: .destructive) {
                                print("done")
                            }.tint(.green)
                        }
                        .swipeActions(edge:.leading){
                            Button("Time", systemImage: "alarm") {
                                if task.timed {task.toggleAlarm()}
                            }.tint(task.timed ? .blue : .gray)
                        }
                }.listRowBackground(bg_color)
                .listRowSeparatorTint(contrast_color)
            }.listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            HStack(alignment: .bottom) {
                
                Text(String(tasks.count) + " tasks")
                    .foregroundStyle(contrast_color)
                    .padding(.leading, 20.0)
                    .opacity(0.5)
                    .frame(maxWidth:80)
                
                Spacer()
                
                Button{
                    addEmptyTask()
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundStyle(contrast_color)
                        .frame(width: 50, height: 50)
                        .buttonStyle(.plain)
                }
                .multilineTextAlignment(.center)
                
                Spacer()
                

                    Button{
                        settingsToggle = true
                        // summon settings: flip, zoom, help,esl color,
                    } label: {
                        if !settingsToggle {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                                .foregroundStyle(contrast_color)
                        }
                    }
                    .padding(.trailing, 20.0)
                .frame(maxWidth:80, maxHeight: 20)
                
            }.frame(height:50)
        }.padding()
    }
    
    func addEmptyTask() {
        modelContext.insert(Task())
    }
    
    func removeTask(task: Task) {
        modelContext.delete(task)
    }
}

struct SettingsView: View {
    @Binding var settingsToggle: Bool
    
    var body: some View {
        HStack() {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                Button{
                    settingsToggle = false
                } label: {
                    Image(systemName: "gearshape.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(contrast_color)
                }
                .padding(.trailing, 20.0)
                .frame(maxWidth: 80, maxHeight: 20)
                    
            }

        }.padding()
            //Spacer().frame(width: 50)
    }
    
}

#Preview {
    ContentView()
}

