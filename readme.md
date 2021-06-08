# Github SSH

## Generating a new SSH key and adding it to the ssh-agent

Open Terminal.

Paste the text below, substituting in your GitHub email address.

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

> Note: If you are using a legacy system that doesn't support the Ed25519 algorithm, use:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

This creates a new ssh key, using the provided email as a label.

`> Generating public/private ed25519 key pair.`

When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.

`> Enter a file in which to save the key (/home/you/.ssh/id_ed25519): [Press enter]`

At the prompt, type a secure passphrase. For more information, see "Working with SSH key passphrases."

```bash
> Enter passphrase (empty for no passphrase): [Type a passphrase]
> Enter same passphrase again: [Type passphrase again]
```

Start the ssh-agent in the background.

```bash
$ eval "$(ssh-agent -s)"
> Agent pid 59566
```

In some Linux environments, you need root access to run the command:

```bash
$ sudo -s -H
$ eval "$(ssh-agent -s)"
> Agent pid 59566
```

Add your SSH private key to the ssh-agent. If you created your key with a different name, or if you are adding an existing key that has a different name, replace id_ed25519 in the command with the name of your private key file.

```bash
ssh-add ~/.ssh/id_ed25519
```

## Adding a new SSH key to your GitHub account

Copy the SSH public key to your clipboard.

If your SSH public key file has a different name than the example code, modify the filename to match your current setup. When copying your key, don't add any newlines or whitespace.

```bash
$ sudo apt-get update
$ sudo apt-get install xclip
# Downloads and installs xclip. If you don't have `apt-get`, you might need to use another installer (like `yum`)

$ xclip -selection clipboard < ~/.ssh/id_ed25519.pub
# Copies the contents of the id_ed25519.pub file to your clipboard
```

>Tip: If xclip isn't working, you can locate the hidden .ssh folder, open the file in your favorite text editor, and copy it to your clipboard.

In the upper-right corner of any page, click your profile photo, then click Settings. Settings icon in the user bar

In the user settings sidebar, click SSH and GPG keys. Authentication keys

Click New SSH key or Add SSH key. SSH Key button

In the "Title" field, add a descriptive label for the new key. For example, if you're using a personal Mac, you might call this key "Personal MacBook Air".

Paste your key into the "Key" field. The key field

Click Add SSH key. The Add key button

If prompted, confirm your Github password.

## Finishing Configurations

Test your connection using SSH

```bash
your_user_name@your_host_name:~> ssh -T git@github.com
The authenticity of host 'github.com (140.82.113.4)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,140.82.113.4' (RSA) to the list of known hosts.
Hi your_user_name! You've successfully authenticated, but GitHub does not provide shell access.
your_user_name@your_host_name:~>
```

## Clone a repository using SSH

The URL of a GitHub repository looks like:

`git@github.com:your_user_name/your_project_name.git`

Open the terminal and run the git clone command passing the copied URL as argument.

## Reconfigure existing repositories to use SSH

List the existing remote repositories and their URLs with:

```bash
git remote -v
```

That command should output something like:

```bash
origin  https://your_server/your_user_name/your_project_name.git (fetch)
origin  https://your_server/your_user_name/your_project_name.git (push)
```

Change your remote repository’s URL with:

```bash
git remote set-url origin git@your_server:your_user_name/your_project_name.git
```

Run git remote -v once more to verify that the remote repository’s URL has changed:

```bash
origin  git@your_server:your_user_name/your_project_name.git (fetch)
origin  git@your_server:your_user_name/your_project_name.git (push)
```
