//
//  LastfmRequest.swift
//  artistSearch
//
//  Created by Takuya Okamoto on 2014/09/20.
//  Copyright (c) 2014年 Takuya Okamoto. All rights reserved.
//

import Foundation

class LastfmRequest {
    
    func searchArtist(artistName:String) -> NSArray! {
        
        if (artistName == "") {
            return nil
        }
        else {
            var artists:NSArray!
            
            
            let escapedString = artistName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            print("escapedString: \(escapedString)")
            let artistNameEscaped:String = escapedString!
            
            let URL = "http://ws.audioscrobbler.com/2.0/?api_key=3119649624fae2e9531bc4639a08cba8&format=json&method=artist.search&artist=\(artistNameEscaped)"
            print(URL)
            
            
            let json = parseJSON(getJSON(URL))
            let result: NSDictionary = json["results"] as! NSDictionary
            let total:String = result["opensearch:totalResults"] as! String
            if (total == "0") {
                print("none")
                artists = NSArray()
            }
            else {
                let artistmatches: NSDictionary = result["artistmatches"] as! NSDictionary
                artists = artistmatches["artist"] as! NSArray
            }
            
            
            return artists
        }
    }

    func getSimilarArtist(artistName:String) -> NSArray! {
        
        
        if (artistName == "") {
            return nil
        }
        else {
            //var artists:NSArray!
            
            let escapedString = artistName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            print("escapedString: \(escapedString)")
            let artistNameEscaped:String = escapedString!
            
            let URL = "http://ws.audioscrobbler.com/2.0/?api_key=3119649624fae2e9531bc4639a08cba8&format=json&method=artist.getsimilar&artist=\(artistNameEscaped)"
            print(URL)
            
            
            let json = parseJSON(getJSON(URL))
            print(json)
            
            let result: NSDictionary = json["similarartists"] as! NSDictionary
//            var total:String = result["opensearch:totalResults"] as String
//            if (total == "0") {
//                println("none")
//                artists = NSArray()
//            }
//            else {
//                var artistmatches: NSDictionary = result["artistmatches"] as NSDictionary
                let similarList = result["artist"] as! NSArray
//            }
            
            
            return similarList
        }
        
    }
    
    private func getTopTracks(artistName:String) -> NSArray! {
        
        if (artistName == "") {
            return nil
        }
        else {
            var tracks:NSArray!
            
            
            let escapedString = artistName.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            print("escapedString: \(escapedString)")
            let artistNameEscaped:String = escapedString!
            
            let URL = "http://ws.audioscrobbler.com/2.0/?api_key=3119649624fae2e9531bc4639a08cba8&format=json&method=artist.getTopTracks&artist=\(artistNameEscaped)"
            print(URL)
            
            
            let json = parseJSON(getJSON(URL))
//            var result: NSDictionary = json["results"] as NSDictionary
//            var total:String = result["opensearch:totalResults"] as String
//            if (total == "0") {
//                println("none")
//                artists = NSArray()
//            }
//            else {
                let toptracks: NSDictionary = json["toptracks"] as! NSDictionary
                tracks = toptracks["track"] as! NSArray
//            }
            
            
            return tracks
        }
        
    }
    
    
    
    private func getBestYouTubeIDByKeyword(keyword:String) -> String {
    
        
        let YOUTUBE_API_URL = "https://www.googleapis.com/youtube/v3/search"
        let YOUTUBE_API_KEY = "AIzaSyArZbAYSmERlrJTgQggy8bZ_8xU7Y5z0G0"
        
        
        let escapedString = keyword.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        print("escapedString: \(escapedString)")
        let keywordEscaped:String = escapedString!
        
//        
//        NSString *url = [NSString stringWithFormat:@"%@%@%@%@%@%@",
//        YOUTUBE_API_URL, @"?key=", YOUTUBE_API_KEY,
//        @"&part=snippet&type=video&order=relevance&regionCode=JP&videoCategoryId=10",//国は日本、カテゴリはMusic
//        @"&q=", keyword];
        
        let URL:String = "\(YOUTUBE_API_URL)?key=\(YOUTUBE_API_KEY)&part=snippet&type=video&order=relevance&regionCode=JP&videoCategoryId=10&q=\(keywordEscaped)&maxResults=10"
        
        print(URL)
        
        let json = parseJSON(getJSON(URL))
        
//        println(json)
        //            var result: NSDictionary = json["results"] as NSDictionary
        //            var total:String = result["opensearch:totalResults"] as String
        //            if (total == "0") {
        //                println("none")
        //                artists = NSArray()
        //            }
        //            else {
//        var toptracks: NSDictionary = json["toptracks"] as NSDictionary
//        tracks = toptracks["track"] as NSArray
        //            }
        
        let results:NSArray = json["items"] as! NSArray
        
        let firstId:NSDictionary = results[0]["id"] as! NSDictionary
        
        let videoId:String = firstId["videoId"] as! String
        return videoId

    }
    
    
    func getBestTrackYoutubeId(artistName:String) -> String {
        
        let tracks:NSArray = getTopTracks(artistName)
        let topTrackname:String = tracks[0]["name"] as! String
        
        let keyword = "\(artistName) \(topTrackname)"
        
        let bestId = getBestYouTubeIDByKeyword(keyword)
        
        return bestId
    }
    
    
    
    
    
    
    
    //----------------------------------------------------
    private func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    private func parseJSON(inputData: NSData) -> NSDictionary{
        //var error: NSError?
        let boardsDictionary: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        return boardsDictionary
        
    }

}


