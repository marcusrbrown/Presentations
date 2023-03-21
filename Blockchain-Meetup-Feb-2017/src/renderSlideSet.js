import React from 'react';

export default function renderSlideSet(slideMap, renderer) {
  return () => {
    const slides = Object.keys(slideMap).map((slide) => renderer(slide, slideMap[slide]));

    return (
      <>
        {slides}
      </>
    );
  }
}
