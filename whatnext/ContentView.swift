//
//  ContentView.swift
//  whatnext
//
//  Created by Sid Ajay on 8/8/24.
//

import SwiftUI

class TaskList: ObservableObject {
    @Published var tasks: Array<Task> = [Task(content: "")]
    
    func addEmpty() {
        let t = Task(content: "")
        tasks.append(t)
    }
}

struct Task: Identifiable {
    let id = UUID()
    var content: String
    var timed: Bool = true
    var alarm: Bool = false
    var time: Date = Date.now
    
    mutating func timeEnable() {
        timed = !timed
    }
    mutating func alarmEnable() {
        alarm = !alarm
    }
}

struct TaskRow: View {
    @Binding var task: Task
    
    var body: some View {
        HStack {

            Text("")
            TextField("Type here", text: $task.content)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .tint(.white)
            if task.timed {

                HStack {
                    Spacer()
                        .padding(.horizontal)
                    ZStack {
                        //Color.pink.edgesIgnoringSafeArea(.all)
                        Text(task.time,style:.time).foregroundStyle(.white).opacity(0.5)
                        DatePicker("", selection: $task.time, displayedComponents: .hourAndMinute).opacity(0.01000001)
                    }
                }
            }
            Button{
                task.timeEnable()
                print("btn")
            } label: {
                Image(systemName: "clock").resizable()
                    .foregroundColor(task.timed ? (task.alarm ? .red : .yellow) : .black)
                    .bold()
            }.buttonStyle(PlainButtonStyle())
            .frame(width: 20.0, height: 20.0)
            
        }
    }
}

struct ContentView: View {
    
    @ObservedObject private var tasks = TaskList()
    
    var body: some View {
        
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                
                Text("What Next")
                    .bold(true)
                    .font(.title)
                    .foregroundStyle(.white)
                
                Spacer()
                
                List {
                    ForEach(Array($tasks.tasks), id: \.id){$task in
                        TaskRow(task: $task)
                            .swipeActions{
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    tasks.tasks.removeAll(where: {$0.id == task.id})
                                }
                            }.tint(.red)
                            .swipeActions(edge:.leading){
                                Button("Time", systemImage: "alarm") {
                                    if task.timed {task.alarmEnable()}
                                }
                            }.tint(task.timed ? .blue : .gray)
                    }.listRowBackground(Color.green)
                }.listStyle(.plain)
                .scrollContentBackground(.hidden)
                
                Spacer()
                
                HStack {
                    Spacer()
                        .frame(width: 20.0)
                    
                    Text(String($tasks.tasks.count) + " tasks")
                        .foregroundStyle(.white)
                        .padding(.top, 20.0)
                        .opacity(0.5)
                        .frame(maxWidth:60)
                    
                    Spacer()
                    
                    Button{
                        tasks.addEmpty()
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                            .buttonStyle(.plain)
                    }.padding(/*@START_MENU_TOKEN@*/.bottom, 10.0/*@END_MENU_TOKEN@*/).multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Button{
                        // summon settings: flip, zoom, help,esl color,
                    } label: {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 20.0)
                    .frame(maxWidth:60)
                    
                    Spacer()
                        .frame(width: 20.0)
                }
            }
            .padding()
            

        }
            
    }
}

#Preview {
    ContentView()
}

