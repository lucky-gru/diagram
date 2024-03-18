import * as d3 from 'd3';

import { sampleWord } from './constants';

import { drawWord } from './svgDrawer/drawWord';
import { drawEmptyWord } from './svgDrawer/drawEmptyWord';
import { drawEmptyLine } from './svgDrawer/drawEmptyLine';
import { drawModifier } from './svgDrawer/drawModifier';
import { drawWhitespaceDecorator } from './svgDrawer/drawWhitespaceDecorator';
import { drawEqualDecorator } from './svgDrawer/drawEqualDecorator';
import { drawClauseDecorator } from './svgDrawer/drawClauseDecorator';
import { drawVerticalLine } from './svgDrawer/drawVerticalLine';
import { drawComplementDecorator } from './svgDrawer/drawComplementDecorator';
import { drawAdjectivalDecorator } from './svgDrawer/drawAdjectivalDecorator';
import { drawAdjectivalClauseDecorator } from './svgDrawer/drawAdjectivalClauseDecorator';

import { verticalMerge, horizontalMerge } from './svgDrawer/utils';
import { drawAdverbialDecorator } from './svgDrawer/drawAdverbialDecorator';
import { drawObjectClauseDecorator } from './svgDrawer/drawObjectClauseDecorator';
import { drawConstructChainConnector } from './svgDrawer/drawConstructChainConnector';
import { drawSubordinateConjunction } from './svgDrawer/drawSubordinateConjunction';
import { drawPreposition } from './svgDrawer/drawPreposition';
import { drawVerbparticipleDecorator } from './svgDrawer/drawVerbparticipleDecorator';

import { D3Element } from './simpleGrammarTypes';

function appendD3Element(container: HTMLElement, element: D3Element) {
  const svg = d3
    .select(container)
    .append('svg')
    .attr('width', 1000)
    .attr('height', 200)
    .attr('viewBox', '0 0 1000 200')
    .append('g')
    .attr('transform', 'translate(' + 10 + ',' + 10 + ')');

  svg.append(() => element.node());
}

export function drawSampleSvgs(container: HTMLElement) {
  const elements = [
    drawVerbparticipleDecorator(),
    drawPreposition(sampleWord, 200),
    horizontalMerge([
      drawEmptyWord(),
      drawEqualDecorator(),
      drawWord(sampleWord),
    ]),
    drawSubordinateConjunction(sampleWord),
    drawConstructChainConnector([
      drawWord(sampleWord),
      drawWord(sampleWord),
      drawWord(sampleWord),
    ]),
    drawObjectClauseDecorator(),
    horizontalMerge([
      verticalMerge([
        horizontalMerge([
          drawWord(sampleWord),
          drawVerticalLine(),
          drawWord(sampleWord),
          drawVerticalLine(),
          drawClauseDecorator(),
        ]),
        drawObjectClauseDecorator(),
      ]),
      drawWord(sampleWord),
    ]),
    drawAdverbialDecorator(),
    drawAdjectivalClauseDecorator(),
    horizontalMerge([
      horizontalMerge([
        drawWord(sampleWord),
        drawVerticalLine(),
        drawWord(sampleWord),
        drawVerticalLine(),
        drawClauseDecorator(),
      ]),
      drawAdjectivalClauseDecorator(),
    ]),
    drawAdjectivalDecorator(),
    horizontalMerge([drawWord(sampleWord), drawAdjectivalDecorator()]),
    horizontalMerge([
      drawWord(sampleWord),
      drawVerticalLine(),
      drawWord(sampleWord),
      drawVerticalLine(),
      drawClauseDecorator(),
    ]),
    drawWord(sampleWord),
    drawEmptyWord(),
    drawEmptyLine(),
    drawModifier(sampleWord),
    drawWhitespaceDecorator(),
    drawEqualDecorator(),
    drawClauseDecorator(),
    drawVerticalLine(),
    drawComplementDecorator(),
    verticalMerge([drawWord(sampleWord), drawModifier(sampleWord)]),
    horizontalMerge([
      drawModifier(sampleWord),
      drawModifier(sampleWord),
      drawModifier(sampleWord),
    ]),
    verticalMerge([
      drawWord(sampleWord),
      horizontalMerge([
        drawModifier(sampleWord),
        drawModifier(sampleWord),
        drawModifier(sampleWord),
      ]),
    ]),
  ];

  for (const element of elements) {
    appendD3Element(container, element.element);
  }
}
