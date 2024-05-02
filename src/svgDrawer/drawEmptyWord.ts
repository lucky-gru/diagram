import { drawWord } from './drawWord.js';

import type {
  DrawUnit,
  GrammarNode,
  StatusType,
} from '../simpleGrammarTypes.js';

const emptyWord: GrammarNode = {
  level: 0,
  children: [],
  content: {
    pos: 'noun',
    word: '( )',
    gloss: '',
    description: '',
    arguments: '',
  },
};

export const drawEmptyWord = (status?: StatusType): DrawUnit => {
  return drawWord(emptyWord, { status });
};
