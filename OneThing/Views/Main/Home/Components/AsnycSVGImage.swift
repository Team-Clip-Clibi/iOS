//
//  AsnycSVGImage.swift
//  OneThing
//
//  Created by 오현식 on 6/22/25.
//

import SwiftUI
import WebKit

struct AsyncSVGImage: UIViewRepresentable {
    
    enum Shape {
        // TODO: 임시, 둥근 사각형으로 표시하기 위해 사용
        case rounded(CGFloat)
    }
    
    let urlString: String
    let shape: Shape
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        // 표시할 SVG에 자바스크립트가 없다면 비활성화
        configuration.defaultWebpagePreferences.allowsContentJavaScript = false
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: self.urlString) else { return }
        
        // 둥근 사각형
        var clipPathCSS: String {
            switch self.shape {
            case let .rounded(radius):
                return "clip-path: inset(0 round \(radius)px);"
            }
        }
        
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
                            background-color: transparent;
                        }
                        img {
                            width: 100%;
                            height: auto;
                            display: block;
                            object-fit: contain;
                            \(clipPathCSS)
                        }
                    </style>
                </head>
                <body>
                    <img src="\(url.absoluteString)" alt="SVG Image">
                </body>
                </html>
                """
        
        uiView.loadHTMLString(htmlString, baseURL: url.deletingLastPathComponent())
    }
}
