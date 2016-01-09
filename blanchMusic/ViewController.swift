//
//  ViewController.swift
//  blanchMusic
//
//  Created by 大森　亮佑 on 2014/09/20.
//  Copyright (c) 2014年 Ryosuke Omori. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {
    
    var webView : UIWebView = UIWebView()
    var sameArtistTable : UITableView!
    var artistName : String!
    var similarArtists : NSArray!
    var bestYouTubeId : String!
    var lastfmRequest = LastfmRequest()
//    var artistList : [[String:String]] = [
//        ["image":"hogehoge", "name":"ONEOKROCK"],
//        ["image":"hhhh", "name":"ELLE"],
//        ["image":"alkdf", "name":"GALNELYUS"]
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sameArtistSubView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sameArtistSubView() {
        
        let max_w = self.view.frame.width
        let max_h = self.view.frame.height
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.webView.frame = CGRectMake(0, 0, max_w, max_h/2)
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        
        let url : NSURL = NSURL.URLWithString(NSURL("https://www.youtube.com/watch?feature=player_detailpage&v=\(bestYouTubeId)"))!
        let urlRequest: NSURLRequest = NSURLRequest(URL: url)
        self.webView.loadRequest(urlRequest)

        
        sameArtistTable = UITableView(frame: CGRectMake(0, max_h/2, max_w, max_h/2), style: UITableViewStyle.Plain)
        sameArtistTable.delegate = self
        sameArtistTable.dataSource = self
        self.view.addSubview(sameArtistTable)
        
    }
    
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return similarArtists.count
    }
    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
//        cell.textLabel?.text = artistList[indexPath.row]["name"]
//        return cell
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        //        cell.text = artistList[indexPath.row]["name"] as String
        cell.textLabel?.text = similarArtists[indexPath.row]["name"] as? String
        return cell;
    }
    
    func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
//        var text: String = similarArtists[indexPath.row]["name"]
//        println(text)
//        var artistName3: String! =  similarArtists[indexPath.row]["name"] as? String
        let nextView = ViewController()
        nextView.artistName = similarArtists[indexPath.row]["name"] as? String
//        var artistName2: String = similarArtists[indexPath.row]["name"] as? String
//        var similarArtists = lastfmRequest.getSimilarArtist(artistName)
//        var bestYouTubeId = lastfmRequest.getBestTrackYoutubeId(artistName)
        let similarArtists2 = lastfmRequest.getSimilarArtist(nextView.artistName)
        let bestYouTubeId = lastfmRequest.getBestTrackYoutubeId(nextView.artistName)
        nextView.similarArtists = similarArtists2
        nextView.bestYouTubeId = bestYouTubeId
        
        self.presentViewController(nextView, animated: true, completion: nil)

    }
}

