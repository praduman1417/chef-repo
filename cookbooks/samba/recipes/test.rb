search("samba_users","*:*").each do |user_data|
	print user_data["id"]  
	print user_data["smbpasswd"]
end


shares = data_bag_item("samba", "shares")

shares["shares"].each do |k,v|
  if v.has_key?("path")
    print v["path"] 
  end
end