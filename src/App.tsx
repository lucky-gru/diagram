import React, { useEffect, useRef } from 'react';

import { drawSampleSvgs } from './drawSampleSvgs';
import { drawSimpleGrammarDiagram } from './drawSimpleGrammarDiagram';

export const App: React.FC = () => {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!ref.current) {
      return;
    }

    const div = ref.current;

    // drawSampleSvgs(div);
    drawSimpleGrammarDiagram(div);

    return () => {
      if (ref.current) {
        ref.current.innerHTML = '';
      }
    };
  }, []);

  return <div ref={ref}></div>;
};
