/*
It took me some time to get data persistence with Codable in Swift 4 to work. Internet resources mostly only showed what has changed in Swift 4, missing a complete guide how to persist data. Maybe I looked in the wrong places. After getting it to work, I decided to put together a simple example as a future reference for myself, but also for others who are new to this. In the example, I'm storing an array which contains objects of a custom type (Album). If all properties of a custom type conform to Codable, you can simply declare that custom type Codable itself. But the part that I struggled with was the actual encoding and decoding, reading and writing of the data.
*/

import UIKit

// IMPORTANT: Declare conformance to Codable for your custom type
struct Album: Codable {
    let title: String
    let artist: String
    let trackCount: Int
    let trackList: [String]
    var rating: Double
}

var albums: [Album]?

// IMPORTANT: Get the URL for reading and writing data
let archiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("albums")

// IMPORTANT: To save the data, first encode it, then write it to the URL
func saveAlbums() {
    do {
        let data = try JSONEncoder().encode(albums)
        try data.write(to: archiveURL)
    } catch {
        print(error.localizedDescription)
    }
}

// IMPORTANT: To load the data, first create a Data object with the stored data, then decode it to the correct type. The first argument for decoding is your  type (in this case [Album], meaning an array of Album objects), followed by ".self".
func loadAlbums() -> [Album]? {
    do {
        let data = try Data(contentsOf: archiveURL)
        return try JSONDecoder().decode([Album].self, from: data)
    } catch {
        print(error.localizedDescription)
    }
    return nil
}

// Just a printing helper
func printAlbums() {
    if let albums = albums {
        for album in albums {
            print("Title:", album.title,
                  "\nArtist:", album.artist,
                  "\nTrack Count:", album.trackCount,
                  "\nTrack List:", album.trackList,
                  "\nRating:", album.rating, "\n")
        }
    } else {
        print("No albums.\n")
    }
    print("\n---\n")
}

// Just sample data
let a = Album(
    title: "... And Justice For All",
    artist: "Metallica",
    trackCount: 9,
    trackList: ["Blackened",
                "... And Justice For All",
                "Eye of the Beholder",
                "One",
                "The Shortest Straw",
                "Harvester of Sorrow",
                "The Frayed Ends of Sanity",
                "To Live Is to Die",
                "Dyers Eve"],
    rating: 5)

let b = Album(
    title: "In Between Dreams",
    artist: "Jack Johnson",
    trackCount: 14,
    trackList: ["Better Together",
                "Never Know",
                "Banana Pancakes",
                "Good People",
                "No Other Way",
                "Sitting, Waiting, Wishing",
                "Staple It Together",
                "Situations",
                "Crying Shame",
                "If I Could",
                "Breakdown",
                "Belle",
                "Do You Remember",
                "Constellations"],
    rating: 4.5)

albums = [a, b]


// SAVING
saveAlbums()
printAlbums()

// Delete albums to show that loading works
albums = nil
printAlbums()

// LOADING
if let storedAlbums = loadAlbums() {
    albums = storedAlbums
}
printAlbums()

