#!/bin/sh
#this etnire script had been copied from luck smith larbs installation script, larbs.sh

dotfilesrepo="https://github.com/dimonf/voidrice.git"
repobranch='master'
name=`echo $USER`
home_dir="/home/$name"

repo_dir_canonical=`readlink -f "$0"`
repo_dir=${repo_dir_canonical%/*/*}

cleanup() {
  for fl in .git README.md LICENSE FUNDING.yml bin; do
    rm -rf "$home_dir/$fl"
  done
}

putgitrepo() {
  # Downloads a gitrepo $1 and places the files in $2 only overwriting conflicts
  whiptail --infobox "Downloading and installing config files..." 7 60
  [ -z "$3" ] && branch="master" || branch="$repobranch"
  dir=$(mktemp -d)
  [ ! -d "$2" ] && mkdir -p "$2"
  chown "$name":wheel "$dir" "$2"
  sudo -u "$name" git -C "$repodir" clone --depth 1 \
    --single-branch --no-tags -q --recursive -b "$branch" \
    --recurse-submodules "$1" "$dir"
  sudo -u "$name" cp -rfT "$dir" "$2"
}


### main script ###

#echo "vars:" $repo_dir $0
#check whether this script is executed from within appropriate git repo. Otherwise,
#  try to fetch files from github repo (original Luck's way)
if [[ -d "$repo_dir/.git"  ]] && `grep -q Voidrice "$repo_dir/README.md"` ; then
  echo "copying from local repo $repo_dir"
  cp -rTf "$repo_dir" "$home_dir"
  cleanup
else
  echo "fetching from $dotfilesrepo"
  putgitrepo "$dotfilesrepo" "$home_dir" "$repobranch"
  cleanup
fi
