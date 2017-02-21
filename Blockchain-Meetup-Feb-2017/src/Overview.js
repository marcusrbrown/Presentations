import React from 'react';
import {
  Heading,
  Slide
} from '@igetgames/spectacle';
import renderSlideSet from './renderSlideSet';

const overviewSlides = {
  'title': ''
};

const renderSlide = (slide, notes) => {
  switch (slide) {
    case 'title':
      return (
        <Slide key={slide} notes={notes}>
          <Heading>Overview</Heading>
        </Slide>
      );

    default:
      return null;
  }
}
export default renderSlideSet(overviewSlides, renderSlide);
