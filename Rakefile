require 'date'

desc "Concat everything under ./lists"
task :combine_wishlists do
  File.open('wishlist.txt', 'w') do |wishlist|
    wishlist.puts("// Wishlist generated around #{DateTime.now.strftime("%e %b %Y %H:%M:%S")}")
    wishlist.puts('// Up-to-date version: https://github.com/rslifka/wishlist')
    wishlist.puts('')
    Dir.glob('lists/*.txt') do |filename|
      wishlist.puts(File.read(filename))
      wishlist.puts('')
    end
  end
end

desc "Extract notes on thought process for all weapons"
task :thought_process do
  File.open('thought_process.md', 'w') do |thoughts|
    thoughts.puts("From wishlist generated around #{DateTime.now.strftime("%e %b %Y %H:%M:%S")}")
    thoughts.puts('')
    thoughts.puts('An up-to-date version can be found [here](https://github.com/rslifka/wishlist)')

    wishlist = File.read('wishlist.txt')
    item_name = ''
    lightgg_link = ''
    wishlist.each_line do |line|
      line.match(/\/\/item:(.*),lightgg:(.*)/) do |m|
        item_name = m[1]
        lightgg_link = m[2]
      end
      line.match(/\/\/notes:(.*)/) do |m|
        markdown = line.gsub(
          /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/,
          '[\1](\1)'
        )
        thoughts.puts "## #{item_name}"
        thoughts.puts "#{markdown} ([view item on light.gg](#{lightgg_link}))"
      end
    end
  end
end

task :default => ["combine_wishlists", "thought_process"]