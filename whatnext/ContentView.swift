//
//  ContentView.swift
//  whatnext
//
//  Created by Sid Ajay on 8/8/24.
//

import SwiftUI
import SwiftData
let dark_colors = [
    "bg" : Color(.black),
    "inactive" : Color(.gray),
    "clock" : Color(.green),
    "contrast" : Color(.white),
    "prompt" : Color(.gray)
]
let light_colors = [
    "bg" : Color(.white),
    "inactive" : Color(.gray),
    "clock" : Color(.green),
    "contrast" : Color(.black),
    "prompt" : Color(.gray)
]

class UserSettings: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var light_mode: Bool
    @Published var color_scheme = dark_colors
    @Published var lefty = false
    
    init() {
        // set defaults if not previuously set
        let initialized = defaults.bool(forKey: "initialized")
        if (!initialized) {
            defaults.set(false, forKey: "light_mode")
            defaults.set(false, forKey: "lefty")
            defaults.set(true, forKey: "initialized")
        }
        // check cached settings
        light_mode = defaults.bool(forKey: "light_mode")
        color_scheme = light_mode ? light_colors : dark_colors
        lefty = defaults.bool(forKey: "lefty")
    }
    
    func toggleLightMode() {
        light_mode = !light_mode
        defaults.set(light_mode, forKey: "light_mode")
        color_scheme = light_mode ? light_colors : dark_colors
    }
    
    func toggleLefty() {
        lefty = !lefty
        defaults.set(lefty, forKey: "lefty")
    }
    
}

struct TaskRow: View {
    @EnvironmentObject var settings: UserSettings
    @Bindable var task: Task
    var body: some View {
        HStack {

            Text("")
            TextField("", text: $task.content,
                prompt: Text("What's next?")
                    .foregroundStyle(settings.color_scheme["prompt"]!))
                .foregroundStyle(settings.color_scheme["contrast"]!)
                .multilineTextAlignment(.center)
                .tint(settings.color_scheme["contrast"])
            if task.timed {
                HStack {
                    Spacer()
                        .padding(.horizontal)
                    ZStack {
                        Text(task.time,style:.time).foregroundStyle(settings.color_scheme["contrast"]!).opacity(0.5)
                        DatePicker("", selection: $task.time, displayedComponents: .hourAndMinute).opacity(0.01000001)
                    }
                }
            }
            Button{
                task.toggleTime()
                print("btn")
            } label: {
                if task.alarm && task.timed {
                    Image(systemName: "alarm").resizable()
                        .foregroundColor(task.timed ? settings.color_scheme["clock"] : settings.color_scheme["inactive"])
                        .bold()
                }
                else {
                    Image(systemName: "clock").resizable()
                        .foregroundColor(task.timed ? settings.color_scheme["clock"] : settings.color_scheme["inactive"])
                        .bold()
                }
            }.buttonStyle(PlainButtonStyle())
            .frame(width: 20.0, height: 20.0)
            
        }.frame(height:40)
    }
}

struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    @State var show_settings = false
    @State var anim_val = 0.0
    var body: some View {
        ZStack {
            settings.color_scheme["bg"]
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PrimaryView(show_settings: $show_settings)//.blur(radius: anim_val*3)
            if show_settings {
                SettingsView(show_settings: $show_settings)
                    //.onAppear{withAnimation(.easeIn){anim_val=1}}
                    //.onDisappear{anim_val=0}
                    .background(.ultraThinMaterial)
                    .transition(.opacity)
            }
        }
        .environment(\.colorScheme, settings.light_mode ? .light : .dark)
    }
}

struct PrimaryView: View {
    @EnvironmentObject var settings: UserSettings
    @Binding var show_settings: Bool
    @Environment(\.modelContext) var modelContext
    @Query var tasks: [Task]
    
    var body: some View {
        VStack {
            
            Text("What Next")
                .bold(true)
                .font(.title)
                .foregroundStyle(settings.color_scheme["contrast"]!)
            
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
                }.listRowBackground(settings.color_scheme["bg"])
                .listRowSeparatorTint(settings.color_scheme["prompt"])
            }.listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            Spacer()
            
            HStack(alignment: .bottom) {
                
                Text(String(tasks.count) + " tasks")
                    .foregroundStyle(settings.color_scheme["contrast"]!)
                    .padding(.leading, 20.0)
                    .opacity(0.5)
                    .frame(maxWidth:80)
                
                Spacer()
                
                Button{
                    addEmptyTask()
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundStyle(settings.color_scheme["contrast"]!)
                        .frame(width: 50, height: 50)
                        .buttonStyle(.plain)
                }
                .multilineTextAlignment(.center)
                
                Spacer()
                

                Button{
                    withAnimation(.easeInOut) {
                        show_settings = true
                    }
                } label: {
                    if !show_settings{
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .foregroundStyle(settings.color_scheme["contrast"]!)
                    }
                }
                .padding(.trailing, 20.0)
                .frame(maxWidth:80, maxHeight: 20)
                
            }.frame(height:50)
            .padding(.bottom, 10.0)
            .environment(\.layoutDirection, settings.lefty ? .rightToLeft : .leftToRight)
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
    @EnvironmentObject var settings: UserSettings
    @Binding var show_settings: Bool
    @State var anim: Double = 0
    
    var body: some View {
        // TODO: settings -> help
        HStack() {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                
                Button {
                    //help
                } label: {
                    Image(systemName: "questionmark.circle")
                        .settings_icon(color: settings.color_scheme["contrast"]!, s_val: 0)
                }
                
                Spacer()
                    .frame(height:40)
                
                Button {
                    withAnimation(.bouncy) {
                        settings.toggleLefty()
                    }
                } label: {
                    Image(systemName: settings.lefty ? "circle.righthalf.filled" : "circle.lefthalf.filled")
                        .settings_icon(color: settings.color_scheme["contrast"]!, s_val: 0)
                }
                
                Spacer()
                    .frame(height:40)

                Button {
                    settings.toggleLightMode()
                } label: {
                    Image(systemName: settings.light_mode ? "lightbulb.circle.fill" : "lightbulb.circle")
                        .settings_icon(color: settings.color_scheme["contrast"]!, s_val: 0)
                }
                
                Spacer()
                    .frame(height:40)
                
                Button {
                    withAnimation(.easeInOut) {
                        show_settings = false
                    }
                    
                } label: {
                    Image(systemName: "gearshape.circle.fill")
                        .settings_icon(color: settings.color_scheme["contrast"]!, s_val: 0)
                }
                
                Spacer()
                    .frame(height:10)
                
            }
        }.padding()
        .environment(\.layoutDirection, settings.lefty ? .rightToLeft : .leftToRight)
    }
}

extension Image {
    func settings_icon(color: Color, s_val: Double) -> some View {
        self
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundStyle(color)
        //.rotation3DEffect(.degrees(180), axis: (-1,-1,0))
            .frame(maxWidth: 80, maxHeight: 20)
            .padding(.trailing, 10.0)
        //.animated_flip(anim_val: s_val, axis: (1,1,0))
    }
}

#Preview {
    ContentView()
}

