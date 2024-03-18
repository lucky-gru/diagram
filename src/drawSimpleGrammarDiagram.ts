import * as d3 from 'd3';

import db from './db.json';
import { shakingTree } from './syntacticParser/shakingTree';
import { parse } from './syntacticParser/parse';
import { settings } from './settings';

import type { GrammarNode } from './simpleGrammarTypes';

export function drawSimpleGrammarDiagram(container: HTMLElement) {
  const rootNode: GrammarNode = db;

  const graphicalRootNode = parse(
    shakingTree(JSON.parse(JSON.stringify(rootNode))),
  );

  const svg = d3
    .select(container)
    .append('svg')
    .attr(
      'width',
      Math.max(graphicalRootNode.drawUnit.width, settings.minWidth),
    )
    .attr('height', graphicalRootNode.drawUnit.height)
    .attr(
      'viewBox',
      `0 0 ${graphicalRootNode.drawUnit.width} ${graphicalRootNode.drawUnit.height}`,
    )
    .append('g');

  svg.append(() => graphicalRootNode.drawUnit.element.node());
}
