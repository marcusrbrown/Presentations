import React from 'react';
import {
  Appear,
  Heading,
  Link,
  List,
  ListItem,
  Slide
} from 'spectacle';
import renderSlideSet from './renderSlideSet';

const overviewSlides = {
  'title': '',
  'docker': `
    <ul>
      <li>What is a "containerization platform"?</li>
      <li>Describe benefits of a write-once, run anywhere</li>
      <ul>
        <li>Client runs on Windows, OSX, and many *nixes</li>
        <li>Simplifies deployment to the cloud</li>
      </ul>
    </ul>
  `,
  'parity': `
    <ul>
      <li>Describe PoA vs. PoW</li>
    </ul>
  `,
  'truffle': `
    <ul>
      <li>Could deploy to Classic from the same project.</li>
      <li>Supported on Microsoft Azure</li>
    </ul>
  `,
  'zeppelin': '',
  'create-react-app': '',
  'ethereum-js': `
    <ul>
      <li>Emphasis has been on apps in the broswer, hence why os much JavaScript</li>
      <li>Python, Java, C++, and other language clients are available, but are not as actively developed or featureful as the JavaScript libraries.</li>
    </ul>
  `
};

const renderSlide = (slide, notes) => {
  switch (slide) {
    case 'title':
      return (
        <Slide key={slide} notes={notes} transition={["slide"]}>
          <Heading>Overview</Heading>
        </Slide>
      );

    case 'docker':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading>Overview</Heading>
          <Heading size={6}>Docker</Heading>
          <Link href="https://www.docker.com/">https://www.docker.com/</Link>
          <List>
            <Appear><ListItem>A "containerization platform". What?</ListItem></Appear>
            <Appear><ListItem>Encapsulates one or more programs in a script (Dockerfile).</ListItem></Appear>
            <Appear><ListItem>Supports building images from a Dockerfile that run on any system supported by Docker.</ListItem></Appear>
            <Appear><ListItem>Works great for server apps and command-line utilities (we'll use both).</ListItem></Appear>
          </List>
        </Slide>
      );

    case 'parity':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading>Overview</Heading>
          <Heading size={6}>Parity</Heading>
          <Link href="https://ethcore.io/parity.html">https://ethcore.io/parity.html</Link>
          <List>
            <Appear><ListItem>All-singing, all-dancing Ethereum blockchain client.</ListItem></Appear>
            <Appear><ListItem>Supports Ethereum and derivatives, including Ethereum Classic, Expanse, and custom Ethereum blockchains.</ListItem></Appear>
            <Appear><ListItem>Has browser application for managing wallet, interacting with Ethereum applications, etc.</ListItem></Appear>
            <Appear><ListItem>We'll use Proof-of-Authority (PoA) as an alternative to Proof-of-Work (PoW).</ListItem></Appear>
          </List>
        </Slide>
      );

    case 'truffle':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading>Overview</Heading>
          <Heading size={6}>Truffle</Heading>
          <Link href="http://truffleframework.com/">http://truffleframework.com/</Link>
          <List>
            <Appear><ListItem>Scaffold a Solidity project.</ListItem></Appear>
            <Appear><ListItem>Easily write JavaScript and Solidity tests.</ListItem></Appear>
            <Appear><ListItem>Use a fast blockchain shim for testing (EthereumJS-TestRPC) or a full client (Parity).</ListItem></Appear>
            <Appear><ListItem>Deploy to a local blockchain instance, Testnet, or production Ethereum with a single configuration.</ListItem></Appear>
          </List>
        </Slide>
      );

    case 'zeppelin':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading>Overview</Heading>
          <Heading size={6}>Zeppelin</Heading>
          <Link href="https://openzeppelin.org/">https://openzeppelin.org/</Link>
          <List>
            <Appear><ListItem>Framework of Solidity contracts and libraries.</ListItem></Appear>
            <Appear><ListItem>Audited by Ethereum professionals, uses Solidity best practices.</ListItem></Appear>
            <Appear><ListItem>Drop into a Truffle project, use immediately.</ListItem></Appear>
          </List>
        </Slide>
      );

    case 'create-react-app':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading>Overview</Heading>
          <Heading size={6}>Create React App</Heading>
          <Link href="https://github.com/facebookincubator/create-react-app">https://github.com/facebookincubator/create-react-app</Link>
          <List>
            <Appear><ListItem>Create a full React application with a single command.</ListItem></Appear>
            <Appear><ListItem>Focus on iteration and application functionality, not on boilerplate.</ListItem></Appear>
          </List>
        </Slide>
      );

    case 'ethereum-js':
      return (
        <Slide key={slide} notes={notes} align="center flex-top">
          <Heading>Overview</Heading>
          <Heading size={6}>Web3.js and EthereumJS</Heading>
          <Link href="https://github.com/ethereum/web3.js/">https://github.com/ethereum/web3.js/</Link>
          <br />
          <Link href="https://ethereumjs.github.io/">https://ethereumjs.github.io/</Link>
          <List>
            <Appear><ListItem>Web3 is the de facto JavaScript client for Ethereum blockchain access.</ListItem></Appear>
            <Appear><ListItem>EthereumJS is a suite of libraries for wallet management, testing, building transactions, etc.</ListItem></Appear>
            <Appear><ListItem>Both frameworks cover most Ethereum application requirements (used by majority of "dApps").</ListItem></Appear>
          </List>
        </Slide>
      );

    default:
      return null;
  }
}
export default renderSlideSet(overviewSlides, renderSlide);
