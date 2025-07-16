## ViBBS

The ViBBS – Visualization Building Blocks and Scenarios tool helps you explore and organize different visualization techniques and design patterns. Each card represents a specific approach or method that can be applied to data visualization projects.

Cards courtesy of [Thorsten May](https://www.igd.fraunhofer.de/de/institut/mitarbeitende/thorsten-may.html) from Fraunhofer IGD, [Lena Cibulski](https://lcibulski.github.io/) from the University of Rostock, [Peter Musaeus](https://www.au.dk/en/petermus@au.dk) and [Hans-Jörg Schulz](https://cs.au.dk/~hjschulz/) from Aarhus University. Developed by [Arvind Srinivasan](https://arvindchee.nu/) as a personal project to make these digital.

## Frequently Asked Questions

### How to add a new deck?

To add a new deck, simply add a new JSON object to the decks collection in `deck.json` with the following details:

```jsonc
{
  "decks": [
    {
// Should be the prefix of the image you add to the cards/ folder like deck-id_card-name
      "id": "deck-id",
      "title": "Deck Title", 
// Should be one of: Red, Orange, Amber, Yellow, Lime, Green, Emerald, Teal, Cyan, Sky, Blue, Indigo, Violet, Purple, Fuchsia, Pink, Rose, Slate, Gray, Zinc, Neutral, Stone
      "color": "sky",
      "description": "Description to show in info modal",
// Order should be an integer between 1 and total number of decks (inclusive)
      "order": 1 
    },
    ...
  ]
}
```
### How to add new cards?
If you are working with the same deck, feel free to add an image of your desired aspect ratio into the `cards/` folder with a name like `deck-name_card_name`. 

For example, if you want to add a new chart, lets say, a Bump Chart to the list of visualizations, simply create a card and save it as `visualization_bump-chart.png` in the `cards/` folder and you are good to go!

> Note that it is important to have no free spaces in your filename and use `-` instead of spaces. Ensure that the deck `id` as well as the name of your desired card are all in lowercase.

### How to add a new scenario?

You can add a new scenario in a way similar to the cards, but just add your image to the folder titled `scenarios/`. There is no file-naming convention to be followed here, but lowercase, dash-separated ones are highly recommended.
