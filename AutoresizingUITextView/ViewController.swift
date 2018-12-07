//
//  ViewController.swift
//  AutoresizingUITextView
//
//  Created by Charles Martin Reed on 12/6/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        textView.backgroundColor = .lightGray
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.text = "Here is some default text that may or may not be word-wrapped depending upon the screen size. Here is some default text that may or may not be word-wrapped depending upon the screen size."
        
        //now, we're going to use autolayout to dynamically resize our textview's frame
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textView) //had to add subview before attempting to set constraints
        
        let constraints = [
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 50) //fixed height
                           ]
        NSLayoutConstraint.activate(constraints)
        
        //MARK:- Resizing fix
        textView.delegate = self
        textView.isScrollEnabled = false //stops the text view from pushing older text off the screen up top.
        
        textViewDidChange(textView) //fix for issue where default text would fall to trigger frame resizing
    }


}

extension ViewController: UITextViewDelegate {
    //protocol oriented programming, rather than extending the main class with UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        //resizing according to text inside using the method sizeThatFits
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        //grabbing the height constraint anchor and changing it
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height //calculations are handled by iOS
            }
        }
    }
}
