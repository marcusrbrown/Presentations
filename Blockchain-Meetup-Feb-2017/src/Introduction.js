import React from 'react';
import {
  Heading,
  Slide
} from '@igetgames/spectacle';
import renderSlideSet from './renderSlideSet';

const introSlides = {
  'title': `
    <ul>
      <li>Who am I?</li>
      <li>Why am I here?</li>
      <li>What is the goal?</li>
      <li>How do we achieve that goal?</li>
    </ul>
  `
};

const renderSlide = (slide, notes) => {
  switch (slide) {
    case 'title':
      return (
        <Slide key={slide} notes={notes}>
          <Heading>Introduction</Heading>
        </Slide>
      );

    default:
      return null;
  }
}

export default renderSlideSet(introSlides, renderSlide);
