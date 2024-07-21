//
//  NewInvitationViewController.swift
//  CathayBKHK
//
//  Created by 朱彥睿 on 2024/7/6.
//

import UIKit
import UIComponent
import ComposableArchitecture
import Combine

protocol NewInvitationViewControllerDelegate: AnyObject {
    func didCardTapped(person: Person)
}

final class NewInvitationViewController: UIViewController {
    
    let store = Store(initialState: NewInvitationVM.State(), reducer: { NewInvitationVM() })
    private lazy var viewStore = ViewStore(store, observe: { $0 })
    
    weak var delegate: NewInvitationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binding()
        bindingStyle()
        bindingUI()
    }
    
    private func binding() {
        viewStore.publisher.invitations
            .sink { [weak self] _ in
                self?.componentView.component = self?.component
            }
            .store(in: &cancellables)
        viewStore.publisher
            .isStacked
            .sink { [weak self] _ in
                self?.componentView.component = self?.component
            }
            .store(in: &cancellables)
    }
    
    private func bindingStyle() {
        view.backgroundColor = .background1
        view.clipsToBounds = false
    }
    
    private func bindingUI() {
        view.addSubview(componentView)
        
        componentView.backgroundColor = .background1
        componentView.component = component
        componentView.animator = AnimatedReloadAnimator()
        componentView.clipsToBounds = false
        componentView.delaysContentTouches = false
        componentView.translatesAutoresizingMaskIntoConstraints = false
        
        componentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        componentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        componentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        componentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private var component: Component? {
        if viewStore.invitations.isEmpty { return nil }
        return VStack(spacing: viewStore.isStacked ? -80 : 10) {
            ForEach(viewStore.invitations.enumerated()) { _, person in
                InvitationComponent(person: person)
                    .tappableView { [weak self] in
                        self?.delegate?.didCardTapped(person: person)
                    }
            }
        }
        .inset(
            top: 30,
            left: 30,
            bottom: 0,
            right: 30
        )
        .view()
        .backgroundColor(.background1)
    }
    
    private let componentView = ComponentScrollView()
    private var cancellables: [AnyCancellable] = []
}

private struct InvitationComponent: ComponentBuilder {
    
    var person: Person
    
    func build() -> Component {
        HStack(alignItems: .center) {
            Image("img_friends")
            Space(width: 15)
            VStack(spacing: 2) {
                Text(person.name, font: .regular(size: 16))
                    .textColor(.primaryLabel)
                Text("邀請你成為好友：）", font: .regular(size: 13))
                    .textColor(.brownGray)
            }
            .flex()
            HStack(spacing: 15, alignItems: .center) {
                Image("btn_pink_agree")
                Image("btn_grey_deny")
            }
        }
        .inset(15)
        .view()
        .backgroundColor(.white)
        .cornerRadius(6)
        .update {
            $0.shadowColor = .black.withAlphaComponent(0.1)
            $0.shadowOffset = CGSize(width: 0, height: 4)
            $0.shadowRadius = 8
            $0.shadowOpacity = 1
        }
    }
}


extension NewInvitationViewController {
    
    func populate(person: [Person], isStacked: Bool = true) {
        store.send(.configure(person, stacked: isStacked))
    }
}

