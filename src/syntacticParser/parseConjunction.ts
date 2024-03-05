import { isFragment } from '../utils.js';
import { GrammarError } from '../error.js';
import type { GrammarNode, GraphicalNode } from '../simpleGrammarTypes.js';

import { conjunctionFragmentKey, conjunctionKey } from './keys.js';

import { getChildMap } from './utils.js';

export function parseConjunction(node: GrammarNode): GraphicalNode {
  const validKeys: string[] = [conjunctionFragmentKey, conjunctionKey];

  if (
    !node.content ||
    !isFragment(node.content) ||
    node.content.fragment !== 'Conjunction'
  ) {
    throw new Error('Conjunction parser requires Conjunction Node');
  }

  const childMap = getChildMap(node.children, validKeys);

  const keysLen = Object.keys(childMap).length;

  if (keysLen === 1) {
    if (childMap[conjunctionKey]) {
      return {
        ...node,
        drawUnit: (childMap[conjunctionKey] as GraphicalNode).drawUnit,
      };
    }

    if (childMap[conjunctionFragmentKey]) {
      return {
        ...node,
        drawUnit: (childMap[conjunctionFragmentKey] as GraphicalNode).drawUnit,
      };
    }
  }

  throw new GrammarError(
    'InvalidStructure',
    'Conjunction has unexpected structure',
  );
}
