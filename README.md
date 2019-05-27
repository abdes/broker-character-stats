# Purpose

A LDB data source that can display character stats based on the class and the
current specialization in a LDB display frame. The addon requires a LDB display
addon that is capable of displaying more than one line of text, for example
"Stat Block Core" addon (https://www.curseforge.com/wow/addons/stat-block-core).

The stats are selected based on the class and the current specialization and
sorted out as much as possible following the recommendations on icy veins.

Compared to other addons, this one produces all the stats in one single LDB data
source and not as one data source for each stat. This is a matter of preference
and I personally prefer to have a single block of stats on my screen neatly
displayed and not requiring me to have so many different profiles for each class
and each spec.

# Release Process

The project uses [Travis CI](https://travis-ci.com/) for continuous integration
and automated release. The actual packaging and release process is done using
the [BigWigs Packager Script](https://github.com/BigWigsMods/packager).

1. You push changes to GitHub, including a tag which signifies a new
   release/version.
2. Travis CI gets notified by GitHub, which clones the repository and downloads
   the packager script.
3. The packager runs all of the tasks it needs to create a zip.
4. The packager uploads that zip to all the sites specified in .pkgmeta file.
4. Addons are now uploaded and are awaiting approval by the site administrators.

So, all what is needed is to push to GitHub with a tag, like below:
```
git tag -am "Tag v2.0" v2.0 && git push origin master --tags
```

# Credits
Thanks to the excellent guide ["Automagically package and publish addons"](https://www.wowinterface.com/forums/showthread.php?t=55801) which gives all necessary
details to automate the packaging and release process.
