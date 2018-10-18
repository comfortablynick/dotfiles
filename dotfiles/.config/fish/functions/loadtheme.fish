function loadtheme --argument target_theme
	set -l plugin_dir $OMF_PATH/themes/$target_theme
  if not test -d $plugin_dir
    echo "Cannot find $target_theme in themes directory."
    return 0
  end
  if test -f $OMF_CONFIG/theme
    read current_theme <$OMF_CONFIG/theme
    test "$target_theme" -eq "$current_theme"
    and return 0
  end

  for f in (find $plugin_dir -maxdepth 2 -iname "*.fish")
    source $f
  end
  echo "$target_theme" >"$OMF_CONFIG/theme"
  return 0
end
