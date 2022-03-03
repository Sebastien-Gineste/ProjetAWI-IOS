//
//  PDF.swift
//  ProjetAWI-IOS
//
//  Created by m1 on 03/03/2022.
//

import Foundation
import WebKit
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
struct PDF {
    static func createPDF(action : ((String) -> Void)?) {
        let html = "<table><thead><tr><th colspan=\"2\" >The table header</th></tr></thead><tbody><tr><td>The table body</td><td>with two columns</td></tr></tbody></table>"
        let fmt = UIMarkupTextPrintFormatter(markupText: html)

        // 2. Assign print formatter to UIPrintPageRenderer

        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)

        // 3. Assign paperRect and printableRect

        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)

        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")

        // 4. Create PDF context and draw

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)

        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        // 5. Save PDF file

        /*let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0]
        try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
*/
        /*
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        if !FileManager.default.fileExists(atPath: path.absoluteString) {
        try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }

*/
       /* let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent("test.pdf")
        print(path)*/

       /* let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]*/
        //pdfData.write(toFile: "\(path)", atomically: true)
        /*let url = URL (string: "\(path)")!
        UIApplication.shared.open (url)*/
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]

        pdfData.write(toFile: "\(path)/file.pdf", atomically: true)
        
        action?("file://\(path)/file.pdf")
    }
}
