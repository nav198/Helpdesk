//
//  DeviceCardViewHelper.swift
//  Ed
//
//  Created by Beera Naveen on 27/05/25.
//

import Foundation
import SwiftUI

struct DeviceCard: Identifiable {
    let id = UUID()
    let deviceName: String
    let deviceType: String
    let model: String
}

enum DeviceType: String, CaseIterable {
    case printer
    case cpu
    case monitor
    case desktop
    case speaker
    case irCamera = "IR Camera"
    case thinClient = "Thin Client"
    case stabilizer
    case ups
    case projector
}

struct DeviceCardView: View {
    let device: DeviceCard
   
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
           
            Image(imageName(for:device.deviceType))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .background(Color(.systemGray5))
                .clipShape(Rectangle()).cornerRadius(15)
                .padding(.leading, 20)

            VStack(alignment: .leading, spacing: 4) {
                Text(device.deviceName.uppercased())
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(device.deviceType.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Serial-\(device.model)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 16)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.2)))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 20)
    }
    
    func imageName(for type: String) -> String {
        switch type.lowercased() {
        case DeviceType.printer.rawValue:
            return "printer"
        case DeviceType.cpu.rawValue:
            return "cpu"
        case DeviceType.monitor.rawValue:
            return "monitor2"
        case DeviceType.desktop.rawValue:
            return "desktop"
        case DeviceType.speaker.rawValue:
            return "speaker"
        case DeviceType.ups.rawValue:
            return "ups"
        case DeviceType.projector.rawValue:
            return "projector"
        case DeviceType.irCamera.rawValue.lowercased():
                return "camera1"
        case DeviceType.stabilizer.rawValue:
                return "stabilizer"
        case DeviceType.thinClient.rawValue.lowercased():
                return "thin"
        default:
            return "noImage"
        }
    }

}


#Preview {
    DeviceCardView(device: DeviceCard(deviceName: "M229", deviceType: "CPU", model: "Acer 1234"))
}
