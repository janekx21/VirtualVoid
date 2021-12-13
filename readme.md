# Virtual Void

A super simple issue management software. The main focus
is on super simple but qualitative and fast design.

## Entities

- Project
- Backlog
- Issue
- Epic
- State

## Features

### Project

- [x] show all Projects
- [x] show a Project by id
- [x] add Project
- [x] remove Project
- [x] change Project name

### Backlog

- [x] show all Backlogs
- [x] show a Backlog by id
- [x] add Backlog
- [x] remove Backlog
- [ ] change Backlog name

### Issue

- [x] show all Issues
- [x] show an Issue
- [x] add Issue
- [x] remove Issue
- [x] change Issue

### Epic

- [x] show all Epics
- [ ] add Epic
- [ ] remove Epic
- [ ] change Epic name

### State

- [x] show all States
- [ ] add State
- [ ] remove State
- [ ] change State name

## Routing

### `/`
dash

### `/projects`
all projects

### `/projects/{project}`
a project

### `/projects/{project}/backlogs`
all backlogs of a project

### `/projects/{project}/issues`
all issues of a project

### `/issues/{issue}`
an issue

### `/boards/{board}`
a board
