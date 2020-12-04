require 'markdown_generator'

PREAMBLE = <<-PRE
# **Welcome to the Sliflist!**

To use this wishlist in DIM, copy and paste this URL in the Settings
page under "Wish List"

```
https://raw.githubusercontent.com/rslifka/wishlist/master/wishlist.txt
```

Check out the [README](https://github.com/rslifka/wishlist/) for more info.

---
PRE

desc "Generate human-readable thoughts from our roll data"
task :generate_thoughts, [:environment] do |t, args|
  toc = YAML.load_file('toc.yml')

  File.open(thoughts_filename(args.environment), 'w') do |thoughts|
    toc_contents = StringIO.new
    body_contents = StringIO.new
    
    toc['ordering'].each do |collection|
      toc_contents.puts("\n**#{toc['naming'][collection]}**")
      Dir.children(File.join('wish_dsl', collection)).sort.each do |weapon|
        toc_link = MarkdownGenerator.generate_toc_link(File.join('wish_dsl', collection, weapon))
        toc_contents.puts(toc_link)
        
        roll = MarkdownGenerator.generate_roll(File.join('wish_dsl', collection, weapon))
        body_contents.puts(roll)
      end
    end

    thoughts.puts(PREAMBLE)
    thoughts.puts(toc_contents.string)
    thoughts.puts("\n---\n")
    thoughts.puts(body_contents.string)
  end
end
