//
//  ViewController.swift
//  ReactiveCocoaSwiftPods
//
//  Created by Zhen Gong on 10/28/18.
//  Copyright © 2018 Zhen Gong. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

public class SomeRandomAPIClass: NSObject {
    
    //********************************************************************************************//
    
    public static func someAsynWorkFromGithub(previousValue: Int) -> SignalProducer <[String], NSError> {
        return SignalProducer<[String], NSError>.init({(observer, lifeTime) in
            let githubEndPoint: String = "https://api.github.com/users?since=\(previousValue)"
            guard let url = URL(string: githubEndPoint) else {
                return
            }

            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    observer.send(error: NSError(domain: error.localizedDescription, code: 0, userInfo: ["error":"info"]))
                } else {
                    if let data = data, let _ = response {
                        // trackObj("data", obj: data)
                        // parse json and stuff
                        do {
                            if let array = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                                var loginArray: [String] = []
                                for element in array {
                                    guard let dict = element as? [String: AnyObject] else {
                                        continue;
                                    }
                                    if let login: String = dict["login"] as? String {
                                        loginArray.append(login)
                                    }
                                }
                                observer.send(value: loginArray)
                                observer.sendCompleted()
                            }
                        } catch {
                            observer.send(error: error as NSError)
                        }
                    } else {
                        observer.send(error: NSError(domain: "fake.domain.error.some.async.Work", code: 0, userInfo: ["error":"info"]))
                    }
                }
            })
            task.resume()
        })
    }
    
    public static func someAsynWork(previousValue: Int) -> SignalProducer<Int, NSError> {
        // Faking some asyng request here. Using signal producer to make a cold observable.
        return SignalProducer<Int, NSError> { (observer, lifetime) in
            guard !lifetime.hasEnded else { // making sure none of this work is done for nothing. This block should cancel any async task ongoing
                observer.sendInterrupted()
                return
            }
            print("Doing some work on:", previousValue) // loggin for timeline in console
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(arc4random_uniform(3)), execute: {
                let i = Int(arc4random_uniform(10)) // random generation to emulate succes/failure of the call
                if i == 0 { // The call failed, sending an error
                    print("Sending an error!!")
                    observer.send(error: NSError(domain: "fake.domain.error.some.async.Work", code: i, userInfo: ["error":"info"])) // fake error is being sent
                    // No completed should be send. error is always the last thing sent from a signal.
                } else {
                    print("Sending:", previousValue + 1)
                    observer.send(value: previousValue + 1) // call completed, new value has been generated.
                    observer.sendCompleted() // Since this is a fake network call, we will only send one value. Terminating the observer.
                }
            })
        }
    }
}

public class SomeViewControllerViewModel: NSObject {
    private let generalAppState: GeneralAppState // storiung the state to be updated with this VM. Ideally, a manager should handle this.
    
    public lazy var numberOfTapDisplayableSignal: SignalProducer<String, NoError> = {
        return self.numberOfTapSignal.map({ value -> String in
            print("value:\(value)")
            return String(value) // Doing any random work of formatting job here.
        })
    }()
    public let numberOfTapSignal:SignalProducer<Int, NoError> // Signal here is for internal use only as the VM job is to apply some formating on the value.
    // For the sake of the example, we transform this Int into a String. Any kind of formating, filter or other goes here in the VM. (Ideally using formater class so the formating can be shared between clases)
    // Important thing to notice, the Signal is a constant as it will never change. Only the value send trought it will.
    
    //********************************************************************************************//
    public lazy var numberOfGitsDisplayableSignal: SignalProducer<String, NoError> = {
        return self.numberOfGitsSignal.map({ value -> String in
            // trackString("value:\(value)")
            return (value.description)
        })
    }()
    public let numberOfGitsSignal: SignalProducer<[String], NoError>
    //********************************************************************************************//
    
    //********************************************************************************************//
    public lazy var numberOfGitsDisplayableTapCountSignal: SignalProducer<Int, NoError> = {
        return self.numberOfGitsTapCountSignal.map({ value -> Int in
            return value
        })
    }()
    public let numberOfGitsTapCountSignal: SignalProducer<Int, NoError>
    //********************************************************************************************//
    
    public required init(generalAppState: GeneralAppState) {// passing state as a paramater here = dependency injection. Enable you for an easier testing as you can pass "mocked" instance of the state.
        
        // storing without exposing to be able to update the state.
        self.generalAppState = generalAppState
        // Only exposing here part of the state that are needed by the VC.
        self.numberOfTapSignal = generalAppState.numberOfTapSignal
        self.numberOfGitsSignal = generalAppState.numberOfGitsSignal
        self.numberOfGitsTapCountSignal = generalAppState.numberOfTapGitsSignal
        super.init()
    }
    
    // Parameter here is not really needed. Used for showcasing capture in the VC.
    func createSomeAPIRequest(parameter: Int) -> SignalProducer<Int, NSError> {
        return generalAppState.someAsynWork(previousValue: parameter)
    }
    
    func createSomeGithubAPIRequest(parameter: Int) -> SignalProducer<[String], NSError> {
        return generalAppState.someAsynWorkFromGithub(previousValue: parameter)
    }
}

public class GeneralAppState: NSObject {
    
    // simple signleton implementation.
    public static var shared = GeneralAppState() // should be init with default state and all.
    private override init() { super.init() }
    
    
    // internal state of the app. To enforce reactive programming and avoid mistakes by programmer, the state should always be private.
    // Mutable property is a mix between a regular variable and a RAC signal.
    // Great tool to help converting our app since it can be both used as a variable and as a signal.
    public let numberOfTaps: MutableProperty<Int> = MutableProperty<Int>(0) // property here is thread safe.
    
    // Creating a public interface for our state.
    // Our general state should only be exposing Signals.
    public lazy var numberOfTapSignal = { // Type here is SignalProducer<Int, NoError>
        return self.numberOfTaps.producer.skipRepeats()
        // using produer is creating a cold observable (read cold vs hot observables) // state is almost always watched in cold observables
        // Enabling skip repeat here is a design choice.
        // I pretend that this state will be for UI updates only thus doesn't need to do any extra work is value stays the same.
    }()
    
    // ***************************************************************************************************************** //
    // https://eliaszsawicki.com/reactivecocoa-4-mutableproperty/
    public let numberOfGits: MutableProperty<[String]> = MutableProperty<[String]>([])
    public lazy var numberOfGitsSignal = {
        return self.numberOfGits.producer.skipRepeats({ (i, j) -> Bool in
            return false
        })
    }()
    // ***************************************************************************************************************** //
    
    // ***************************************************************************************************************** //
    // https://eliaszsawicki.com/reactivecocoa-4-mutableproperty/
    public let numberOfTapGits: MutableProperty<Int> = MutableProperty<Int>(0)
    public lazy var numberOfTapGitsSignal = {
        return self.numberOfTapGits.producer.skipRepeats()
    }()
    // ***************************************************************************************************************** //

    public func someAsynWork(previousValue: Int) -> SignalProducer<Int, NSError> {
        return SomeRandomAPIClass.someAsynWork(previousValue: previousValue).on(value: { [weak self] (result) in
            // Updating the app state as part of a side effect. This will allow every part of the app to be notified of the new state.
            self?.numberOfTaps.value = result
            print("General State:", result)
        })
    }
    
    public func someAsynWorkFromGithub(previousValue: Int) -> SignalProducer<[String], NSError> {
        return SomeRandomAPIClass.someAsynWorkFromGithub(previousValue: previousValue).on(starting: nil, started: nil, event: nil, failed: nil, completed: nil, interrupted: nil, terminated: nil, disposed: nil, value: { [weak self] (result) in
            self?.numberOfGits.value = result
            // trackObj("result", obj: result)
        })
    }
}

class ViewController: UIViewController {
    
    private var viewModel: SomeViewControllerViewModel
    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = SomeViewControllerViewModel(generalAppState: GeneralAppState.shared)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.installViewConstraints() // installing layout
//        self.installSignals() // installing RAC bindings.
        self.installSignalsFromGithub() // installing RAC bindings.
    }
    
    private func installSignalsFromGithub() {
        githubLabel.reactive.text <~ viewModel.numberOfGitsDisplayableSignal.map({ (value) -> String in
            return "githubLabel:\(value)"
        }).observe(on: UIScheduler())

        let disposable = someActionButton.reactive.controlEvents(.touchUpInside)
            // .withLatest(from: viewModel.numberOfGitsSignal)
            .withLatest(from: viewModel.numberOfTapSignal)
            .map({ (buttonTapped, numberOfTap) -> (SignalProducer<String, NSError>?, UIButton) in
                                
            })
            
//            .map { [weak self] (buttonTapped, responseArray) -> (SignalProducer<[String], NSError>?, UIButton) in
//                print("Button tapped, captured value is", responseArray)
//                UIScheduler().schedule {
//                    buttonTapped.backgroundColor = .gray
//                    buttonTapped.isEnabled = false
//                }
//                return (self?.viewModel.createSomeGithubAPIRequest(parameter: responseArray.count), buttonTapped)
//            }.observeValues { (signal, button) -> Void in
//                signal?.on(starting: { // we are registering to all possible event on the signal. Thi sis not necessary. For this show case, it help to see the life cycle in the console.
//                    print("update request signal [starting]") // starting is the first part being called.
//                }, started: { // the signal has started to do some work.
//                    print("update request signal [started]")
//                }, event: { (event) in // called for every event send (starting, started...)
//                    print("update request signal [Event]", event)
//                }, failed: { (error) in // called when an error has been generated
//                    let error = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                    error.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    UIScheduler().schedule {
//                        self.present(error, animated: true, completion: nil) // showing error on our page.
//                    }
//                    print("update request signal [ERROR]", error)
//                }, completed: { // signal has completed sucessfully.
//                    print("update request signal completed")
//                }, interrupted: { // signal has been stopped programatically.
//                    print("update request signal [interupted]")
//                }, terminated: { [weak self] in // signal is finished (both completed, error and interrupted) similar to "always"
//                    print("update request signal [terminated]")
//                    UIScheduler().schedule {
//                        button.backgroundColor = .red
//                        button.isEnabled = true
//                    }
//                    }, disposed: { // signal is released from emmory
//                        print("update request signal [disposed]")
//                }, value: { (value) in // signal has emited a value
//                    print("update request signal [value]", value)
//                }).start() // manually starting the cold observable.
        }

        destroySignalFlow.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            print("Destroy signal") // destroying the previous signal. No action can be taken anymore on this. All async actions are canceled. most of the time this is not needed and will be safe to use with ARC.
            // However a signle leak could leak to a lot of memory being use for no reason.
            disposable?.dispose()
        }
    }
    
    private func installSignals() {
        someLabel.reactive.text <~ viewModel.numberOfTapDisplayableSignal.map({ (value) -> String in // UI Related work goes here
            return "Number of tap value: \(value)"
        }).observe(on: UIScheduler()) // making sure scheduler is observing on main thread for UI operation.

        // creating the main part of this app.
        // the signal respoible of triggering an event here is the tap on the button. We are injecting with this event the latest value we have from our VM (getting it from the global state)
        let disposable = someActionButton.reactive.controlEvents(.touchUpInside) // creating a signal for the button tap.
            .withLatest(from: viewModel.numberOfTapSignal)
            .map { [weak self] (buttonTapped, numberOfTap) -> (SignalProducer<Int, NSError>?, UIButton) in // this is really easy to forget about reference capture here, weak or unowned self must be used in most cases.
                // the button has been tapped, we are capturing our state from the VM and printing it.
                print("Button tapped, captured value is", numberOfTap)

                // We are making some updates on the UI to prevent duplicate action.
                UIScheduler().schedule {
                    buttonTapped.backgroundColor = .gray
                    buttonTapped.isEnabled = false
                }

                // converting the value into a API request, passing the button along to be able to enable the button again when the async work is done.
                return (self?.viewModel.createSomeAPIRequest(parameter: numberOfTap), buttonTapped)
            }.observeValues { (signal, button) -> Void in // Here the registration to the values are done. We are observing a Signal (think hot observable) that will be triggered for each tap on the button.
                // For each tap, the view model will generate a cold signal (createSomeAPIRequest) that will be emited in this block. Since this signal is a cold signal, we need to start it manually.

                signal?.on(starting: { // we are registering to all possible event on the signal. Thi sis not necessary. For this show case, it help to see the life cycle in the console.
                    print("update request signal [starting]") // starting is the first part being called.
                }, started: { // the signal has started to do some work.
                    print("update request signal [started]")
                }, event: { (event) in // called for every event send (starting, started...)
                    print("update request signal [Event]", event)
                }, failed: { [weak self] (error) in // called when an error has been generated
                    let error = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    error.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    UIScheduler().schedule {
                        self?.present(error, animated: true, completion: nil) // showing error on our page.
                    }
                    print("update request signal [ERROR]", error)
                }, completed: { // signal has completed sucessfully.
                    print("update request signal completed")
                }, interrupted: { // signal has been stopped programatically.
                    print("update request signal [interupted]")
                }, terminated: { [weak self] in // signal is finished (both completed, error and interrupted) similar to "always"
                    print("update request signal [terminated]")
                    UIScheduler().schedule {
                        button.backgroundColor = .red
                        button.isEnabled = true
                    }
                    }, disposed: { // signal is released from emmory
                        print("update request signal [disposed]")
                }, value: { (value) in // signal has emited a value
                    print("update request signal [value]", value)
                }).start() // manually starting the cold observable.
        } // returning a disposable, enabling us to control life cycle of the signal.


        destroySignalFlow.reactive.controlEvents(.touchUpInside).observeValues { (button) in
            print("Destroy signal") // destroying the previous signal. No action can be taken anymore on this. All async actions are canceled. most of the time this is not needed and will be safe to use with ARC.
            // However a signle leak could leak to a lot of memory being use for no reason.
            disposable?.dispose()
        }
    }
    
    // random UI Stuff Nothing to see here!
    private func installViewConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubview(someLabel)
        container.addSubview(someActionButton)
        container.addSubview(destroySignalFlow)
        container.addSubview(githubLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        someLabel.translatesAutoresizingMaskIntoConstraints = false
        someActionButton.translatesAutoresizingMaskIntoConstraints = false
        destroySignalFlow.translatesAutoresizingMaskIntoConstraints = false
        githubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        container.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0).isActive = true
        container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0.0).isActive = true
        container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0.0).isActive = true
        container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0.0).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        someLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        someLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10).isActive = true
        someLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10).isActive = true

        someActionButton.topAnchor.constraint(equalTo: someLabel.bottomAnchor, constant: 16).isActive = true
        someActionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        someActionButton.leadingAnchor.constraint(equalTo: someLabel.leadingAnchor).isActive = true
        someActionButton.trailingAnchor.constraint(equalTo: someLabel.trailingAnchor).isActive = true

        destroySignalFlow.topAnchor.constraint(equalTo: someActionButton.bottomAnchor, constant: 16).isActive = true
        destroySignalFlow.heightAnchor.constraint(equalToConstant: 40).isActive = true
        destroySignalFlow.leadingAnchor.constraint(equalTo: someLabel.leadingAnchor).isActive = true
        destroySignalFlow.trailingAnchor.constraint(equalTo: someLabel.trailingAnchor).isActive = true

        githubLabel.topAnchor.constraint(equalTo: destroySignalFlow.bottomAnchor, constant: 16).isActive = true
        githubLabel.leadingAnchor.constraint(equalTo: destroySignalFlow.leadingAnchor).isActive = true
        githubLabel.trailingAnchor.constraint(equalTo: destroySignalFlow.trailingAnchor).isActive = true
        githubLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private let container: UIView = {
        let container = UIView()
        return container
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.yellow
        return scrollView
    }()
    
    private let someActionButton: UIButton = {
        let someActionButton = UIButton()
        someActionButton.setTitle("Increment", for: .normal)
        someActionButton.backgroundColor = .red
        return someActionButton
    }()
    private let destroySignalFlow: UIButton = {
        let destroySignalFlow = UIButton()
        destroySignalFlow.setTitle("Disable Signal", for: .normal)
        destroySignalFlow.backgroundColor = UIColor.black
        return destroySignalFlow
    }()
    private let someLabel: UILabel = {
        let someLabel = UILabel()
        someLabel.textAlignment = .center
        someLabel.backgroundColor = UIColor.red
        return someLabel
    }()
    
    private let githubLabel: UILabel = {
        let githubLabel = UILabel()
        githubLabel.textAlignment = .left
        githubLabel.numberOfLines = 0
        githubLabel.backgroundColor = UIColor.lightGray
        return githubLabel
    }()


}

