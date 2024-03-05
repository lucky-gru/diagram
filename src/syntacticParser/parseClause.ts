import { isFragment } from '../utils.js';
import { GrammarError } from '../error.js';
import type { GrammarNode, GraphicalNode } from '../simpleGrammarTypes.js';

import { subjectKey, predicateKey, vocativeKey, subordinateClauseKey } from './keys.js';

import { getChildMap } from './utils.js';

import { herizontalMerge, verticalMerge } from '../svgDrawer/utils.js';
import { drawClauseDecorator } from '../svgDrawer/drawClauseDecorator.js';
import { drawWhitespaceDecorator } from '../svgDrawer/drawWhitespaceDecorator.js';

export function parseClause(node: GrammarNode): GraphicalNode {
  const validKeys: string[] = [subjectKey, predicateKey, vocativeKey, subordinateClauseKey];

  if (!node.content || !isFragment(node.content) || node.content.fragment !== 'Clause') {
    throw new GrammarError('InvalidParser', 'Clause parser requires Clause Node');
  }

  if (node.children.length === 0) {
    throw new GrammarError('InvalidStructure', 'Clause has no children');
  }

  const childMap = getChildMap(node.children, validKeys);

  const keysLen = Object.keys(childMap).length;

  if (keysLen === 1 && childMap[predicateKey]) {
    const drawUnit = (childMap[predicateKey] as GraphicalNode).drawUnit;
    return {
      ...node,
      drawUnit: herizontalMerge([drawUnit, drawClauseDecorator()], {
        align: 'center',
        verticalCenter: drawUnit.height,
        verticalEnd: drawUnit.height,
      }),
    };
  }

  if (keysLen === 2) {
    if (childMap[subjectKey] && childMap[predicateKey]) {
      const subjectUnit = (childMap[subjectKey] as GraphicalNode).drawUnit;
      const decorator = drawClauseDecorator();
      const predicateUnit = (childMap[predicateKey] as GraphicalNode).drawUnit;

      return {
        ...node,
        drawUnit: herizontalMerge([predicateUnit, decorator, subjectUnit], {
          align: ['center', 'center', 'center'],
          verticalCenter: Math.max(subjectUnit.verticalCenter, predicateUnit.verticalCenter),
          verticalEnd: Math.max(subjectUnit.verticalCenter, predicateUnit.verticalCenter),
        }),
      };
    }

    if (childMap[vocativeKey] && childMap[predicateKey]) {
      return {
        ...node,
        drawUnit: herizontalMerge(
          [
            (childMap[predicateKey] as GraphicalNode).drawUnit,
            drawClauseDecorator(),
            drawWhitespaceDecorator(),
            (childMap[vocativeKey] as GraphicalNode).drawUnit,
          ],
          { align: ['end', 'center', 'center', 'end'] }
        ),
      };
    }

    if (childMap[predicateKey] && childMap[subordinateClauseKey]) {
      return {
        ...node,
        drawUnit: herizontalMerge(
          [
            (childMap[predicateKey] as GraphicalNode).drawUnit,
            verticalMerge(
              [drawClauseDecorator(), (childMap[subordinateClauseKey] as GraphicalNode).drawUnit],
              { align: 'end' }
            ),
          ],
          { align: ['start', 'center'] }
        ),
      };
    }
  }

  throw new GrammarError('InvalidStructure', 'Nominal has unexpected structure');
}