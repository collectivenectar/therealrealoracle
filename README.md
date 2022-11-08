# therealrealoracle
Digital Oracle Deck App, designed using Godot Engine

This is a prototype for a responsive web application or cross platform mobile app for managing digital card decks.

Here are a quick demo of one of the features so far:

Live Demo of displaying the drawn cards


<img src="https://github.com/collectivenectar/therealrealoracle/blob/main/Prototype-demo.gif" width="100">


There are a few main features of the app that are currently finished in the Godot branch version:

- View the digital card deck in an image carousel.
- Draw cards from the deck using different presets, also known as 'spreads'
- Save and review history, i.e. of past spreads.
- Keep notes on both the card deck and on the individual records of spreads.

And a few features not yet implemented but planned:

- Deck 'Cores' i.e. Unique user-generated Random Number Generating Seeds and seed management tool
- Fully functional card deck Journal - Combining spread history, deck specific notes and guidebooks, and RNG seeds into one UI.
- Custom Spread/Layout Tool - Design your own card table layouts for cards, and name and describe each position in the spread if desired.


I'm currently working on a React Native Version after running into some limitations with the UI related to text formatting, as the
deck is mainly text-based, and it's just too much of a time sink building custom components in Godot with so many scroll container issues.
