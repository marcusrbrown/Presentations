import React, { Component } from 'react';
import {
  Deck,
  Heading,
  Image,
  Link,
  Slide,
  Text
} from 'spectacle';
import createTheme from 'spectacle/lib/themes/default';
import introduction from './Introduction';
import overview from './Overview';
import demo from './Demo';
import './App.css';

const theme = createTheme({
  primary: "white",
  secondary: "#1F2022",
  tertiary: "#03A9FC",
  quartenary: "#CECECE"
}, {
  primary: "Montserrat",
  secondary: "Helvetica"
});

class App extends Component {
  render() {
    return (
      <Deck transition={["fade"]} transitionDuration={500} theme={theme}>
        <Slide transition={["zoom"]} bgColor="primary">
          <Heading size={3} caps textColor="tertiary">
            Hands On Ethereum Smart Contract Development
          </Heading>
          <Image src="https://themerkle.com/wp-content/uploads/2016/03/ethereum-visual-studio-featured.jpg" height="300px" />
          <Text margin="10px 0 0" textColor="secondary" size={1} fit bold>
            Blockchain Meetup - February 21st, 2017
          </Text>
          <Link href="https://igg.ms/bm-feb-2017">https://igg.ms/bm-feb-2017</Link>
        </Slide>
        {introduction()}
        {overview()}
        {demo()}
      </Deck>
    );
  }
}

export default App;
