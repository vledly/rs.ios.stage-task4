import Foundation

final class CallStation {
    var userSet: Set<User> = .init()
    var callArray: [Call] = .init()
}

extension CallStation: Station {
    func users() -> [User] {
        Array(userSet)
    }
    
    func add(user: User) {
        userSet.insert(user)
    }
    
    func remove(user: User) {
        userSet.remove(user)
    }
    
    func execute(action: CallAction) -> CallID? {
        switch action {
        case .start(let from, let to):
            guard userSet.contains(from) else {
                return nil
            }
            let callId = UUID()
            if let current = currentCall(user: to) {
                callArray.append( Call(id: callId, incomingUser: from, outgoingUser: to, status: .ended(reason: .userBusy)) )
            } else {
                if userSet.contains(to) {
                    callArray.append( Call(id: callId, incomingUser: from, outgoingUser: to, status: .calling) )
                } else {
                    callArray.append( Call(id: callId, incomingUser: from, outgoingUser: to, status: .ended(reason: .error)) )
                }
            }
            return callId
        case .answer(let from):
            guard let index = callArray.firstIndex(where: {
                $0.outgoingUser.id == from.id
            }) else {
                return nil
            }
            if userSet.contains(from) {
                callArray[index].updateCallstatus(status: .talk)
            } else {
                callArray[index].updateCallstatus(status: .ended(reason: .error))
                return nil
            }
            return callArray[index].id
        case .end(let from):
            guard let index = callArray.firstIndex(where: {
                $0.outgoingUser.id == from.id || $0.incomingUser.id == from.id
            }) else {
                return nil
            }
            switch callArray[index].status {
            case .calling:
                callArray[index].updateCallstatus(status: .ended(reason: .cancel))
            case .talk:
                callArray[index].updateCallstatus(status: .ended(reason: .end))
            case .ended(let reason):
                break
            }
            
            return callArray[index].id
        }
    }
    
    func calls() -> [Call] {
        callArray
    }
    
    func calls(user: User) -> [Call] {
        callArray.filter { $0.incomingUser.id == user.id || $0.outgoingUser.id == user.id }
    }
    
    func call(id: CallID) -> Call? {
        callArray.first(where: { $0.id == id })
    }
    
    func currentCall(user: User) -> Call? {
        for call in callArray {
            switch call.status {
            case .calling, .talk:
                if call.incomingUser.id == user.id || call.outgoingUser.id == user.id {
                    return call
                }
            case .ended(let reason):
                continue
            }
        }
        return nil
    }
    
}
