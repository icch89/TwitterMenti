//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON


class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "NPvRjIlPguqpfLdhr7xTN6wjJ", consumerSecret:"06bk4JARA4paqnHbQ0MWnmcq3TOwfSWjCZh6M16Vs7vcXpF5aC")

    override func viewDidLoad() {
        super.viewDidLoad()
        

        

        
        
    }

    @IBAction func predictPressed(_ sender: Any) {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText,lang: "en", count: 100, tweetMode: .extended ,success: { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<100 {
                    if let tweet = results[i]["full_text"].string{
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                do {
                    let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                    
                    var sentimentScore = 0
                    
                    for prediction in predictions {
                        let sentiment = prediction.label
                        
                        if sentiment == "Pos" {
                            sentimentScore += 1
                        }
                        else if sentiment == "Neg" {
                            sentimentScore -= 1
                        }
                    }
                    if sentimentScore > 20 {
                        self.sentimentLabel.text = "😍"
                    }
                    else if sentimentScore > 10 {
                        self.sentimentLabel.text = "😁"
                    }
                    else if sentimentScore > 0 {
                        self.sentimentLabel.text = "🙂"
                    }
                    else if sentimentScore == 0 {
                        self.sentimentLabel.text = "😑"
                    }
                    else if sentimentScore > -10 {
                        self.sentimentLabel.text = "🙁"
                    }
                    else if sentimentScore > -20 {
                        self.sentimentLabel.text = "😣"
                    }
                    else {
                        self.sentimentLabel.text = "😱"
                    }
                }
                catch {
                    print("There was an error making predication\(error)")
                }
                
                
                
                
            }) { (error) in
                print("Error twitter request\(error)")
            }
        }
    
    }

    
}

