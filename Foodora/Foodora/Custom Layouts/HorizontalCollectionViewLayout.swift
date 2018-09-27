//
//  HorizontalCollectionViewLayout.swift
//  Foodora
//
//  Created by Brandon Danis on 2018-09-24.
//  Copyright © 2018 FoodoraInc. All rights reserved.
//

import UIKit
import Foundation

public extension UICollectionView {
    /// A convenient way to create a UICollectionView and configue it with a CenteredCollectionViewFlowLayout.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the collection view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This frame is passed to the superclass during initialization.
    ///   - centeredCollectionViewFlowLayout: The `CenteredCollectionViewFlowLayout` for the `UICollectionView` to be configured with.
    public convenience init(frame: CGRect = .zero, horizontalLayout: HorizontalCollectionViewLayout) {
        self.init(frame: frame, collectionViewLayout: horizontalLayout)
        decelerationRate = UIScrollViewDecelerationRateNormal
    }
}

open class HorizontalCollectionViewLayout : UICollectionViewFlowLayout {
    
    var numberOfColumns = 1
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentWidth : CGFloat = 0
    
    private var width : CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    private var height : CGFloat {
        get {
            return collectionView!.bounds.height
        }
    }
    
    private var cellWidth : CGFloat {
        get {
            return width * 0.70
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: (cellWidth * CGFloat(numberOfItems)), height: height)
        }
    }
    
    private var numberOfItems : Int {
        get {
            return collectionView!.numberOfItems(inSection: 0)
        }
    }
    
    public override init() {
        super.init()
        scrollDirection = .horizontal
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func prepare() {
        if (cache.isEmpty) {
            var frame = CGRect.zero
            var currentX : CGFloat = 0.0
            
            for item in 0..<numberOfItems {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                frame = CGRect(x: currentX, y: 0, width: cellWidth, height: height)
                attribute.frame = frame
                cache.append(attribute)
                
                currentX = frame.maxX
            }
        }
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var prospectAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if rect.intersects(attribute.frame) {
                prospectAttributes.append(attribute)
            }
        }
        
        return prospectAttributes
    }
    
    // Continuously invalidate the layout as the user scrolls
//    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
    
//    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        let itemIndex = round(proposedContentOffset.y / dragOffset)
//        let yOffset = itemIndex * dragOffset
//        return CGPoint(x: 0, y: yOffset)
//    }

}
