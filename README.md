
[Wishlist - Latest Version](https://raw.githubusercontent.com/rslifka/wishlist/master/wishlist.txt)

[Roll Commentary - Latest Version](https://rslifka.github.io/wishlist/)

# Welcome
*"Did I strike Silver or Gold? Should I shard or keep this?"*

This is what I'm hoping to do with my wishlist. It's not trying to tell you every possible perk that might happen to be good, it's trying to tell you when a set of related perks came together to make an interesting roll. `Surplus` is a terrific perk, but this wishlist won't tell you to keep a roll just because of it.

*"A hip-fire slug shotgun? Why would this be highlighted?"*

A secondary objective is indicate which rolls, even if they aren't "the meta", would be interesting to use in both PvE and PvP. I'll strive to include as much color in the notes of each weapon as I can

As the wishlist is updated, so are the thoughts that go in to each set of rolls, which you can find a link to above.

*"This wishlist sure does value Stability..."*

Indeed! ***This is a console-centric wishlist.*** If you're on PC, generally you have a Range preference over Stability. Keep that in mind when you see something with a suggested Stability-related perk or a Stability Masterwork.

# Who Made This?
A few of us over on the Disco Technical Destiny Slack. We've all been playing for some time and have been influenced by many of the folks below. Every roll of every weapon was influenced in some way by their work.

1. **Directly**: They reviewed a weapon and shared specific insights as to why and how a particular roll could be effective.
2. **Indirectly**: They published content about how the sandbox itself functions (e.g. how perks work, how mods work, ...).

I quote and link to sources per-weapon in the roll guide. Go check out these Destiny scientists and the content they produce. Really amazing stuff.

| Creator       | Twitter | YouTube | Twitch
|---------------|-|-|-|
| CammyCakes    | [Twitter](https://twitter.com/CammyCakesYT) | [YouTube](https://www.youtube.com/user/cammycakesgaming) | [Twitch](https://www.twitch.tv/cammycakes)
| CoolGuy       | [Twitter](https://twitter.com/IAmCoolGuyYT) | [YouTube](https://www.youtube.com/channel/UCAOitB3h99Ur9RzR5ftd2bA) | [Twitch](https://www.twitch.tv/I_Am_CoolGuy)
| Drewsky       | [Twitter](https://twitter.com/drewskyschannel) | [YouTube](https://www.youtube.com/user/DrewskysChannel) | [Twitch](https://www.twitch.tv/drewskys)
| Fallout Plays | [Twitter](https://twitter.com/falloutplays) | [YouTube](https://www.youtube.com/channel/UCMlqYSFcNTrxDQO_T9GCsjg) | [Twitch](www.twitch.tv/falloutplays)
| Kyt_Kutcha    | [Twitter](https://twitter.com/kyt_kutcha) | - | [Twitch](https://www.twitch.tv/kyt_kutcha/)
| Mercules904   | [Twitter](https://twitter.com/mercules904) | - | -

# Reference

We have a [bit of a wiki going](https://github.com/rslifka/wishlist/wiki) for the type of information we find helpful when coming up with rolls.

# Contributing

If you want to add some of your own rolls, you'll want to first create a fork of this repo and clone it to your local machine.

The files in the `wishlist_dsl` directory are used to generate  `wishlist.txt` and `docs/index.md`.  If you create or edit edit `.yml` files you'll then need to run a `bundle exec rake` to generate new versions of those files, or alternatively run `guard`.

You can set up "Github Actions" to automatically recompile these files on every push using the `.github/workflows/ruby.yml` file.

If you want to test your changes locally without pushing, you'll need to set up `rake` locally.

### Setting up `rake` and `ruby` locally

The wishlist uses `rake` tasks (via `ruby`) to do most of the heavy lifing.  You'll want to [install `rvm` (Ruby Version Manager)](https://rvm.io/).  Then, if you `cd` into your local repo it should prompt you to install the right version of `ruby`.

Then you can install all of the required dependencies (taken from the "Build and test with Rake" action in `ruby.yml`):

```
gem install bundler
bundle install --jobs 4 --retry 3
```

Now, every time you make a `.yml` change, you can test and recompile the changes locally with:

```
bundle exec rake
```

