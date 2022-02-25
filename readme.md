<div id="top"></div>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo.svg" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">Virtual Void</h3>
  <p align="center">
    A super simple issue management software. The main focus
    is on super simple but qualitative and fast design.
    <br />
    <a href="https://github.com/janekx21/VirtualVoid/wiki"><strong>Explore the docs &raquo;</strong></a>
    <br />
    <br />
    <span style="text-decoration: line-through" title="There is currently no demo hosted">View Demo</span>
    &middot;
    <a href="https://github.com/janekx21/VirtualVoid/issues">Report Bug</a>
    &middot;
    <a href="https://github.com/janekx21/VirtualVoid/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<!-- TODO create
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>
-->

## About The Project

![Product Name Screen Shot][product-screenshot]

<!-- TODO write something about the project -->

## Build With

- Backend
    - Kotlin
    - Spring
    - GraphQL
- Frontend
    - Elm
    - elm-ui via `mdgriffith/elm-ui`
    - Material Icons via `icidasset/elm-material-icons`
    - Graphql via `dillonkearns/elm-graphql`

## Getting Started

### Prerequisites

Install elm-live for the live and hot reloading frontend development server.

```shell
npm install -g elm-live
```

### Starting

If you want to start developing.
Start a frontend and backend dev server.

```shell
sh develop.sh
```

This starts an hot reloading elm-live dev server and executes the Gradle Task that starts the
backend dev server.
Look into the scripts to see the separate frontend and backend commands.

## Usage

Follow the standard output text for hosting information like host and port.
The hosted web application contains the app.

### Entities

- Project
- Backlog
- Issue
- Epic
- State

### Features

Tracking features and there state.

#### Project

- [x] show all Projects
- [x] show a Project by id
- [x] add Project
- [x] remove Project
- [x] change Project name

#### Backlog

- [x] show all Backlogs
- [x] show a Backlog by id
- [x] add Backlog
- [x] remove Backlog
- [ ] change Backlog name

#### Issue

- [x] show all Issues
- [x] show an Issue
- [x] add Issue
- [x] remove Issue
- [x] change Issue

#### Epic

- [x] show all Epics
- [ ] add Epic
- [ ] remove Epic
- [ ] change Epic name

#### State

- [x] show all States
- [ ] add State
- [ ] remove State
- [ ] change State name

## Roadmap

1. [ ] Building a vertical slice
2. [ ] Add login and users

## Contributing

## License

## Contact

[contributors-shield]: https://img.shields.io/github/contributors/janekx21/VirtualVoid.svg?style=for-the-badge

[contributors-url]: https://github.com/janekx21/VirtualVoid/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/janekx21/VirtualVoid.svg?style=for-the-badge

[forks-url]: https://github.com/janekx21/VirtualVoid/network/members

[stars-shield]: https://img.shields.io/github/stars/janekx21/VirtualVoid.svg?style=for-the-badge

[stars-url]: https://github.com/janekx21/VirtualVoid/stargazers

[issues-shield]: https://img.shields.io/github/issues/janekx21/VirtualVoid.svg?style=for-the-badge

[issues-url]: https://github.com/janekx21/VirtualVoid/issues

[license-shield]: https://img.shields.io/github/license/janekx21/VirtualVoid.svg?style=for-the-badge

[license-url]: https://github.com/janekx21/VirtualVoid/blob/master/LICENSE.txt

[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555

[linkedin-url]: https://linkedin.com/in/janekx21

[product-screenshot]: images/screenshot.png
