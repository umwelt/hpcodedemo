
import React from 'react'
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableWithoutFeedback,
  Animated
} from 'react-native'


class SlideInFromTop extends React.Component {

  constructor(props) {
    super(props)
    this.state = {
      value: new Animated.Value(0)
    }
  }

  render() {
    return (
      <Animated.View
        pointerEvents="box-none"
        style={{
          flex: 1,
          transform: [
            { translateY: this.state.value }
          ]
        }}
      >
        {this.props.children}
      </Animated.View>
    )
  }

  animate() {
    let from = -400, to = 0
    if (this.props.reverse) { from = 0, to = -400 }

    this.state.value.setValue(from)
    Animated.spring(
      this.state.value,
      {
        toValue: to,
        tension: 20,
        restDisplacementThreshold: 2,
        restSpeedThreshold: 2,
        friction: 5,
      }
    ).start(this.props.onAnimationEnd);
  }

  componentDidMount() {
    this.animate()
  }

  componentDidUpdate() {
    this.animate()
  }
}

export default SlideInFromTop