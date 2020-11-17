`plist_merger` merges multiple plist files into a single one.

This tool takes multiple `--input` arguments that point to each input plist
file. When key duplication occurs, the value from the first file wins.

`plist_merger` only runs on Darwin.
