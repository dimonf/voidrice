#!/bin/sh
#this etnire script had been copied from luck smith larbs installation script, larbs.sh

dotfilesrepo="https://github.com/dimonf/voidrice.git"
repobranch='master'
name=`echo $USER`

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

# Install the dotfiles in the user's home directory, but remove .git dir and
# other unnecessary files.
putgitrepo "$dotfilesrepo" "/home/$name" "$repobranch"
rm -rf "/home/$name/.git/" "/home/$name/README.md" "/home/$name/LICENSE" "/home/$name/FUNDING.yml"
