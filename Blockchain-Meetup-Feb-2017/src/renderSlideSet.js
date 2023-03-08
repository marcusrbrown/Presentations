import React from 'react';
import { SlideSet } from 'spectacle';

export default function renderSlideSet(slideMap, renderer) {
  return () => {
    const slides = Object.keys(slideMap).map((slide) => renderer(slide, slideMap[slide]));

    return (
      <SlideSet>
        {slides}
      </SlideSet>
    );
  }
}
