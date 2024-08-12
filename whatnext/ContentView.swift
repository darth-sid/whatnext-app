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
    @State var s_val = 0.0
    @State var blur = 0.0
    var body: some View {
        ZStack {
            bg_color
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            PrimaryView(s_val: $s_val).blur(radius: s_val*2)//.animation(.snappy, value: blur)
            if s_val == 1 {
                SettingsView(s_val: $s_val)
                    //.transition(.opacity)// (scale: 0, anchor: .bottomTrailing))
            }
        }
    }
}

struct PrimaryView: View {
    @Binding var s_val: Double
    @Environment(\.modelContext) var modelContext
    @Query var tasks: [Task]
    @State var anim: Double = 0
    
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
                        withAnimation(Animation.easeOut(duration: 0.5)) {
                            s_val = 1
                        }
                        // summon settings: flip, zoom, help,esl color,
                    } label: {
                        if s_val == 0 {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                                .foregroundStyle(contrast_color)
                                .animated_flip(axis: (-1,-1,0))
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
    @Binding var s_val: Double
    @State var anim: Double = 0
    
    var body: some View {
        HStack() {
            Spacer()
            VStack(alignment: .center) {
                Spacer()
                Button{
                    withAnimation(Animation.easeOut(duration: 1)) {
                        s_val = 0
                    }
                } label: {
                    Image(systemName: "gearshape.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(contrast_color)
                        .animated_flip(axis: (1,1,0))
                }
                .padding(.trailing, 20.0)
                .frame(maxWidth: 80, maxHeight: 20)
                    
            }

        }.padding()
    }
}

extension View {
    func animated_flip(axis: (CGFloat, CGFloat, CGFloat)) -> some View {
        modifier(flipAnimation(axis:axis))
    }
}

struct flipAnimation: ViewModifier {
    var axis: (CGFloat, CGFloat, CGFloat)
    @State var animation_value = 0.0
    func body(content: Content) -> some View{
        return content
            .scaleEffect(animation_value)
            .rotation3DEffect(.degrees(animation_value*180),axis: axis)
            .animation(.easeOut(duration:0.5), value: animation_value)
            .onAppear{animation_value=1}
            .onDisappear{animation_value=0}
    }
}

#Preview {
    ContentView()
}

