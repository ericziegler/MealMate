//
//  MainController+DragAndDrop.swift
//  MealMate2
//
//  Created by Eric Ziegler on 8/31/21.
//

import UIKit

extension MainController {
 
    // MARK: - Gesture Recognizers

    func setupGestureRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized(_:)))
        longPressRecognizer.minimumPressDuration = 0.25
        groceryTable.addGestureRecognizer(longPressRecognizer)
    }

    @objc func longPressRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        guard let longPress = gestureRecognizer as? UILongPressGestureRecognizer else {
            return
        }

        let state = longPress.state
        let locationInView = longPress.location(in: groceryTable)
        let indexPath = groceryTable.indexPathForRow(at: locationInView)

        struct MovingCell {
            static var snapshot: UIView? = nil
            static var isAnimating = false
            static var needsToShow = false
        }

        struct Path {
            static var initialIndexPath: IndexPath? = nil
        }

        switch state {
        case .began:
            if let indexPath = indexPath, let cell = groceryTable.cellForRow(at: indexPath) as? GroceryCell {
                Path.initialIndexPath = indexPath
                // TODO: EZ - Do something with this?
//                cell.answerBackground.backgroundColor = UIColor.main
                MovingCell.snapshot = UIView.snapshotAsView(cell)
                MovingCell.snapshot!.clipsToBounds = true
                MovingCell.snapshot!.layer.cornerRadius = 15
                var center = cell.center
                MovingCell.snapshot!.center = center
                groceryTable.addSubview(MovingCell.snapshot!)
                UIView.animate(withDuration: 0.15, animations: {
                    center.y = locationInView.y
                    MovingCell.isAnimating = true
                    MovingCell.snapshot!.center = center
                }) { (completed) in
                    if completed == true {
                        MovingCell.isAnimating = false
                        if MovingCell.needsToShow == true {
                            MovingCell.needsToShow = false
                        } else {
                            cell.isHidden = true
                        }
                    }
                }
            }
        case .changed:
            if let snapshot = MovingCell.snapshot {
                var center = snapshot.center
                center.y = locationInView.y
                snapshot.center = center
                if let indexPath = indexPath, let initialIndexPath = Path.initialIndexPath, indexPath != initialIndexPath {
                    if let grocery = groceryList.grocery(at: initialIndexPath.row, inCategory: Category(rawValue: initialIndexPath.section)!) {
                        let newCategory = Category(rawValue: indexPath.section)!
                        groceryList.moveGrocery(grocery: grocery, toIndex: indexPath.row, inCategory: newCategory)
                        groceryTable.moveRow(at: Path.initialIndexPath!, to: indexPath)
                        Path.initialIndexPath = indexPath
                    }
                }
                // original logic for non-sectioned tableview
//                if let indexPath = indexPath, indexPath != Path.initialIndexPath {
////                    question.answers.insert(question.answers.remove(at: Path.initialIndexPath!.row), at: indexPath.row)
//                    groceryTable.moveRow(at: Path.initialIndexPath!, to: indexPath)
//                    Path.initialIndexPath = indexPath
//                }
            }
        default:
            if let initialPath = Path.initialIndexPath, let cell = groceryTable.cellForRow(at: initialPath) as? GroceryCell {
                if MovingCell.isAnimating == true {
                    MovingCell.needsToShow = true
                } else {
                    cell.isHidden = false
                }
                if let snapshot = MovingCell.snapshot {
                    UIView.animate(withDuration: 0.15, animations: {
                        snapshot.center = cell.center
                        snapshot.transform = CGAffineTransform.identity
                    }) { (completed) in
                        if completed == true {
                            Path.initialIndexPath = nil
                            MovingCell.snapshot?.removeFromSuperview()
                            MovingCell.snapshot = nil
                            self.groceryTable.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}
