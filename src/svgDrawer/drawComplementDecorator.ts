import * as d3 from 'd3';

import { settings } from '../settings.js';

import type { DrawUnit, StatusType } from '../simpleGrammarTypes.js';
import { getColorByStatus } from './utils.js';

export const drawComplementDecorator = (status?: StatusType): DrawUnit => {
  const d3Elem = d3.create('svg:g');

  const width = 3 * settings.padding;
  const height = 2 * settings.padding;

  const slashLineData: [number, number][] = [
    [width / 3, height],
    [(width * 2) / 3, 0],
  ];

  const horizontalLineData: [number, number][] = [
    [0, height],
    [width, height],
  ];

  const lineGenerator = d3
    .line()
    .x((d) => d[0])
    .y((d) => d[1]);

  d3Elem
    .append('path')
    .attr('d', lineGenerator(horizontalLineData))
    .attr('fill', 'none')
    .attr(
      'stroke',
      getColorByStatus({
        status,
        defaultColor: settings.strokeColor,
        type: 'line',
      }),
    )
    .attr('stroke-width', settings.lineStrokeWidth);

  d3Elem
    .append('path')
    .attr('d', lineGenerator(slashLineData))
    .attr('fill', 'none')
    .attr(
      'stroke',
      getColorByStatus({
        status,
        defaultColor: settings.strokeColor,
        type: 'line',
      }),
    )
    .attr('stroke-width', settings.lineStrokeWidth);

  return {
    width,
    height,
    element: d3Elem,
    verticalStart: 0,
    verticalCenter: height,
    verticalEnd: height,
    horizontalStart: settings.padding,
    horizontalCenter: width,
    horizontalEnd: width,
  };
};
