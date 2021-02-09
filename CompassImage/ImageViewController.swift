//
//  ImageViewController.swift
//  CompassImage
//
//  Created by Ben Swift on 2/4/21.
//

import Cocoa

enum LayoutOption {
    case Panel
    case Frame
    case Banner
    case Pill
    case None
}

class ImageViewController: NSViewController {

    @IBOutlet weak var backBox: NSBox!
    @IBOutlet weak var imageShadowBox: NSBox!
    @IBOutlet weak var displayImage: NSImageView!
    @IBOutlet weak var choosePanelLayout: NSButton!
    @IBOutlet weak var chooseFrameLayout: NSButton!
    @IBOutlet weak var chooseBannerLayout: NSButton!
    @IBOutlet weak var choosePillLayout: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    
    var selectedImage: NSImage!
    var currentSelectedButton: LayoutOption!
    
    @IBOutlet weak var panelIndicator: NSImageView!
    @IBOutlet weak var frameIndicator: NSImageView!
    @IBOutlet weak var bannerIndicator: NSImageView!
    @IBOutlet weak var pillIndicator: NSImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Choose an Image and Layout"
        currentSelectedButton = .None
        hideSelectionButtons(hideOrShow: false)
        
        self.displayImage.wantsLayer = true
        self.displayImage.layer?.cornerRadius = 12
        self.displayImage.layer?.masksToBounds = true
        
        setUpUI(image: choosePanelLayout)
        setUpUI(image: chooseFrameLayout)
        setUpUI(image: chooseBannerLayout)
        setUpUI(image: choosePillLayout)
        
    }
    
    override func viewDidAppear() {
        self.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // - Helper Functions
    func setUpUI(image: NSButton) {
        print("Setting up the UI")
        image.wantsLayer = true
        image.layer?.cornerRadius = 8
        image.layer?.masksToBounds = true
    }
    
    func hideSelectionButtons(hideOrShow: Bool) {
        self.choosePanelLayout.isEnabled = hideOrShow
        self.chooseFrameLayout.isEnabled = hideOrShow
        self.chooseBannerLayout.isEnabled = hideOrShow
        self.choosePillLayout.isEnabled = hideOrShow
    }
    
    func createImage(layout: LayoutOption) -> NSImage {
        let image = selectedImage
        let bottomImage = image
        var topImage: NSImage!
        
        switch layout {
        case .Panel:
            topImage = NSImage(named: "Panel")
            break
        case .Frame:
            topImage = NSImage(named: "Frame")
            break
        case .Banner:
            topImage = NSImage(named: "Banner")
            break
        case .Pill:
            topImage = NSImage(named: "Pill")
            break
        default:
            NSSound.beep()
            print("Error gettimg image")
            let alert = NSAlert()
            alert.messageText = "Error!"
            alert.informativeText = "Something went wrong and we couldn't get an image. Try again"
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
        
        let newImage = NSImage(size: NSSize(width: 1366, height: 768))
        newImage.lockFocus()
        
        var newImageRect: CGRect = .zero
        newImageRect.size = newImage.size
        
        bottomImage?.draw(in: newImageRect)
        topImage?.draw(in: newImageRect)
        
        newImage.unlockFocus()
        
        return newImage
    }

    @IBAction func selectImageAction(_ sender: Any) {
        guard let window = view.window else { return }

        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.allowedFileTypes = ["png", "jpg", "jpeg"]

        panel.beginSheetModal(for: window) { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                print(panel.urls[0])
                self.selectedImage = NSImage(contentsOf: panel.urls[0])
                self.displayImage.image = self.selectedImage
                self.hideSelectionButtons(hideOrShow: true)
                self.choosePanelLayout.image = self.createImage(layout: .Panel)
                self.chooseFrameLayout.image = self.createImage(layout: .Frame)
                self.chooseBannerLayout.image = self.createImage(layout: .Banner)
                self.choosePillLayout.image = self.createImage(layout: .Pill)
                self.currentSelectedButton = .None
                let shadow = NSShadow()
                shadow.shadowOffset = NSMakeSize(2, -2)
                shadow.shadowColor = NSColor.lightGray
                shadow.shadowBlurRadius = 25

                self.imageShadowBox.shadow = shadow
          }
        }

    }
    
    @IBAction func choosePanelLayoutAction(_ sender: Any) {
        if currentSelectedButton != .Panel {
            self.displayImage.image = createImage(layout: .Panel)
            currentSelectedButton = .Panel
        }
    }
    
    @IBAction func chooseFrameLayoutAction(_ sender: Any) {
        if currentSelectedButton != .Frame {
            self.displayImage.image = createImage(layout: .Frame)
            currentSelectedButton = .Frame
        }
    }
    
    @IBAction func chooseBannerLayoutAction(_ sender: Any) {
        if currentSelectedButton != .Banner {
            self.displayImage.image = createImage(layout: .Banner)
            currentSelectedButton = .Banner
        }
    }
    
    @IBAction func choosePillLayoutAction(_ sender: Any) {
        if currentSelectedButton != .Pill {
            self.displayImage.image = createImage(layout: .Pill)
            currentSelectedButton = .Pill
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = ["png"]
        savePanel.begin { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                if let finalImage = self.displayImage.image {
                    let imageRep = NSBitmapImageRep(data: finalImage.tiffRepresentation!)
                    let pngData = imageRep?.representation(using: NSBitmapImageRep.FileType.png, properties: [:])
                    do {
                        try pngData?.write(to: savePanel.url!)
                        NSSound.beep()
                        print("Success!")
                        let alert = NSAlert()
                        alert.messageText = "Success!"
                        alert.informativeText = "Your new wallpaper has been save to \(String(describing: savePanel.url!))!"
                        alert.alertStyle = .informational
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                    } catch {
                        NSSound.beep()
                        print("Error saving file")
                        let alert = NSAlert()
                        alert.messageText = "Error!"
                        alert.informativeText = "Something went wrong and we couldn't save the file. Try again"
                        alert.alertStyle = .informational
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                    }
                }
            }
        }
    }
    
}

// == .alertFirstButtonReturn
