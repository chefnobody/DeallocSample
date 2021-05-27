//
//  AppDelegate.swift
//  DeallocSample
//
//  Created by Aaron Connolly on 5/27/21.
//

import UIKit
import XCoordinator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let rootCoordinator = RootCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let w = UIWindow(frame: UIScreen.main.bounds)
        window = w
        rootCoordinator.setRoot(for: w)
        
        return true
    }
}

// Root of application

enum RootRoute: Route {
    case home
    case list
}

final class RootCoordinator: NavigationCoordinator<RootRoute> {
    init() {
        super.init(initialRoute: .home)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Push .list onto .home
            self?.trigger(.list)
        }
    }
    
    override func prepareTransition(for route: RootRoute) -> NavigationTransition {
        switch route {
        case .home:
            let v = ViewController("Root", .red)
            return .set([v])
            
        case .list:
            let c = ListCoordinator(rootViewController: rootViewController)
            addChild(c)
            return .none()
        }
    }
}

enum ListRoute: Route {
    case list
    case profile
}

final class ListCoordinator: NavigationCoordinator<ListRoute> {
    init(rootViewController: UINavigationController) {
        super.init(
            rootViewController: rootViewController,
            initialRoute: nil
        )
        
        trigger(.list)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            // Push .list onto .home
            self?.trigger(.profile)
        }
    }
    
    override func prepareTransition(for route: ListRoute) -> NavigationTransition {
        switch route {
        case .list:
            let v = ViewController("List", .yellow)
            return .push(v)
            
        case .profile:
            let c = ProfileCoordinator()
            return .presentFullScreen(c)
        }
    }
}

// ModalCoordinator presented off of some other Coordinator

enum ProfileRoute: Route {
    case dismiss
    case onboarding
    case profile
}

final class ProfileCoordinator: NavigationCoordinator<ProfileRoute> {
    init() {
        super.init(initialRoute: .profile)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.trigger(.onboarding)
        }
    }
    
    override func prepareTransition(for route: ProfileRoute) -> NavigationTransition {
        switch route {
        case .dismiss:
            return .dismiss()
        
        case .onboarding:
            let c = OnboardingCoordinator()
            return .presentFullScreen(c)
            
        case .profile:
            let v = ViewController("Profile", .purple)
            return .set([v])
        }
    }
    
    deinit {
        print("*****")
        print("ProfileCoordinator deinit")
    }
}


// OnboardingCoordinator presented off ModalCoordinator

enum OnboardingRoute: Route {
    case dismiss
    case onboarding
}

final class OnboardingCoordinator: NavigationCoordinator<OnboardingRoute> {
    init() {
        super.init(initialRoute: .onboarding)
    }
    
    override func prepareTransition(for route: OnboardingRoute) -> NavigationTransition {
        switch route {
        case .dismiss:
            return .dismiss()
            
        case .onboarding:
            let v = ViewController("Onboarding", .orange)
            return .set([v])
        }
    }
    
    deinit {
        print("*****")
        print("OnboardingCoordinator deinit")
    }
}

// Full screen Transition helper extension

extension Transition {
    static func presentFullScreen(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        presentable.viewController?.modalPresentationStyle = .fullScreen
        return .present(presentable, animation: animation)
    }
}
