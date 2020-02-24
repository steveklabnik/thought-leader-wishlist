directories %w(wish_dsl)

guard :rake, :task => 'generate_wishlist', :task_args => ['development'] do
  watch(/.+\.yml$/)
end

guard :rake, :task => 'generate_thoughts', :task_args => ['development'] do
  watch(/.+\.yml$/)
end