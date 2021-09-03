export type Maybe<T> = T | null;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
};

export type Board = {
  __typename?: 'Board';
  id: Scalars['ID'];
  name: Scalars['String'];
  issues: Array<Issue>;
  states: Array<State>;
};

export type BoardInput = {
  id: Scalars['ID'];
  name: Maybe<Scalars['String']>;
};

export type Issue = {
  __typename?: 'Issue';
  id: Scalars['ID'];
  title: Scalars['String'];
  description: Scalars['String'];
  state: State;
};

export type Mutation = {
  __typename?: 'Mutation';
  createBoard: Board;
  updateBoard: Board;
  deleteBoard: Maybe<Scalars['String']>;
};


export type MutationCreateBoardArgs = {
  name: Scalars['String'];
};


export type MutationUpdateBoardArgs = {
  board: BoardInput;
};


export type MutationDeleteBoardArgs = {
  id: Scalars['ID'];
};

export type Query = {
  __typename?: 'Query';
  me: Maybe<User>;
  boards: Maybe<Array<Board>>;
};

export type State = {
  __typename?: 'State';
  id: Scalars['ID'];
  name: Scalars['String'];
};

export type User = {
  __typename?: 'User';
  id: Scalars['ID'];
  userName: Scalars['String'];
  firstName: Scalars['String'];
  lastName: Scalars['String'];
};
