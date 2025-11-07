# Initial git setup
function setup_git --argument-names user_name user_email
    test -z "$user_name"; and set user_name $USER
    test -z "$user_email"; and set user_email $EMAIL

    git config --global user.name "$user_name"
    git config --global user.email "$user_email"
    git config --global init.defaultBranch $GIT_BRANCH
    git config --global color.ui true
    git config --global core.editor $EDITOR
    git config --list
    echo
    cecho GREEN BOLD " git has been configured..."
end
