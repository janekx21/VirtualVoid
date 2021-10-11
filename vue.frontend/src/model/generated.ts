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
  /** A type representing a formatted java.util.UUID */
  UUID: any;
  /** The type with only one value: the Unit object. This type corresponds to the void type in Java. */
  Unit: any;
};

export type Backlog = {
  __typename?: 'Backlog';
  id: Scalars['UUID'];
  issues: Array<Issue>;
  project: Project;
  title: Scalars['String'];
};

export type Epic = {
  __typename?: 'Epic';
  id: Scalars['UUID'];
  name: Scalars['String'];
  short: Scalars['String'];
};

export enum Importance {
  High = 'HIGH',
  Low = 'LOW',
  Medium = 'MEDIUM'
}

export type Issue = {
  __typename?: 'Issue';
  backlog: Backlog;
  description: Scalars['String'];
  epic: Maybe<Epic>;
  id: Scalars['UUID'];
  importance: Importance;
  name: Scalars['String'];
  number: Scalars['Int'];
  points: Scalars['Int'];
  state: State;
  type: IssueType;
};

export type IssueCreateInput = {
  backlog: Scalars['UUID'];
  description: Scalars['String'];
  epic: Maybe<Scalars['UUID']>;
  importance: Importance;
  name: Scalars['String'];
  points: Scalars['Int'];
  state: Scalars['UUID'];
  type: IssueType;
};

export enum IssueType {
  Bug = 'BUG',
  Dept = 'DEPT',
  Improvement = 'IMPROVEMENT',
  Task = 'TASK'
}

export type IssueUpdateInput = {
  description: Maybe<Scalars['String']>;
  epic: Maybe<Scalars['UUID']>;
  id: Scalars['UUID'];
  importance: Maybe<Importance>;
  name: Maybe<Scalars['String']>;
  points: Maybe<Scalars['Int']>;
  state: Maybe<Scalars['UUID']>;
};

export type Mutation = {
  __typename?: 'Mutation';
  createBacklog: Scalars['Unit'];
  createIssue: Issue;
  createProject: Scalars['Unit'];
  removeBacklog: Scalars['Unit'];
  removeIssue: Issue;
  removeProject: Scalars['Unit'];
  updateIssue: Issue;
};


export type MutationCreateBacklogArgs = {
  project: Scalars['UUID'];
  title: Scalars['String'];
};


export type MutationCreateIssueArgs = {
  create: IssueCreateInput;
};


export type MutationCreateProjectArgs = {
  name: Scalars['String'];
  short: Scalars['String'];
};


export type MutationRemoveBacklogArgs = {
  id: Scalars['UUID'];
};


export type MutationRemoveIssueArgs = {
  id: Scalars['UUID'];
};


export type MutationRemoveProjectArgs = {
  id: Scalars['UUID'];
};


export type MutationUpdateIssueArgs = {
  update: IssueUpdateInput;
};

export type Project = {
  __typename?: 'Project';
  backlogs: Array<Backlog>;
  id: Scalars['UUID'];
  name: Scalars['String'];
  short: Scalars['String'];
};

export type Query = {
  __typename?: 'Query';
  /** Returns all backlogs */
  backlogs: Array<Backlog>;
  /** Returns all epics */
  epics: Array<Epic>;
  /** Returns all issues */
  issues: Array<Issue>;
  /** Returns all projects */
  projects: Array<Project>;
  /** Returns all states */
  states: Array<State>;
};

export type State = {
  __typename?: 'State';
  id: Scalars['UUID'];
  name: Scalars['String'];
};

export type Subscription = {
  __typename?: 'Subscription';
  /** Returns subscribed issue when it changes */
  changedIssue: Issue;
  /** Returns a random number every second */
  counter: Scalars['Int'];
};


export type SubscriptionChangedIssueArgs = {
  id: Scalars['UUID'];
};


export type SubscriptionCounterArgs = {
  limit: Maybe<Scalars['Int']>;
};


