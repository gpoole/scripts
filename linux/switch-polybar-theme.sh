#!/usr/bin/bash -x

if [ -z "$1" ] || ( ! [ -z "$2" ] && [ -z "$3" ] ); then
  echo "Usage: switch-polybar-theme.sh theme [category colour]"
  echo "switch-polybar-theme.sh polybar-2 dark cyan"
  echo ""
  echo "Themes are:"
  find ~/.config/polybar-themes/ -depth -maxdepth 1 -mindepth 1 -name "polybar-*" -type d | xargs -n1 basename 
  exit 1
fi

if [ -e ~/.config/polybar ] && ! [ -L ~/.config/polybar ]; then
  echo "Polybar is not a symlink, better not remove it!"
  exit 1
fi

rm -f ~/.config/polybar
ln -s ~/.config/polybar-themes/$1 ~/.config/polybar

if [ "$3" ]; then
  if [ -r ~/.config/polybar/config.ini ] && ! [ -L ~/.config/polybar/config.ini ]; then
    echo "Can't link config in, it would overwrite an actual file"
    exit 1
  fi
  rm -f ~/.config/polybar/config.ini
  ln -s ~/.config/polybar/$2/config.$3 ~/.config/polybar/config.ini
fi

echo "Installing fonts"
pushd ~/.config/polybar/fonts/
for font in *.ttf; do
  cp "$font" ~/.local/share/fonts
done
popd

~/Scripts/linux/launch-polybar