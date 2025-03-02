import UIKit

@MainActor
public class CoachmarkManager {
    
    public static let shared = CoachmarkManager()
    private var coachmarksData: [[String: Any]] = []
    private var currentCoachmarkIndex: Int = 0
    private var parentView: UIView?

    private init() {}
    
    public func showCoachmarks(fromJson json: Any, in parentView: UIView) {
        self.parentView = parentView
        self.currentCoachmarkIndex = 0

        var jsonDict: [String: Any] = [:]

        if let arrayJson = json as? [[String: Any]], let firstItem = arrayJson.first {
            jsonDict = firstItem
        } else if let dictJson = json as? [String: Any] {
            jsonDict = dictJson
        } else {
            return
        }

        if let ndJsonString = jsonDict["nd_json"] as? String,
           let ndJsonData = ndJsonString.data(using: .utf8),
           let parsedNdJson = try? JSONSerialization.jsonObject(with: ndJsonData) as? [String: Any] {
            jsonDict = parsedNdJson
        } else if let ndJsonDict = jsonDict["nd_json"] as? [String: Any] {
            jsonDict = ndJsonDict
        }
        
        let coachmarkCount: Int
        if let count = jsonDict["nd_coachmarks_count"] as? Int {
            coachmarkCount = count
        } else if let countString = jsonDict["nd_coachmarks_count"] as? String, let countInt = Int(countString) {
            coachmarkCount = countInt
        } else {
            return
        }
        
        var steps: [[String: Any]] = []
        for index in 1...coachmarkCount {
            let idKey = "nd_view\(index)_id"
            let titleKey = "nd_view\(index)_title"
            let subtitleKey = "nd_view\(index)_subtitle"

            if let targetId = jsonDict[idKey] as? String,
               let title = jsonDict[titleKey] as? String,
               let message = jsonDict[subtitleKey] as? String {
                steps.append([
                    "targetViewId": targetId,
                    "title": title,
                    "message": message
                ])
            } else {
                print("Skipping step \(index): Missing id/title/subtitle in JSON")
            }
        }
        
        self.coachmarksData = steps
        
        showNextCoachmark()
    }




    private func showNextCoachmark() {
        guard currentCoachmarkIndex < coachmarksData.count, let parentView = self.parentView else {
            return
        }

        let step = coachmarksData[currentCoachmarkIndex]
        if let targetId = step["targetViewId"] as? String,
           let targetView = findViewByIdentifier(targetId, in: parentView) {

            let title = step["title"] as? String ?? ""
            let message = step["message"] as? String ?? ""

            let coachmark = CoachmarkView(
                targetView: targetView,
                title: title,
                message: message,
                currentIndex: currentCoachmarkIndex + 1,
                totalSteps: coachmarksData.count,
                frame: parentView.bounds
            )
            
            coachmark.onNext = { [weak self, weak coachmark] in
                coachmark?.removeFromSuperview()
                self?.currentCoachmarkIndex += 1
                self?.showNextCoachmark()
            }

            coachmark.onSkip = { [weak self, weak coachmark] in
                coachmark?.removeFromSuperview()
                self?.currentCoachmarkIndex = self?.coachmarksData.count ?? 0
            }

            parentView.addSubview(coachmark)
        } else {
            currentCoachmarkIndex += 1
            showNextCoachmark()
        }
    }
    
    private func findViewByIdentifier(_ identifier: String, in view: UIView) -> UIView? {
        if view.accessibilityIdentifier == identifier {
            return view
        }
        for subview in view.subviews {
            if let found = findViewByIdentifier(identifier, in: subview) {
                return found
            }
        }
        return nil
    }
}
