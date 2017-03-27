
import React from 'react'
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableWithoutFeedback,
  TouchableHighlight,
  Animated,
  Linking
} from 'react-native'

import FadeIn from './animations/FadeIn'
import SlideInFromTop from './animations/SlideInFromTop'
import ModalBackground from './modal/ModalBackground'
import ModalCard from './modal/ModalCard'
import fonts from './fonts'

import EventManager from './EventManager'

const noop = () => { }
const capitalizeFirst = (s) => {
  if (!s) { return "" }
  return `${s[0].toUpperCase()}${s.substr(1)}`
}

const ModalCardTitle = ({ children }) =>
  <Text
    style={[{ margin: 10, textAlign: 'center' }, fonts.modalTitle]}
  >{children}</Text>


const Separator = () =>
  <View
    style={{
      width: '100%',
      marginTop: 5,
      marginBottom: 5,
      height: .5,
      backgroundColor: '#aaa'
    }}
  />


const Offer = ({ providerDisplayName, formattedPrice, onPress = noop }) =>
  <View>
    <Separator />
    <TouchableHighlight underlayColor='#ddd' onPress={onPress}>
      <View
        style={{
          padding: 15,
          flex: 1,
          flexDirection: 'row',
          justifyContent: 'space-between',
          alignItems: 'center'
        }}
      >
        <Text style={[fonts.avenirBook]}>{providerDisplayName || 'providerDisplayName'}</Text>
        <Text style={[fonts.avenirMedium]}>{formattedPrice || 'formattedPrice'}</Text>
      </View>
    </TouchableHighlight>
  </View>


class ProductAvailabilityModal extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      closing: false,
      item: false
    }
  }

  close(e) {
    if (this.state.closing) { return }
    this.setState({ closing: true })
  }

  itemOnPress(item) {
    this.setState({ item: item, closing: true })
  }

  renderOffers() {
    return this.props.items.map(
      (item, index) =>
        <Offer
          key={index}
          {...item}
          onPress={(e) => this.itemOnPress(item)}
        />
    )
  }

  render() {
    return (
      <View style={{ flex: 1 }}>

        <FadeIn
          reverse={this.state.closing}
          onAnimationEnd={this.mayClose.bind(this)}
        >
          <ModalBackground
            onPress={this.close.bind(this)}
          ></ModalBackground>
        </FadeIn>

        <SlideInFromTop
          reverse={this.state.closing}
        >
          <ModalCard>
            <ModalCardTitle>Disponibile online su</ModalCardTitle>
            {this.renderOffers()}
            <Separator />

          </ModalCard>
        </SlideInFromTop>
      </View>
    );
  }

  mayClose() {
    if (!this.state.closing) { return }
    EventManager.emit('ProductAvailabilityModal:close', { item: this.state.item })

    if (this.state.item) {
      Linking.openURL(this.state.item.detailUrl).catch(
        (err) => console.error('An error occurred', err)
      )
    }  
  }
}

AppRegistry.registerComponent(
  'ProductAvailabilityModal',
  () => ProductAvailabilityModal
)
