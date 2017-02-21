import React, { Component } from 'react';
import {
  Deck,
  Heading,
  Image,
  Slide,
  Text
} from '@igetgames/spectacle';
import createTheme from '@igetgames/spectacle/lib/themes/default';
import introduction from './Introduction';
import overview from './Overview';
import '@igetgames/spectacle/lib/themes/default/index.css';
import logo from './logo.svg';
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
          <Heading size={1} fit caps lineHeight={1} textColor="secondary">
            Hands On Ethereum Smart Contract Development
          </Heading>
          <Image src={logo} className="App-logo" height="160px" />
          <Text margin="10px 0 0" textColor="tertiary" size={1} fit bold>
            Blockchain Meetup - February 21st, 2017
          </Text>
        </Slide>
        {introduction()}
        {overview()}
      </Deck>
    );
  }
}

export default App;
