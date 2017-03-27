
import React from 'react'
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableWithoutFeedback,
  Animated
} from 'react-native'


class FadeIn extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      value: new Animated.Value(0)
    }
  }

  render() {
    return (
      <Animated.View
        style={{
          position: 'absolute',
          top: 0, left: 0, bottom: 0, right: 0,
          opacity: this.state.value
        }}
      >
        {this.props.children}
      </Animated.View>
    )
  }

  animate() {
    let from = 0, to = 1
    if (this.props.reverse) { from = 1, to = 0 }

    this.state.value.setValue(from)
    Animated.spring(
      this.state.value,
      {
        toValue: to,
        friction: 10,
      }
    ).start(this.props.onAnimationEnd);
  }

  componentDidMount() {
    this.animate()
  }

  componentDidUpdate(prevProps, prevState) {
    this.animate()
  }

}

export default FadeIn