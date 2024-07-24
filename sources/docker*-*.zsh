# :fzf-tab:complete:(docker|docker*):*
# echo ':fzf-tab:complete:docker-*:argument-1'

local level=$(echo "$words" | tr -cd ' ' | wc -c)
local prefix="${words% *}"

# Show command's help for --help option
if [[ $group =~ "option" ]] && [[ $word == "--help" ]]; then
  if bash -c "$prefix --help" >/dev/null 2>&1; then
    echo "$ $prefix --help" | bat -pl bash
    eval $prefix --help | bat -l help
  fi
  return
fi

# 1st-level command, e.g. docker run
if [[ $group == "docker command" ]]; then
  if bash -c "tldr docker $word" >/dev/null 2>&1; then
    echo "$ tldr docker $word"
    tldr --color=always docker $word | tail -n +3
    echo
  fi

  if bash -c "docker help $word" >/dev/null 2>&1; then
    echo "$ docker help $word"
    docker help $word | bat -lhelp
    echo
  fi

  echo "$ man docker-$word"
  man docker-$word 2>/dev/null | bat -lman

  # debug
fi

# 1st-level command, e.g. docker-compose run
if [[ $group == "docker-compose command" ]]; then
  if bash -c "tldr docker-compose $word" >/dev/null 2>&1; then
    echo "$ tldr docker-compose $word"
    tldr --color=always docker-compose $word | tail -n +3
    echo
  fi

  if bash -c "docker-compose $word --help" >/dev/null 2>&1; then
    echo "$ docker-compose $word --help"
    docker-compose $word --help | bat -lhelp
    echo
  fi

  echo "$ man docker-compose-$word"
  man docker-compose-$word 2>/dev/null | bat -lman

fi

## 2st-level command, e.g. docker context use
if [ $level = 2 ] && [[ $group =~ " command" ]]; then
  if bash -c "tldr $prefix $word" >/dev/null 2>&1; then
    echo "$ tldr $prefix $word"
    tldr --color=always $prefix $word | tail -n +3
    echo
  fi

  echo "$ $prefix $word --help"
  eval "$prefix $word --help"
  # debug

  return
fi

# Image command
# if [[ $group == "docker image command" ]]; then
#   echo "$ docker image $word --help"
#   docker image $word --help
# fi

if [[ $words =~ "docker image " ]]; then
  if [[ $words =~ " (history)" ]] && [[ $group == "images" ]]; then
    echo "$ $prefix $word"
    eval "$prefix $word" | bat -pl bash
  fi
fi

# Container command
# if [[ $group == "docker container command" ]]; then
#   if bash -c "tldr docker container $word" >/dev/null 2>&1; then
#     echo "$ tldr docker container $word"
#     tldr --color=always docker container $word | tail -n +3
#   fi

#   echo "$ docker container $word --help"
#   docker container $word --help
# fi

if [[ $words == "docker container logs " ]]; then
  echo "$ docker container logs $word"
  docker container logs $word # TODO: not render properly in fzf-preview
fi

if [[ $prefix =~ "docker diff|docker container (diff|commit)" ]]; then
  echo "$ docker container diff $word"
  diff=$(docker container diff $word)
  if [[ -z "${diff}" ]]; then
    echo "No changes to files or directories on the container's filesystem"
  else
    echo $diff | bat -pl bash
  fi
  return
fi

if [[ $words =~ "docker container " ]] && ! [[ $words =~ " (cp)" ]]; then
  if [[ $words =~ " (stats)" ]]; then
    echo "$ $prefix $word"
    eval "$prefix $word" | bat -pl bash
  fi

  if [[ $words =~ " (attach|inspect|rm|start|stop|rename|top|unpause|update)" ]]; then
    local inspect_output=$(docker container inspect $word)
    local container_status=$(echo $inspect_output | jq '.[0].State.Status')

    if [[ $container_status == "\"running\"" ]]; then
      echo "$ docker container top $word"
      docker container top $word | bat -pl bash
      echo
    fi

    echo "$ docker container inspect $word"
    echo $inspect_output | jq --color-output
  fi
fi

# Images
if [[ $group == "images" ]]; then
  echo "$ docker image inspect $word"
  docker image inspect $word | jq --color-output
fi

# Repositories
if [[ $group == "repositories" ]]; then
  echo "$ docker images $word"
  if [ "$(command -v docker-color-output)" ]; then
    docker images $word | docker-color-output
  else
    docker images $word
  fi
fi

# Containers
if [[ $group =~ "container" ]]; then
  local inspect_output=$(docker container inspect $word)
  local container_status=$(echo $inspect_output | jq '.[0].State.Status')

  if [[ $container_status == "\"running\"" ]]; then
    echo "$ docker container top $word"
    docker container top $word | bat -pl bash
    echo
  fi

  echo "$ docker container inspect $word"
  echo $inspect_output | jq --color-output
fi

# Context/network/volume
if [[ $group =~ "(context|network|volume)" ]]; then
  echo "$ docker inspect $word"
  docker inspect $word | jq --color-output
fi

# Path or URL
if [[ $group == "path or URL" ]]; then
  if [ -f $realpath ] || [ -d $realpath ]; then
    echo "$ less $realpath"
    eval "less $realpath"
  fi
fi

echo
hr
debug
