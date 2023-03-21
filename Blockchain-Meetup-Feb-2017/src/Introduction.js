import React from 'react';
import {
  Appear,
  Heading,
  ListItem,
  Slide,
  UnorderedList,
} from 'spectacle';
import renderSlideSet from './renderSlideSet';

const introSlides = {
  'title': '',
  'bio': `
    <ul>
      <li>Who am I?</li>
      <li>Why am I here?</li>
    </ul>
  `,
  'purpose': `
    <ul>
      <li>What is the goal?</li>
    </ul>
  `,
  'methods': `
    <ul>
      <li>How do we achieve that goal?</li>
    </ul>
  `,
};

const renderSlide = (slide, notes) => {
  switch (slide) {
    case 'title':
      return (
        <Slide key={slide} notes={notes} transition={["slide"]}>
          <Heading>Introduction</Heading>
        </Slide>
      );

    case 'bio':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading textColor="tertiary">Introduction</Heading>
          <Heading size={6}>Bio</Heading>
          <UnorderedList>
            <Appear><ListItem>Hi! I'm Marcus.</ListItem></Appear>
            <Appear><ListItem>I make games for a living, but freelance full stack development.</ListItem></Appear>
            <Appear><ListItem>I became interested in bulding Ethereum apps in Spring 2016.</ListItem></Appear>
            <Appear><ListItem>I volunteered as a Ethereum Classic core developer after the DAO Fork.</ListItem></Appear>
          </UnorderedList>
        </Slide>
      );

    case 'purpose':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading textColor="tertiary">Introduction</Heading>
          <Heading size={6}>Purpose</Heading>
          <UnorderedList>
            <Appear><ListItem>Rapid prototyping of Ethereum applications, aka "dApps".</ListItem></Appear>
            <Appear><ListItem>Smart Contract code can be easily developed and tested.</ListItem></Appear>
            <Appear><ListItem>Easy method of building frontend code that utilizes Smart Contracts.</ListItem></Appear>
            <Appear><ListItem>Simple deployment to Testnet and production Ethereum blockchains.</ListItem></Appear>
          </UnorderedList>
        </Slide>
      );

    case 'methods':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading textColor="tertiary">Introduction</Heading>
          <Heading size={6}>Methods</Heading>
          <UnorderedList>
            <Appear><ListItem>Docker to "not care" about low-level setup and configuration.</ListItem></Appear>
            <Appear><ListItem>Parity for a fast, flexible development blockchain.</ListItem></Appear>
            <Appear><ListItem>Truffle for Solidity-based Smart Contract development, testing, and deployment.</ListItem></Appear>
            <Appear><ListItem>Create React App, Web3, and Ethereum JS tools and libraries to build the frontend and interact with the blockchain.</ListItem></Appear>
          </UnorderedList>
        </Slide>
      );

    default:
      return null;
  }
}

export default renderSlideSet(introSlides, renderSlide);
