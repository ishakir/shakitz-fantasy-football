if not Rails.env.production? or File.basename($0) == "rake"
	puts "Not in production mode, so not scheduling fixtures generation"
else
	puts "In production mode, so scheduling fixtures generation"
end