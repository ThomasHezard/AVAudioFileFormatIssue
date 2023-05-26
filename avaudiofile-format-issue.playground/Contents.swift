import AVFoundation

let formats = ["AIFF", "CAF-AAC", "DASH", "M4A", "MP3", "WAV"]
let extensions = ["aiff", "caf", "m4a", "mp3", "mp4", "wav"]

for format in formats {
    for ext in extensions {
        print("Opening \(format) file with .\(ext) extension...")
        do {
            try AVAudioFile(forReading: Bundle.main.url(forResource: "marimba-\(format.lowercased())", withExtension: ext)!)
            print("✅ Succeeded to open \(format) file with .\(ext) extension")
        } catch {
            print("❌ Failed to open \(format) file with .\(ext) extension")
        }
        print("")
    }
    print("Opening \(format) file with no extension...")
    do {
        try AVAudioFile(forReading: Bundle.main.url(forResource: "marimba-\(format.lowercased())", withExtension: "")!)
        print("✅ Succeeded to open \(format) file with no extension")
    } catch {
        print("❌ Failed to open \(format) file with no extension")
    }
    print("")
}
