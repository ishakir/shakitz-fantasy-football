if not Rails.env.production? or File.basename($0) == "rake"
	puts "Not in production mode, so not scheduling game week locking"
else
	puts "In production mode, so scheduling game week locking"
end