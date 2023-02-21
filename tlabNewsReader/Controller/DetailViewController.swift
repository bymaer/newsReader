//
//  DetailViewController.swift
//  tlabNewsReader
//
//  Created by Artyom Mayorov on 2/4/23.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKUIDelegate  {


    var detailItem: Articles?
    var detailItemTitleLabel = UILabel()
    var detailItemImageView = UIImageView()
    var detailItemDescriptionLabel = UITextView()
    var detailItemDateLabel = UILabel()
    var detailItemSourceLabel = UILabel()
    var detailItemLinkLabel = UILabel()
    let formatter = ISO8601DateFormatter()
    
    private var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.frame, configuration: webConfiguration)
        webView.layer.position = .zero
        webView.scrollView.bounces = false
        webView.center = self.view.center
        webView.uiDelegate = self
        webView.insetsLayoutMarginsFromSafeArea = true

        
        detailItemImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 400)
        detailItemImageView.loadFrom(URLAddress: detailItem!.urlToImage)
        view.addSubview(detailItemImageView)
        
        detailItemTitleLabel.frame = CGRect(x: 0, y: detailItemImageView.frame.maxY-150, width: view.frame.width, height: 150)
        detailItemTitleLabel.textAlignment = .center
        detailItemTitleLabel.text = detailItem?.title
        detailItemTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        detailItemTitleLabel.numberOfLines = 0
        detailItemTitleLabel.textColor = .white
        detailItemTitleLabel.layer.shadowOffset = .zero
        detailItemTitleLabel.layer.shadowOpacity = 1
        detailItemTitleLabel.layer.shadowColor = UIColor.black.cgColor
        detailItemTitleLabel.layer.shadowRadius = 10
        view.addSubview(detailItemTitleLabel)
    

        detailItemDescriptionLabel.frame = CGRect(x: 10, y: detailItemImageView.frame.maxY, width: view.frame.width-10, height: 300)
        detailItemDescriptionLabel.font = UIFont(name: "Georgia", size: 19)
        detailItemDescriptionLabel.isScrollEnabled = false
        detailItemDescriptionLabel.isEditable = false
        detailItemDescriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        detailItemDescriptionLabel.text = detailItem?.description
        view.addSubview(detailItemDescriptionLabel)
        
        
        detailItemLinkLabel.frame = CGRect(x: 10, y: detailItemDescriptionLabel.frame.maxY, width: view.frame.width-10, height: 50)
        detailItemLinkLabel.font = UIFont.systemFont(ofSize: 12.0)
//        detailItemLinkLabel.text = detailItem?.url.absoluteString
        detailItemLinkLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        detailItemLinkLabel.textColor = .blue
        detailItemLinkLabel.attributedText = NSAttributedString(string: (detailItem?.url.absoluteString)!, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        detailItemLinkLabel.addGestureRecognizer(tapGesture)
        
        view.addSubview(detailItemLinkLabel)
       
        detailItemSourceLabel.frame = CGRect(x: 10, y: detailItemImageView.frame.maxY-25, width: self.view.frame.width/2, height: 25)
        detailItemSourceLabel.text = "Source: \(detailItem?.source?.name ?? "")"
        detailItemSourceLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        detailItemSourceLabel.textColor = .white
        detailItemSourceLabel.textAlignment = .left
        detailItemSourceLabel.layer.shadowOffset = .zero
        detailItemSourceLabel.layer.shadowOpacity = 1
        detailItemSourceLabel.layer.shadowColor = UIColor.black.cgColor
        detailItemSourceLabel.layer.shadowRadius = 10
        view.addSubview(detailItemSourceLabel)
        
        detailItemDateLabel.frame = CGRect(x: detailItemSourceLabel.frame.size.width, y: detailItemImageView.frame.maxY-25, width: view.frame.width, height: 25)
        
        let stringDate = String(detailItem!.publishedAt)
        detailItemDateLabel.text = "Date: \(formatter.date(from: stringDate)!)"
        detailItemDateLabel.font = UIFont(name: "HelveticaNeue", size: 12)
        detailItemDateLabel.textColor = .white
        detailItemDateLabel.textAlignment = .left
        detailItemDateLabel.layer.shadowOffset = .zero
        detailItemDateLabel.layer.shadowOpacity = 1
        detailItemDateLabel.layer.shadowColor = UIColor.black.cgColor
        detailItemDateLabel.layer.shadowRadius = 5
        view.addSubview(detailItemDateLabel)
    }
    
    @objc func handleTap() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.url = detailItem?.url
        }
    }

  
}
