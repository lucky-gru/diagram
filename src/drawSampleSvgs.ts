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
import { drawObjectClauseDecorator } from './svgDrawer/drawObjectClauseDecorator';
import { drawConstructChainConnector } from './svgDrawer/drawConstructChainConnector';
import { drawSubordinateConjunction } from './svgDrawer/drawSubordinateConjunction';
import { drawPreposition } from './svgDrawer/drawPreposition';
import { drawVerbparticipleDecorator } from './svgDrawer/drawVerbparticipleDecorator';

import { D3Element } from './simpleGrammarTypes';
import { drawClauseConjunction } from './svgDrawer/drawClauseConjunction';
import { drawConjunction } from './svgDrawer/drawConjunction';
import { drawEmpty } from './svgDrawer/drawEmpty';
import { drawEmptyConjunction } from './svgDrawer/drawEmptyConjunction';
import { drawCompoundEndDecorator } from './svgDrawer/drawCompoundEndDecorator';
import { drawRelativeParticle } from './svgDrawer/drawRelativeParticle';
import { drawSubjectClauseDecorator } from './svgDrawer/drawSubjectClauseDecorator';
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
    drawAdjectivalClauseDecorator(),
    drawAdjectivalDecorator(),
    drawAdverbialDecorator(),
    drawClauseConjunction(sampleWord, 100),
    drawClauseDecorator(),
    drawComplementDecorator(),
    drawConjunction(sampleWord, 200),
    drawConstructChainConnector([
      drawWord(sampleWord),
      drawWord(sampleWord),
      drawWord(sampleWord),
    ]),
    drawEmpty(),
    drawEmptyConjunction(100),
    drawEmptyLine(),
    drawEmptyWord(),
    drawEqualDecorator(),
    drawModifier(sampleWord),
    drawObjectClauseDecorator(),
    drawCompoundEndDecorator({
      ...sampleWord,
      drawUnit: drawWord(sampleWord),
    }),
    drawPreposition(sampleWord, 200),
    drawRelativeParticle(sampleWord, 200),
    drawSubjectClauseDecorator(200),
    drawSubordinateConjunction(sampleWord),
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
