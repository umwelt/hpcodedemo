
import React from 'react'
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableWithoutFeedback,
  Animated
} from 'react-native'

const ModalCard = (props) =>
  <TouchableWithoutFeedback
    onPress={props.onPress}
  >
    <View
      style={{
        backgroundColor: '#f1f1f1',
        position: 'absolute',
        borderRadius: 10,
        alignSelf: 'center',
        top: 100,
        paddingTop: 10,
        paddingBottom: 20,
        width: '85%',
      }}
      {...props}
    >
      {props.children}
    </View>
  </TouchableWithoutFeedback>

export default ModalCard