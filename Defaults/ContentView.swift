//
//  ContentView.swift
//  Defaults
//
//  Created by Praneet S on 09/03/21.
//

import SwiftUI

struct ContentView: View {
    @State var bundleID: String = ""
    @State var keys: [String] = []
    @State var defaults: Dictionary<String, AnyObject> = [:]
    @State var isValuePresented: Bool = false
    @State var keyInContext: String = ""
    @State var bundleInContext: String = ""
    @State var valueToSet: String = ""
    @State var typeInContext: String = ""
    @State var domains: [String] = []
    var body: some View {
        HStack {
            List(domains, id: \.self) { domain in
                Text(domain)
                    .onTapGesture {
                        bundleID = domain
                    }
            }.listStyle(SidebarListStyle())
            .frame(minWidth: 350)
        VStack {
            TextField("Bundle identifier", text: $bundleID)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 18))
                .padding([.horizontal, .top])
                .onChange(of: bundleID, perform: { id in
                    if String(id).components(separatedBy: ".").count - 1 >= 2 {
                        let defaults_ = readDefaultsFromBundleID(bundleID: id)
                        guard let keysOfBundle = defaults_?.keys else {
                            return
                        }
                        keys = Array<String>(keysOfBundle)
                        defaults = defaults_ ?? [:]
                        bundleInContext = bundleID
                    }
                })
            Text("Keys")
                .font(.title)
                .bold()
                .padding()
            ScrollView {
                VStack(alignment: .leading, spacing: 5){
                    ForEach(keys, id: \.self) { key in
                        HStack {
                            Text(key)
                                .onTapGesture {
                                    keyInContext = key
                                    isValuePresented = true
                                }
                                .padding(.horizontal)
                            Spacer()
                        }
                    }
                }
            }
        }.frame(width: 400, height: 500, alignment: .center)
    }
    .onAppear {
    domains = getAllDomains()
    }
    .popover(isPresented: $isValuePresented) {
    VStack {
    ScrollView {
    Text("Key: \(keyInContext)")
    .bold()
    Text(typeInContext)
    Text("Current value: \(String(describing: defaults[keyInContext]).replacingOccurrences(of: "Optional", with: ""))")
    .lineLimit(3)
    .padding(.horizontal)
    Text("Set value")
    .bold()
    Text("Warning: Setting an incomptaible value might break the system")
    .foregroundColor(.red)
    TextField("Value", text: $valueToSet)
    .padding(.horizontal)
    Button("Set Value") {
    setValueForKey(key: keyInContext, value: valueToSet, bundleID: bundleInContext, type: typeInContext)
    valueToSet = ""
    }
    }.padding(.top)
    }.frame(width: 300, height: 300, alignment: .center)
    .onAppear {
    typeInContext = readTypeOfKey(key: keyInContext, bundleID: bundleInContext)
    }
    }
}
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
