import React from 'react';
import {
  Heading,
  Slide
} from 'spectacle';
import renderSlideSet from './renderSlideSet';

const demoSlides = {
  'title': ''
};

const renderSlide = (slide, notes) => {
  switch (slide) {
    case 'title':
      return (
        <Slide key={slide} notes={notes} transition={["slide"]}>
          <Heading>Demo</Heading>
        </Slide>
      );

    default:
      return null;
  }
};

export default renderSlideSet(demoSlides, renderSlide);
