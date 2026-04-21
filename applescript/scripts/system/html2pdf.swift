import WebKit
import AppKit
import Foundation

class PDFRenderer: NSObject, WKNavigationDelegate {
    let webView: WKWebView
    let outputPath: String

    init(outputPath: String) {
        self.outputPath = outputPath
        let config = WKWebViewConfiguration()
        // Use a wide enough frame; height will be determined by content
        self.webView = WKWebView(frame: NSRect(x: 0, y: 0, width: 612, height: 792), configuration: config)
        super.init()
        self.webView.navigationDelegate = self
    }

    func render(htmlPath: String) {
        let url = URL(fileURLWithPath: htmlPath)
        webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Count .page divs to determine page count
        webView.evaluateJavaScript("Math.max(document.querySelectorAll('.page, .page-flex').length, 1)") { result, _ in
            let pageCount = result as? Int ?? 1
            let pageWidth: CGFloat = 612
            let pageHeight: CGFloat = 792

            // Resize webView to fit all pages stacked vertically
            webView.frame = NSRect(x: 0, y: 0, width: pageWidth, height: pageHeight * CGFloat(pageCount))

            // Allow re-layout
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let pdfDocument = NSMutableData()
                var mediaBox = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

                guard let consumer = CGDataConsumer(data: pdfDocument as CFMutableData),
                      let pdfContext = CGContext(consumer: consumer, mediaBox: &mediaBox, nil) else {
                    print("Error: could not create PDF context")
                    exit(1)
                }

                let group = DispatchGroup()
                var pageImages: [Int: CGImage] = [:]

                for page in 0..<pageCount {
                    group.enter()
                    let config = WKSnapshotConfiguration()
                    config.rect = CGRect(x: 0, y: CGFloat(page) * pageHeight, width: pageWidth, height: pageHeight)

                    webView.takeSnapshot(with: config) { image, error in
                        if let image = image, let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                            pageImages[page] = cgImage
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    for page in 0..<pageCount {
                        pdfContext.beginPDFPage(nil)
                        if let cgImage = pageImages[page] {
                            pdfContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))
                        }
                        pdfContext.endPDFPage()
                    }
                    pdfContext.closePDF()
                    pdfDocument.write(toFile: self.outputPath, atomically: true)
                    print("PDF saved: \(self.outputPath) (\(pageCount) pages)")
                    exit(0)
                }
            }
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Navigation failed: \(error)")
        exit(1)
    }
}

// Accept CLI arguments: html2pdf <input.html> <output.pdf>
let args = CommandLine.arguments
guard args.count >= 3 else {
    print("Usage: html2pdf <input.html> <output.pdf>")
    exit(1)
}

let inputPath = args[1]
let outputPath = args[2]

let app = NSApplication.shared
app.setActivationPolicy(.prohibited)
let renderer = PDFRenderer(outputPath: outputPath)
renderer.render(htmlPath: inputPath)
app.run()
