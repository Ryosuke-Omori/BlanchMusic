//
//  ViewController.swift
//  artistSearch
//
//  Created by Takuya Okamoto on 2014/09/20.
//  Copyright (c) 2014年 Takuya Okamoto. All rights reserved.
//

import UIKit

class ArtistSearchViewController: UIViewController,UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    var lastfmRequest = LastfmRequest()
    
    var tableView = UITableView()

    var artistList:NSArray = NSArray()
    
    override func viewDidLoad() {
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        super.viewDidLoad()
        initViews()
        
//        var tracks:NSArray! = lastfmRequest.getBestTrackYoutubeId("ELLEGARDEN")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //-------------------------------------------------
    
    func initViews() {
        
        let MAX_W:CGFloat = self.view.frame.size.width
        let MAX_H:CGFloat = self.view.frame.size.height
        
        // ----------- background ------------
        let BG_COLOR = UIColor(red: 0.209553, green: 0.209553, blue: 0.209553, alpha: 1.0)
        let bgView = UIView()
        bgView.frame = CGRectMake(0, 0, MAX_W, MAX_H)
        bgView.backgroundColor = BG_COLOR
        self.view.addSubview(bgView)
        
        
        
        // ----------- title bar ------------
        let STATUS_BAR_HEIGHT:CGFloat = 20
        let TITLE_BAR_HEIGHT:CGFloat = 44
        
        let BAR_COLOR = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        let statusBarBG = UIView()
        statusBarBG.frame = CGRectMake(0, 0, MAX_W, STATUS_BAR_HEIGHT)
        statusBarBG.backgroundColor = BAR_COLOR
        self.view.addSubview(statusBarBG)
        
        let titleBar = UIView()
        titleBar.frame = CGRectMake(0, STATUS_BAR_HEIGHT, MAX_W, TITLE_BAR_HEIGHT)
        titleBar.backgroundColor = BAR_COLOR
        self.view.addSubview(titleBar)
        
        let titleLabel = UILabel()
        titleLabel.frame = titleBar.frame
        titleLabel.text = "Dygg"
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = BG_COLOR
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        let attrText = NSMutableAttributedString(string: "Blanch Music")
        attrText.addAttribute(NSKernAttributeName, value: 6.0, range: NSMakeRange(0, attrText.length))
        titleLabel.attributedText = attrText
        self.view.addSubview(titleLabel)
        
        
        // ----------- serch field ------------
        let TEXT_FIELD_H:CGFloat = 40
        let TEXT_FIELD_M:CGFloat = 80
        //let TABBAR_H:CGFloat = 49
        
        let searchBar = UISearchBar()
        searchBar.frame.size = CGSizeMake(MAX_W - TEXT_FIELD_M, TEXT_FIELD_H)
        searchBar.center = CGPointMake(MAX_W/2, TITLE_BAR_HEIGHT + TEXT_FIELD_M)
        searchBar.placeholder = "Search Artist..."
        searchBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        var searchBarBG = UIImage(named: "grayBar")
        searchBarBG = searchBarBG!.stretchableImageWithLeftCapWidth(10, topCapHeight: 10)
        UISearchBar.appearance().setSearchFieldBackgroundImage(searchBarBG, forState: UIControlState.Normal)
        for subView in searchBar.subviews {
            for secondLevelSubview in subView.subviews  {
                if (secondLevelSubview.isKindOfClass(UITextField)) {
                    let textField:UITextField = secondLevelSubview as! UITextField
                    textField.textColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
                    break
                }
            }
        }
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
//        let underLine = UIView()
//        underLine.frame = CGRectMake(0, 0, searchBar.frame.size.width, 1)
//        underLine.center = CGPointMake(searchBar.center.x, searchBar.center.y + TEXT_FIELD_H/2)
//        underLine.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
//        self.view.addSubview(underLine)
//        
        
        // ----------- result table ------------
        
        let TABLEVIEW_M_H:CGFloat = 160
        tableView.frame = CGRectMake(0, TABLEVIEW_M_H, MAX_W, MAX_H - TABLEVIEW_M_H)
        tableView.backgroundColor = BG_COLOR
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    // ---------------------------- UITableViewDataSource -----------

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
//        cell.text = artistList[indexPath.row]["name"] as String
        cell.textLabel?.text = artistList[indexPath.row]["name"] as? String
        return cell;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let artistName: String = artistList[indexPath.row]["name"] as! String
        
        let similarArtists = lastfmRequest.getSimilarArtist(artistName)
        let bestYouTubeId = lastfmRequest.getBestTrackYoutubeId(artistName)
        
        print(artistName)
        print(similarArtists[0])
        print(bestYouTubeId)
        
        let nextView = ViewController()
        nextView.artistName = artistName
        nextView.similarArtists = similarArtists
        nextView.bestYouTubeId = bestYouTubeId
        
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    // ----------------------------- UISearchBarDelegate -----------------------------------
    var searchDelayer:NSTimer!
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchDelayer != nil {
            searchDelayer.invalidate()
        }
        searchDelayer = nil
        searchDelayer = NSTimer.scheduledTimerWithTimeInterval(0.8, target: self, selector: Selector("doDelaySearch:"), userInfo: searchText, repeats: false)
    }
    
    func doDelaySearch(timer:NSTimer) {
        let artistName:String = timer.userInfo as! String
        searchArtist(artistName)
        searchDelayer = nil
    }
    
    func searchArtist(artistName:String) {
        let result:NSArray! = lastfmRequest.searchArtist(artistName)
        if (result != nil) {
            artistList = result
            tableView.reloadData()
        }
        
    }
    

}

