require 'date'

task :default => ["combine_wishlists"]

desc "Concat everything under ./lists"
task :combine_wishlists do
  File.open('wishlist.txt', 'w') do |wishlist|
    wishlist.puts("// Wishlist generated #{Date.today.strftime("%e %b %Y %H:%M:%S")}")
    wishlist.puts("// Up-to-date version: https://github.com/rslifka/wishlist")
    Dir.glob('lists/*.txt') do |filename|
      wishlist.puts(File.read(filename))
    end
  end
end