require 'markdown_generator'

desc "Generate human-readable thoughts from our roll data"
task :generate_thoughts, [:environment] do |t, args|
  toc_contents = StringIO.new
  body_contents = StringIO.new

  toc = YAML.load_file('toc.yml')
  toc['ordering'].each do |collection|
    toc_contents.puts("\n**#{toc['naming'][collection]}**")
    Dir.children(File.join('wish_dsl', collection)).sort.each do |weapon|
      toc_link = MarkdownGenerator.generate_toc_link(File.join('wish_dsl', collection, weapon))
      toc_contents.puts(toc_link)
      
      roll = MarkdownGenerator.generate_roll(File.join('wish_dsl', collection, weapon))
      body_contents.puts(roll)
    end
  end

  File.open(thoughts_filename(args.environment), 'w') do |thoughts|
    thoughts.puts <<-PRE
To use this wishlist in DIM, copy and paste this URL in the Settings
page under "Wish List"

```
https://raw.githubusercontent.com/steveklabnik/thought-leader-wishlist/main/wishlist.txt
```

Check out the [README](https://github.com/steveklabnik/thought-leader-wishlist/) for more info.

---
PRE
    thoughts.puts(toc_contents.string)
    thoughts.puts("\n---\n")
    thoughts.puts(body_contents.string)
  end
end
