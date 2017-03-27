import React from 'react'
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableWithoutFeedback,
  Animated
} from 'react-native'


const ModalBackground = (props) =>
  <TouchableWithoutFeedback
    onPress={props.onPress}
  >
    <View
      style={{
        backgroundColor: 'black',
        opacity: 0.9,
        position: 'absolute',
        top: 0, left: 0, right: 0, bottom: 0
      }}
      {...props}
    >
      {props.children}
    </View>
  </TouchableWithoutFeedback>

export default ModalBackground