import * as d3 from 'd3';

import { isWord, ruler } from '../utils.js';

import { settings } from '../settings.js';

import type {
  DrawUnit,
  GrammarNode,
  StatusType,
} from '../simpleGrammarTypes.js';
import { getColorByStatus, getHebrew } from './utils.js';

export function drawSubordinateConjunction(
  conjunctionNode: GrammarNode,
  drawUnit: DrawUnit,
  status?: StatusType,
): DrawUnit {
  const d3Elem = d3.create('svg:g');

  if (!conjunctionNode.content || !isWord(conjunctionNode.content)) {
    throw new Error('SubordinateConjunctionDrawer Only draw Word');
  }

  d3Elem.append(() => drawUnit.element.node());

  const rect1 = ruler(
    getHebrew({ status, hebrew: conjunctionNode.content.word }),
  );
  const rect2 = ruler(conjunctionNode.content.gloss);

  const width =
    drawUnit.width + 4 * settings.wordPadding + rect1.width + rect2.width;
  const height = drawUnit.height;

  const startX = drawUnit.width;
  const startY = drawUnit.verticalCenter;

  const data: [number, number][] = [
    [startX, startY],
    [startX + 2 * settings.wordPadding + rect1.width, startY],
    [startX + 2 * settings.wordPadding + rect1.width, 0],
  ];

  const lineGenerator = d3
    .line()
    .x((d) => d[0])
    .y((d) => d[1]);

  d3Elem
    .append('path')
    .attr('d', lineGenerator(data))
    .attr('fill', 'none')
    .attr('stroke-dasharray', '3,3')
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
    .append('text')
    .attr('x', 0)
    .attr('y', 0)
    .attr(
      'stroke',
      getColorByStatus({
        status,
        defaultColor: settings.wordStrokeColor,
        type: 'hebrew',
      }),
    )
    .attr(
      'fill',
      getColorByStatus({
        status,
        defaultColor: settings.wordColor,
        type: 'hebrew',
      }),
    )
    .attr(
      'transform',
      `translate(${width - rect2.width - rect1.width - 3 * settings.wordPadding}, ${
        startY - settings.padding
      })`,
    )
    .text(getHebrew({ status, hebrew: conjunctionNode.content.word }));

  d3Elem
    .append('text')
    .attr('x', 0)
    .attr('y', 0)
    .attr(
      'stroke',
      getColorByStatus({
        status,
        defaultColor: settings.glossColor,
        type: 'gloss',
      }),
    )
    .attr(
      'fill',
      getColorByStatus({
        status,
        defaultColor: settings.glossColor,
        type: 'gloss',
      }),
    )
    .attr(
      'transform',
      `translate(${width - rect2.width}, ${startY - settings.padding})`,
    )
    .text(conjunctionNode.content.gloss);

  return {
    width,
    height,
    element: d3Elem,
    verticalStart: 0,
    verticalCenter: height / 2,
    verticalEnd: height,
    horizontalStart: 0,
    horizontalCenter: startX + 2 * settings.wordPadding + rect1.width,
    horizontalEnd: height,
  };
}
