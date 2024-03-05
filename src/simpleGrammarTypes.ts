export type D3Element = any;

export type DrawUnit = {
  width: number;
  height: number;
  element: D3Element;
  verticalStart: number;
  verticalCenter: number;
  verticalEnd: number;
  herizontalStart: number;
  herizontalCenter: number;
  herizontalEnd: number;
};

export type Word = {
  pos: string;
  word: string;
  gloss: string;
  description: string;
};

export type Fragment = {
  fragment: string;
  description: string;
};

export type GrammarNode = {
  level: number;
  parent?: GrammarNode;
  children: (GrammarNode | GraphicalNode)[];
  content: Word | Fragment | null;
};

export type GraphicalNode = GrammarNode & {
  drawUnit: DrawUnit;
};
