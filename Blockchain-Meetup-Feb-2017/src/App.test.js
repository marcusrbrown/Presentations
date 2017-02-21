import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

it('renders without crashing', () => {
  window.matchMedia = jest.genMockFunction().mockImplementation(function () {
    return {
      matches: true
    };
  });
  const div = document.createElement('div');
  ReactDOM.render(<App />, div);
});
