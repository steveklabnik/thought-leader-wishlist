task :default => ["combine_wishlists"]

desc "Concat everything under ./lists"
task :combine_wishlists do
  File.open('wishlist.txt', 'w') do |wishlist|
    Dir.glob('lists/*.txt') do |filename|
      wishlist.puts(File.read(filename))
    end
  end
end