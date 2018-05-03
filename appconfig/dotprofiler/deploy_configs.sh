PNAME=$( ps -p "$$" -o comm= )
SNAME=$( echo "$SHELL" | grep -Eo '[^/]+/?$' )
if [ "$PNAME" != "$SNAME" ]; then
  exec "$SHELL" "$0" "$@"
  exit "$?"
else
  source ~/."$SNAME"rc
fi

$GIT_PATH/linux-setup/submodules/dotprofiler/profiler.sh deploy $GIT_PATH/linux-setup/appconfig/dotprofiler/file_list.txt

