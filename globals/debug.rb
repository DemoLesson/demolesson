def dump(v, type = "ex")
	return raise StandardError, v if type == "ex"
	puts v
	exit
end