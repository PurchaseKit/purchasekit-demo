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

puts "Setting payment processor..."
pay_customer = customer_user.set_payment_processor(:purchasekit, processor_id: "cus_#{SecureRandom.hex(12)}")
puts "  ✓ Pay customer created with processor: #{pay_customer.processor}"

puts "Creating active PurchaseKit subscription..."
subscription = Pay::Subscription.find_or_create_by!(
  customer: pay_customer,
  name: "purchasekit"
) do |s|
  s.processor_id = "sub_#{SecureRandom.hex(12)}"
  s.processor_plan = "purchasekit"
  s.status = "active"
  s.quantity = 1
  s.trial_ends_at = nil
  s.ends_at = 1.year.from_now
  puts "  ✓ Subscription created: #{s.name} (#{s.status})"
end

if subscription.persisted? && !subscription.previously_new_record?
  puts "  ✓ Subscription already exists: #{subscription.name} (#{subscription.status})"
end

puts "\n✓ Seeds completed!"
puts "\nTest credentials:"
puts "\n  User without subscription:"
puts "    Email: user@example.com"
puts "    Password: password"
puts "\n  Customer with subscription:"
puts "    Email: customer@example.com"
puts "    Password: password"
puts "    Subscription: #{subscription.processor_plan} (#{subscription.status})"
puts "    Ends at: #{subscription.ends_at.strftime("%Y-%m-%d")}"
