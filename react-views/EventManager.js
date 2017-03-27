import { EventManager } from 'NativeModules'
// EventManager is an object instance we can use to call our 
// EventManager swift implementation methods

import { NativeEventEmitter } from 'react-native'
const nativeEventEmitter = new NativeEventEmitter(EventManager)
// nativeEventEmitter is the EventEmitter which receives events
// triggered by our EventManager swift implementation (using sendEvent())

// Note: on the swift side EventManager is a subclass of
// RCTEventEmitter (which can send events to NativeEventEmittere here)
// so in swift the two concepts are merged by inheritance


const emit = EventManager.emit.bind(EventManager)

const addListener = (event, ...args) => {
  EventManager.supportedEventsAdd(event)
  return nativeEventEmitter.addListener(event, ...args)
}

const once = (event, callback, context) => {
  const subscription = nativeEventEmitter.addListener(
    event,
    (data) => {
      subscription.remove()
      callback(data)
    },
    context
  )
  return subscription
}


export default { emit, addListener, once }


const usage = () => {
  addListener('testevent', (data) => {
    console.log('testevent correctly triggered with', data)
  })
  emit('testevent', { some: 'data' })
}