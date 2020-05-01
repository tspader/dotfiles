function fish_prompt
    set_color $fish_color_cwd
	echo -n $USER
	echo -n ' '
	echo -n (prompt_pwd)
	set_color normal
	echo -n ' > '
end
