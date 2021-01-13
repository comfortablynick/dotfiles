#!/usr/bin/env fish

function __todoist_add
  set -l cmd 'todoist add '

  # read task name
  read -l -P 'Enter a task name:> ' task
  if test -z $task
    echo "Please enter a task name."
    return 1
  end
  set cmd "$cmd""\"$task\" "

  # read priority
  seq 4 -1 1 | fzf --reverse --header='AddTask:Priority' | read -l priority
  if test $pipestatus[2] -eq 130
    return 130
  end
  if not test -z $priority
    set cmd "$cmd""--priority $priority "
  end

  # read label
  command todoist labels | fzf --reverse --header='AddTask:Label' -m | cut -d ' ' -f 1 | tr '\n' ',' | sed -e 's/,$//' | read -l labels
  if test $pipestatus[2] -eq 130
    return 130
  end
  if not test -z $labels
    set cmd "$cmd""--label-ids $labels "
  end
  
  # read project
  command todoist projects | fzf --reverse --header='AddTask:Project' | head -n1 | cut -d ' ' -f 1 | read -l project
  if test $pipestatus[2] -eq 130
    return 130
  end
  if not test -z $project
    set cmd "$cmd""--project-id $project "
  end

  # read date
  begin
    echo 'No date'
    for i in (seq 0 14)
      command date --date="+$i day" +'%m/%d (%a)'
    end
  end | fzf --reverse --header='AddTask:Date' | cut -d ' ' -f 1 | read -l date_str
  if test $pipestatus[2] -eq 130
    return 130
  end
  if not test -z $date_str
    and test "$date_str" != "No"
    set cmd "$cmd""--date $date_str "
  end
  
  echo $cmd
  eval $cmd 
end
