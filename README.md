<h1 align="center">
    <img src="./Screenshots/hero.png" alt="PocasIdeia">
</h1>

<p align="center">
  <i align="center">Your personal space to <b>vent frustrations</b> safely</i>
</p>

<p align="center">
  <a href="https://apps.apple.com/us/app/pocasideia/id6753698657">
    <img src="https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg" alt="Download on the App Store" height="50">
  </a>
</p>

<p align="center">
  <a href="https://apps.apple.com/us/app/pocasideia/id6753698657">
    <img src="https://img.shields.io/itunes/v/6753698657?label=App%20Store&logo=apple" alt="App Store Version">
  </a>
  <img src="https://img.shields.io/badge/Language-Swift-orange" alt="Swift">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
  <img src="https://img.shields.io/github/stars/tagocms/PocasIdeia" alt="GitHub Stars">
</p>

## Introduction

PocasIdeia is an **iOS app** built with UIKit and SwiftData, created as a Nano Challenge at the Apple Developer Academy.

**Log your frustrations** — give each one a title, rate your irritation level on a slider, write a summary, attach up to 3 photos, and organize entries by custom tags. Everything stays on-device and private.

## Screenshots

<details open>
<summary>Screenshots</summary>
<br />

<p align="center">
    <img width="30%" src="./Screenshots/ss_1.png" alt="Main list showing logged frustrations with irritation indicators"/>
&nbsp;
    <img width="30%" src="./Screenshots/ss_2.png" alt="Detail view of a frustration entry with summary and attached photos"/>
&nbsp;
    <img width="30%" src="./Screenshots/ss_3.png" alt="New entry form with irritation level slider and tag selection"/>
</p>
<p align="center">
    <img width="30%" src="./Screenshots/ss_4.png" alt="Tag filtering and search bar on the main list"/>
&nbsp;
    <img width="30%" src="./Screenshots/ss_5.png" alt="Sort options menu for ordering entries by title, irritation, or date"/>
&nbsp;
    <img width="30%" src="./Screenshots/ss_6.png" alt="Empty state screen prompting the user to log their first frustration"/>
</p>

</details>

## Development

- **Architecture & Patterns**: MVC with fully programmatic UIKit — no storyboards or XIBs. Views are composed in dedicated `UIView` subclasses and wired to controllers manually.
- **Frameworks**: SwiftData for local persistence with tag relationships; PhotosUI for multi-image selection (up to 3 per entry); `UINotificationFeedbackGenerator` for haptic feedback on interactions.
- **Data model**: Each entry stores a title, integer irritation level, free-text summary, raw image data, and a many-to-many tag relationship — all queried with SwiftData predicates for live search and tag filtering.

## Resources & Credits

- **Anton** (Google Fonts): Display typeface used for titles and irritation level indicators.
- **SF Symbols**: System icons for sort, filter, trash, and navigation controls.

## License

PocasIdeia is available under the [MIT License](./LICENSE).

The app is published on the [App Store](https://apps.apple.com/us/app/pocasideia/id6753698657).
