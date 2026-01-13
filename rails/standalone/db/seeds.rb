puts "Creating test user (no subscription)..."
user = User.find_or_create_by!(email_address: "user@example.com") do |u|
  u.password = "password"
  puts "  ✓ User created: #{u.email_address}"
end

if user.persisted? && !user.previously_new_record?
  puts "  ✓ User already exists: #{user.email_address}"
end

puts "\nCreating customer user with subscription..."
customer_user = User.find_or_create_by!(email_address: "customer@example.com") do |u|
  u.password = "password"
  puts "  ✓ Customer user created: #{u.email_address}"
end

if customer_user.persisted? && !customer_user.previously_new_record?
  puts "  ✓ Customer user already exists: #{customer_user.email_address}"
end

puts "Creating active subscription..."
subscription = Subscription.find_or_create_by!(
  user: customer_user,
  processor_id: "sub_#{SecureRandom.hex(12)}"
) do |s|
  s.store = "apple"
  s.store_product_id = "dev.purchasekit.pro.annual"
  s.status = "active"
  s.current_period_start = Time.current
  s.current_period_end = 1.year.from_now
  puts "  ✓ Subscription created: #{s.store_product_id} (#{s.status})"
end

if subscription.persisted? && !subscription.previously_new_record?
  puts "  ✓ Subscription already exists: #{subscription.store_product_id} (#{subscription.status})"
end

puts "\n✓ Seeds completed!"
puts "\nTest credentials:"
puts "\n  User without subscription:"
puts "    Email: user@example.com"
puts "    Password: password"
puts "\n  Customer with subscription:"
puts "    Email: customer@example.com"
puts "    Password: password"
puts "    Subscription: #{subscription.store_product_id} (#{subscription.status})"
puts "    Ends at: #{subscription.current_period_end.strftime("%Y-%m-%d")}"
