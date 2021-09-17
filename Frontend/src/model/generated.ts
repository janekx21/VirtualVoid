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

export type BackLog = {
  __typename?: 'BackLog';
  id: Scalars['ID'];
  name: Scalars['String'];
  issues: Array<Issue>;
};

export type Board = {
  __typename?: 'Board';
  id: Scalars['ID'];
  backlog: BackLog;
  states: Array<State>;
};

export type BoardInput = {
  name: Maybe<Scalars['String']>;
};

export type Epic = {
  __typename?: 'Epic';
  id: Scalars['ID'];
  name: Scalars['String'];
  shortName: Scalars['String'];
  description: Scalars['String'];
};

export enum Importance {
  Low = 'LOW',
  Medium = 'MEDIUM',
  High = 'HIGH'
}

export type Issue = {
  __typename?: 'Issue';
  id: Scalars['ID'];
  title: Scalars['String'];
  description: Scalars['String'];
  number: Scalars['Int'];
  points: Maybe<Scalars['Int']>;
  flagged: Scalars['Boolean'];
  importance: Importance;
  type: IssueType;
  state: Maybe<State>;
  epic: Maybe<Epic>;
  creator: Maybe<User>;
  worker: Maybe<User>;
};

export enum IssueType {
  Story = 'STORY',
  Improvement = 'IMPROVEMENT',
  Task = 'TASK',
  Bug = 'BUG',
  Dept = 'DEPT'
}

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
  id: Scalars['ID'];
  board: BoardInput;
};


export type MutationDeleteBoardArgs = {
  id: Scalars['ID'];
};

export type Project = {
  __typename?: 'Project';
  id: Scalars['ID'];
  name: Scalars['String'];
  shortName: Scalars['String'];
  backlogs: Array<BackLog>;
  boards: Array<Board>;
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

export type Subscription = {
  __typename?: 'Subscription';
  time: Maybe<Scalars['String']>;
};

export type User = {
  __typename?: 'User';
  id: Scalars['ID'];
  userName: Scalars['String'];
  firstName: Scalars['String'];
  lastName: Scalars['String'];
};
