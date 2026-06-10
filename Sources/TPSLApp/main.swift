import AppKit
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate {
  private var statusItem: NSStatusItem?
  private var popover: NSPopover?
  private var webView: WKWebView?

  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.accessory)

    let configuration = WKWebViewConfiguration()
    configuration.preferences.javaScriptCanOpenWindowsAutomatically = false

    let webView = WKWebView(frame: .zero, configuration: configuration)
    webView.navigationDelegate = self
    self.webView = webView

    loadCalculator(into: webView)

    let contentController = NSViewController()
    contentController.view = webView
    contentController.preferredContentSize = NSSize(width: 420, height: 520)

    let popover = NSPopover()
    popover.behavior = .transient
    popover.animates = true
    popover.contentSize = contentController.preferredContentSize
    popover.contentViewController = contentController
    self.popover = popover

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    self.statusItem = statusItem

    if let button = statusItem.button {
      button.image = statusIcon()
      button.imagePosition = .imageOnly
      button.toolTip = "TPSL"
      button.target = self
      button.action = #selector(togglePopover(_:))
    }
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    false
  }

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    guard
      navigationAction.navigationType == .linkActivated,
      let url = navigationAction.request.url,
      url.scheme == "http" || url.scheme == "https"
    else {
      decisionHandler(.allow)
      return
    }

    NSWorkspace.shared.open(url)
    decisionHandler(.cancel)
  }

  private func loadCalculator(into webView: WKWebView) {
    guard
      let resourceURL = Bundle.main.resourceURL,
      let indexURL = URL(string: "WebApp/index.html", relativeTo: resourceURL)
    else {
      webView.loadHTMLString("<h1>TPSL resources were not found.</h1>", baseURL: nil)
      return
    }

    webView.loadFileURL(indexURL, allowingReadAccessTo: indexURL.deletingLastPathComponent())
  }

  @objc private func togglePopover(_ sender: NSStatusBarButton) {
    guard let popover else { return }

    if popover.isShown {
      popover.performClose(sender)
      return
    }

    popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
    popover.contentViewController?.view.window?.makeKey()
    NSApp.activate(ignoringOtherApps: true)
  }

  private func statusIcon() -> NSImage? {
    let image = NSImage(size: NSSize(width: 18, height: 18))
    image.lockFocus()

    NSColor.labelColor.setStroke()

    func stroke(_ points: [NSPoint]) {
      let path = NSBezierPath()
      path.lineWidth = 2.2
      path.lineCapStyle = .round
      path.lineJoinStyle = .round
      path.move(to: points[0])
      for point in points.dropFirst() {
        path.line(to: point)
      }
      path.stroke()
    }

    stroke([NSPoint(x: 4, y: 9), NSPoint(x: 14, y: 9)])
    stroke([NSPoint(x: 4, y: 12.5), NSPoint(x: 10, y: 12.5), NSPoint(x: 14, y: 9)])
    stroke([NSPoint(x: 4, y: 5.5), NSPoint(x: 10, y: 5.5), NSPoint(x: 14, y: 9)])

    image.unlockFocus()
    image.isTemplate = true
    return image
  }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
