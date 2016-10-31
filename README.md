# THImageBrowser
THImageBrowser

##简洁调用
```swift
        let numberOfViews = 3
        BrowserPageViewController.show(startAt:(sender.view?.tag)!-1, sourceAt:{ (index) -> BrowserViewable? in
            if index > numberOfViews || index<0{return nil}
            let viewable = BrowserViewable()
            viewable.index = index
            viewable.imageUrl = self.originalURL[index]
            let imageV = self.view.viewWithTag(index + 1) as! UIImageView
            viewable.placeholder = imageV.image
            return viewable
        }).configurableFade(inView:sender.view!, outView: { (index) -> UIView? in
            return self.view.viewWithTag(index+1)
        })
```

