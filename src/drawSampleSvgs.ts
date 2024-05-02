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
import { drawAdverbialDecorator } from './svgDrawer/drawAdverbialDecorator';

import { drawPreposition } from './svgDrawer/drawPreposition';
import { drawVerbparticipleDecorator } from './svgDrawer/drawVerbparticipleDecorator';

import { D3Element } from './simpleGrammarTypes';
import { drawEmpty } from './svgDrawer/drawEmpty';
import { drawVerbInifinitiveDecorator } from './svgDrawer/drawVerbInifinitiveDecorator';

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
    drawPreposition(sampleWord, { initialHeight: 200 }),
    drawAdjectivalClauseDecorator(drawWord(sampleWord)),
    drawAdjectivalDecorator({}),
    drawAdverbialDecorator({}),
    drawClauseDecorator({}),
    drawComplementDecorator(),
    drawEmpty(),
    drawEmptyLine({}),
    drawEmptyWord(),
    drawEqualDecorator(),
    drawModifier(sampleWord),

    drawVerbInifinitiveDecorator(),
    drawVerbparticipleDecorator(),
    drawVerticalLine(),
    drawWhitespaceDecorator(),
    drawWord(sampleWord),
  ];

  for (const element of elements) {
    appendD3Element(container, element.element);
  }
}
