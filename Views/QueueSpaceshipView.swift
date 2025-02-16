import SwiftUI

struct QueueSpaceshipView: View {
    @State private var spaceships: [String] = []
    @State private var newSpaceship: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Queues")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            Text("A queue is a FIFO (First In, First Out) data structure where elements are added at the end and removed from the front.")
                .foregroundColor(.white)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Main Operations:")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                BulletPoint("Enqueue: Add an element to the end of the queue")
                BulletPoint("Dequeue: Remove and return the front element")
                BulletPoint("Front: View the front element without removing it")
                BulletPoint("isEmpty: Check if the queue is empty")
            }
            
            Text("Practical Applications:")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            BulletPoint("Process management in operating systems")
            BulletPoint("Print queue management")
            BulletPoint("Task scheduling")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(spaceships, id: \.self) { spaceship in
                        SpaceshipCard(name: spaceship)
                            .transition(.slide)
                    }
                }
                .padding()
            }
        }
        .padding(.vertical)
    }
}

struct SpaceshipCard: View {
    let name: String
    
    var body: some View {
        Text(name)
            .font(.system(size: 20, weight: .medium))
            .foregroundColor(.white)
            .padding()
            .frame(width: 150, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.green.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.green, lineWidth: 2)
            )
    }
} 