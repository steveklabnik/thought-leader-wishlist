require 'markdown_generator'

task :generate_wishlist, [:environment] do |t, args|
  output_list = StringIO.new

  Dir['wish_dsl/**/*.yml'].sort.each do |roll_file|
    output_list.puts(MarkdownGenerator.generate_wishlist(roll_file))
  end
  
  File.open(wishlist_filename(args.environment), 'w') do |wishlist|
    wishlist.puts <<-PREAMBLE
title: SlifSF's Sliflist
description: Generated #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S %:z")}
PREAMBLE
    wishlist.puts(output_list.string)
  end
end