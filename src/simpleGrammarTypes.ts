export type D3Element = any;

export type DrawUnit = {
  width: number;
  height: number;
  element: D3Element;
  verticalStart: number;
  verticalCenter: number;
  verticalEnd: number;
  horizontalStart: number;
  horizontalCenter: number;
  horizontalEnd: number;
};

export type Word = {
  pos: string;
  word: string;
  gloss: string;
  description: string;
  arguments: string;
  message?: string;
};

export type Fragment = {
  fragment: string;
  description: string;
  arguments: string;
  message?: string;
};

export type StatusType =
  | 'elided'
  | 'revocalization'
  | 'emendation'
  | 'alternative';

export type GrammarNode = {
  level: number;
  parent?: GrammarNode;
  children: (GrammarNode | GraphicalNode)[];
  content: Word | Fragment | null;
  status?: StatusType;
};

export type GraphicalNode = GrammarNode & {
  drawUnit: DrawUnit;
};
