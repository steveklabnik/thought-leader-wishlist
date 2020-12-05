
[Wishlist - Latest Version](https://raw.githubusercontent.com/rslifka/wishlist/master/wishlist.txt)

[Roll Commentary - Latest Version](https://github.com/rslifka/wishlist/blob/master/thought_process.md)

# Welcome!
Did I Strike Gold? Or Lead? This is what I'm hoping to do with my wishlist. It's not trying to tell you every possible perk that might happen to be good, it's trying to tell you when a set of related perks came together to make an interesting roll.

I tend to play a bit off-meta (well, a lot if you ask my fireteam!) so my goal with these lists is to help me decide what rolls of weapons (even if they aren't "the meta") would be interesting to use in both PvE and PvP. I'll strive to include as much color in the notes of each weapon as I can. These are visible when clicking on a suggested roll in DIM. As the wishlist is updated, so are the thoughts that go in to each set of rolls, which you can find a link to above.

**This is a console-centric wishlist.** If you're on PC, generally you have a Range preference over Stability. Keep that in mind when you see something with a suggested Stability-related perk or a Stability Masterwork.

# Who Made This?
I've been playing Destiny since the Alpha with just shy of 3,300 hours played as of February 2019. That's how everyone starts out one of these right? :) Well, I captured the rolls so ultimately I'm responsible for them but all of the creators listed below influenced every single one of these rolls in one or two ways:

1. **Directly**: They reviewed a weapon and shared specific insights as to why and how a particular roll could be effective.
2. **Indirectly**: They published content about how the sandbox itself functions (i.e. how perks work, what the core attributes are)

I quote and link to sources per-weapon in the [Roll Guide](https://github.com/rslifka/wishlist/blob/master/thought_process.md). Go check out these Destiny scientists and the content they produce. Really amazing stuff. Every roll of every weapon was influenced in some way by their work.

| Creator       | Twitter | YouTube | Twitch
|---------------|-|-|-|
| CammyCakes    | [Twitter](https://twitter.com/CammyCakesYT) | [YouTube](https://www.youtube.com/user/cammycakesgaming) | [Twitch](https://www.twitch.tv/cammycakes)
| CoolGuy       | [Twitter](https://twitter.com/IAmCoolGuyYT) | [YouTube](https://www.youtube.com/channel/UCAOitB3h99Ur9RzR5ftd2bA) | [Twitch](https://www.twitch.tv/I_Am_CoolGuy)
| Drewsky       | [Twitter](https://twitter.com/drewskyschannel) | [YouTube](https://www.youtube.com/user/DrewskysChannel) | [Twitch](https://www.twitch.tv/drewskys)
| Fallout Plays | [Twitter](https://twitter.com/falloutplays) | [YouTube](https://www.youtube.com/channel/UCMlqYSFcNTrxDQO_T9GCsjg) | [Twitch](www.twitch.tv/falloutplays)
| Kyt_Kutcha    | [Twitter](https://twitter.com/kyt_kutcha) | - | [Twitch](https://www.twitch.tv/kyt_kutcha/)
| Mercules904   | [Twitter](https://twitter.com/mercules904) | - | -

# Reference

We have a [bit of a wiki going](https://github.com/rslifka/wishlist/wiki) for the type of information we find helpful when coming up with rolls. Have a look!

# Contributing

If you want to add some of your own rolls, you'll want to first create a fork of this repo and clone it to your local machine.

The files in the `wishlist_dsl` directory are used to generate the `wishlist.txt` and `though_process.md` files.  If you create or edit edit `.yml` files you'll then need to run a `bundle exec rake` to generate new versions of those files.

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

