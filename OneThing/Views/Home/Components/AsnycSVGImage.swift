//
//  AsnycSVGImage.swift
//  OneThing
//
//  Created by 오현식 on 6/22/25.
//

import SwiftUI
import WebKit

struct AsyncSVGImage: UIViewRepresentable {
    
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: self.urlString) else { return }
        
        let htmlString = """
                <!DOCTYPE html>
                <html>
                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                        html, body {
                            margin: 0;
                            padding: 0;
                            width: 100%;
                            height: 100%;
                            overflow: hidden;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                        }
                        img {
                            max-width: 100%;
                            max-height: 100%;
                            width: auto;
                            height: auto;
                            display: block;
                        }
                    </style>
                </head>
                <body>
                    <img src="\(url.absoluteString)" alt="SVG Image">
                </body>
                </html>
                """
        
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
}
