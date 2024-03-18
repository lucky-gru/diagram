import * as d3 from 'd3';

import { ruler } from '../utils.js';

import { settings } from '../settings.js';

import type { DrawUnit } from '../simpleGrammarTypes.js';

export const drawEqualDecorator = (): DrawUnit => {
  const d3Elem = d3.create('svg:g');

  const word = ' = ';

  const rect = ruler(word);

  const width = rect.width + 2 * settings.padding;
  const height = settings.height / 2;

  d3Elem
    .append('text')
    .attr('x', 0)
    .attr('y', 0)
    .attr('stroke', settings.wordStrokeColor)
    .attr('fill', settings.wordColor)
    .attr('transform', `translate(${(width - rect.width) / 2}, ${height / 2 + rect.height})`)
    .text(word);

  return {
    width,
    height,
    element: d3Elem,
    verticalStart: 0,
    verticalCenter: height / 2,
    verticalEnd: height,
    horizontalStart: 0,
    horizontalCenter: width / 2,
    horizontalEnd: width,
  };
};
