# Unit 8 Bonus Section: Bash Scripting

> NOTE: This is an **optional** bonus section, meaning that you **DO NOT** need to read this.  
  This is aimed at people that want to dig deeper into using Bash.  

## Intro

### What is Bash?
Bash (Bourne Again SHell) is a shell that we use on Linux, but it's also a programming language.  
Every command you execute in the terminal is a line of Bash code.  
If you've done anything in the terminal on Linux, you've already written bash code.  

Bash scripting is just putting the code we'd run in the terminal into a file that can be executed.  

### Why does bash matter?
Bash is the default shell on most major Linux distributions, including Debian-based operating systems (Ubuntu, Mint), RedHat-based operating systems (RHEL, Fedora), and other distributions like Arch Linux.  
You will encounter this shell in most spaces you'll work in as a Linux system administrator.  




## Table of Contents
* [Intro](#intro) 
    * [What is Bash?](#what-is-bash) 
    * [Why does bash matter?](#why-does-bash-matter) 
* [Writing your First Script](#writing-your-first-script) 
    * [The Shebang Line](#the-shebang-line) 
    * [Add Some Code](#add-some-code) 
    * [Run the Script](#run-the-script) 
* [Compound Commands (Command Grouping)](#compound-commands-command-grouping) 
    * [Example: Short Circuit Logic with Command Grouping](#example-short-circuit-logic-with-command-grouping) 
* [Subshells](#subshells) 
* [Scripts run in Subshells](#scripts-run-in-subshells) 
    * [Writing a Function](#writing-a-function) 
* [Reloading configuration](#reloading-configuration) 
* [Variables](#variables) 
    * [Environment Variables](#environment-variables) 
    * [Defining Variables](#defining-variables) 
    * [Accessing Variables](#accessing-variables) 
* [Conditional Logic](#conditional-logic) 
    * [if-statements](#if-statements) 
    * [Testing Multiple Conditions at Once](#testing-multiple-conditions-at-once) 
    * [True and False with Exit Codes in Bash](#true-and-false-with-exit-codes-in-bash) 
* [Positional Parameters (CLI Arguments)](#positional-parameters-cli-arguments) 
    * [Parsing Command Line Arguments](#parsing-command-line-arguments) 
* [Sourcing Files vs Executing Files](#sourcing-files-vs-executing-files) 
* [Error Handling in Bash](#error-handling-in-bash) 
    * [Error Handling with Custom Functions](#error-handling-with-custom-functions) 
* [Debugging Bash Scripts](#debugging-bash-scripts) 
* [Test what you've learned](#test-what-youve-learned) 




## Writing your First Script
Let's create a new file to make into a Bash script.  
```bash
touch first-script
```
If you want, you can also use a `.sh` file extension.  
```bash
touch first-script.sh
```

There's no functional difference between the two.  
People argue about this, but just use whatever one resonates more with you.  

The next step is to make this file executable.  
```bash
chmod u+x first-script
# or, use octal notation
chmod 755 first-script
```
Once this is done, we'll be able to directly execute this file.  
But, for now it doesn't have anything in it.  

### The Shebang Line

You start the first line of every bash script with a "shebang" line.  
This tells the shell what program to use to execute the file.  
In this case, we're using `bash` itself.  

Open the file with `vi`:
```bash
vi first-script
```
Then add this line:
```bash
#!/bin/bash
```
Save the file with `:w`.  
Now, when this file is executed, it will use the given binary (`/bin/bash`).  

### Add Some Code
Let's add some Bash code for the script to run.  
```bash
#!/bin/bash

echo "Hello, admin."
printf "Hello, admin.\n"
```
Both of these commands, `echo` and `printf`, output text to the terminal.  
People argue about this too, but again, use whichever resonates more with you.  
* `echo`: Easy to use and all shells have some version of it.  
* `printf`: Matches the `printf` of most other programming languages, so it's good to learn if you want to learn other languages.  

Save the file and exit with `:wq`.  

### Run the Script
Now the script is ready to run.  
```bash
$ ./first-script
```
* `./` is necessary because the file is not in your `PATH` environment variable, so
  you need to tell bash where to look for the file.  

You should see the output:
```plaintext
Hello, admin.
Hello, admin.
```

## Compound Commands (Command Grouping)
Compound commands are groups of commands to be run together, and then share the same output.  
Since they share the same output, if one fails they all fail.  

Compound commands can be done with parentheses `( ... )` or braces `{ ... }`.  

Using paretheses will spawn a subshell, which may not always be what you want.  

Putting commands inside of braces `{ ... }` will not spawn a subshell. Any commands
inside this command group will be executed in the current shell context.  

Any changes made inside a `{ ... }` grouping will persist even after the command group is done executing.  
```bash
declare MY_VAR
{ MY_VAR="Hello"; printf "%s\n" "$MY_VAR"; }
# output: Hello
printf "%s\n" "$MY_VAR"
# output: Hello
```
* Note: You need to either end lines with a semicolon when using braces or put the ending brace on a new line.  

---

Command grouping executes all of the commands as a single unit. That makes it possible to direct the output of multiple commands at one time.  
```bash
{ date; printf "Systems acting normal!\n"; } > report.txt
```
This will output to `report.txt`:
```plaintext
Sat Jan 31 16:16:09 EST 2025  
Systems acting normal!
```

Command grouping is also very useful for conditionals with [short-circuit logic](#short-circuit-logic).  


### Example: Short Circuit Logic with Command Grouping
This example is using [command grouping](#compound-commands-command-grouping) with [short
circuit logic](#short-circuit-logic) to define the `OS_FAMILY` variable.  
```bash
{
    which apt && printf "OS_FAMILY: %s\n" "${OS_FAMILY:=debian}"; 
} || {
    which dnf && printf "OS_FAMILY: %s\n" "${OS_FAMILY:=rhel}"; 
}
```
This checks for the package managers `dnf` and `apt`.  
If the package manager is `apt`, it sets the `OS_FAMILY` variable to `debian` if it's not already set (it won't overwrite the variable).  
If that check does not succeed (remember, the output of that command group will be the output of all commands), then it will move on to the next.  
If the package manager is `dnf`, it sets the `OS_FAMILY` variable to `rhel` if it's not already set.  

This is functionally equivalent to:
```bash
if which apt; then
    printf "OS_FAMILY: %s\n" "${OS_FAMILY:=debian}"
elif which dnf; then
    printf "OS_FAMILY: %s\n" "${OS_FAMILY:=rhel}"
fi
```



## Subshells

A subshell is another instance of bash that spawns as the child of the current shell.  
Common ways to create subshells:
* `$(commands)`: Modern way to create a subshell
* ``` `commands` ``` (Older method, considered legacy)


The `$` is not *necessarily* needed in order to spawn a subshell.  
Whenever commands are wrapped in parentheses, a subshell is spawned to execute those commands.  
Simply doing `( ... )` will run any commands in a subshell.  

However, if you need to **use or capture the output** of the commands (for example, to
store in a variable), use `$( ... )`.  

```bash
# GOOD:
FILES=$(ls ~) # Will store the output of the command.  

# BAD:
FILES=(ls ~)  # Bash thinks you're trying to define an array.
              # Won't store the output of the command.  
```
      
Subshells can be used as [compound commands](#compound-commands-command-grouping).  

## Scripts run in Subshells
Every time you execute a script, it spawns a subshell from the current environment.  
The script's subshell inherits all the exported variables from the current environment.  

Because scripts run in subshells, using commands like `cd` don't work the same way as
if it were run from the command line. It only affects the subshell.  
 
If you want to use `cd` inside a script, put it in a function.  
 
A function won't spawn an additional subshell when it's run.  

### Writing a Function
You can define functions inside your `~/.bashrc` file or inside a script.   

In your `.bashrc`:
```bash
first-function() {
    echo "Hello, admin."
    printf "Hello, admin.\n"
}
```
As with every change to your `~/.bashrc` file, you need to reload bash in order for
it to take effect.  

Reload bash with `exec bash -l` or restart the shell, then you can run `first-function` from the command line.  

* Alternatively, you can make a separate file specifically for bash functions in
  `~/.bash_functions`, then source this file from within your `~/.bashrc` file.  
    * This file is sourced by default inside many default `.bashrc` files.  
      ```bash
      if [ -f ~/.bash_functions ]; then
          . ~/.bash_functions
      fi
      ```
      You can check if this is the defualt on your OS in `/etc/skel/.bashrc`.  

## Reloading configuration
There are a few ways you can reload your `.bashrc` file.  
1. `source`: Use the `source` (or `.`) command to source the file.  
    ```bash
    source ~/.bashrc
    . ~/.bashrc
    ```
    * Also see [sourcing files vs executing files](#sourcing-files-vs-executing-files)
2. `exec bash -l`: This uses `exec` to replace the current shell with a new instance
   of `bash`, reloading your configuration files in the process.  
    * `exec` replaces the current shell with another process.
    * In this case, it's a `bash -l`ogin shell.
3. Restart the shell. By far the most inconvenient way to reload bash, but it works.  


## Variables
Variables in bash are usually either just strings or numbers.  
Variables can also be arrays, which are a collection of other variables.  
There are also associative arrays, also called dictionaries, which have key/value pairs.  

### Environment Variables
Environment variables are variables set by the shell (or you as a user in your `.bashrc`).  
They are made available to any process on the system.  
<!-- Each user can have their own set of environment variables. -->  

* `SHELLOPTS`: Set by `shopt`?
* `BASHOPTS`: Set by `set`?

### Defining Variables
Variables in bash are defined with the `=` operator.
```bash
VAR_NAME="some value"
```
Notice there are no spaces.  
If the statement contains spaces, bash will think you're trying to run a command.  

Defining a variable like this will make it available to the current environment.  
What does that mean? It will be available inside the script it was defined in or
inside the current shell if run from the command line.  

If you want to access a variable outside of the environment it was defined in, you
need to `export` it.  
```bash
export MY_VAR="some value"
```
This will make the variable accessible to subshells and other processes on the system.  

However, if you export variables inside a script that you've executed, those variables **will not** be available to the **parent shell** (your instance of bash).  
Likewise, exporting variables **will not** make them available to the **parent**
shell.  

For example:
```bash
export MY_VAR="hello"     # Available in this shell and subshells
bash -c 'echo "$MY_VAR"'  # Prints "hello"
echo "$MY_VAR"            # Still "hello" in the original shell

# BUT, if we export it with a new value in a subshell:
bash -c 'export MY_VAR="world"'
echo "$MY_VAR"  # Still "hello" because exports don't propagate *upward*
```


You would need `source` the file if you need to access variables that are `export`ed inside the script.  

### Accessing Variables
You can access a variable by using the `$` operator.  
```bash
MY_VAR="Hello, admin."
echo "$MY_VAR"
# output:
# Hello, admin.
```
Variables are usually quoted for safety reasons, to prevent weird things like word splitting.  
* One thing to note is that you should use double quotes instead of single quotes for
  variables.  
* When using single quotes, bash will use the literal string that is inside them.
  Nothing will be expanded.
  ```bash
  echo '$MY_VAR'
  # output: 
  # $MY_VAR
  ```

You can also use braces around the variable name, which adds some really cool functionality (like [parameter expansion](#parameter-expansion)).  
```bash
echo "${MY_VAR}"
```

Using braces like this will allow you to perform **parameter expansions** (`man bash` and search for `Parameter Expansion`), and if the variable is an array, it will allow you to access the array's elements.  


## Conditional Logic
Bash, like any other programming language, has conditional logic support.  

When using conditional logic, the expression you specify always evaluates to
either `true` or `false`, which, unlike other languages, are `0` and `1` in 
bash, respectively (also see [True and False with Exit Codes in Bash](#true-and-false-with-exit-codes-in-bash)).  


### if-statements
* `if`/`elif`/`else`: The most basic way to do conditional logic in bash.  
    * `if`: Tests if a condition is true or not.  
    * `elif`: If the first `if` statement is not true, test if a different condition is true.  
    * `else`: If none of the conditions are true, this code runs.  
Every `if` needs a corresponding `fi` to terminate it.  

When a condition evaluates to true, the code will run. 
For instance:
```bash
if [[ -n $MY_VAR ]]; then
    printf "MY_VAR is not an empty string!\n"
fi
```
* `-n`: A conditional expression that tests if the given value is "non-zero" -- in this case, not an empty string.  
    * There are a bunch of these conditional expressions.
    * Use `man bash` and type `/CONDITIONAL EXPRESSIONS` for a full list.  

You can use the `!` (NOT) operator to test if a condition is false:
```bash
if [[ ! -n $MY_VAR ]]; then
    printf "MY_VAR is an empty string!\n"
fi
# or
if ! [[ -n $MY_VAR ]]; then
    printf "MY_VAR is an empty string!\n"
fi
```

---

This can also be done on a single line by using semicolons:
```bash
if [[ -n $MY_VAR ]]; then printf "MY_VAR is not empty!\n"; fi
```
This is generally how you will do an if-statement from the command line.  

Alternatively, you can omit the `if` and use a type of "short-circuit logic" using
the `&&` operator:
```bash
[[ -n $MY_VAR ]] && printf "MY_VAR is not empty!\n"
```
This checks the first condition `-n $MY_VAR` and only executes the `printf` if true.  
If you want to test multiple conditions with this method, you need to use [**command grouping**](#compound-commands-command-grouping).  

---


### Testing Multiple Conditions at Once
You can test multiple conditions at one time in a single if-statement.  
Do this with the `&&` (AND) and `||` (OR) operators.  

* `condition && condition`: Both conditions must be true.  
* `condition || condition`: At least one condition must be true.


```bash
if [[ -f ~/somefile ]] && [[ -n $MY_VAR ]]; then
    printf "~/somefile exists and MY_VAR is not an empty string!\n"
fi
```
* This code is executed only if both `~/somefile` exists, AND (`&&`) `MY_VAR` is non-zero.  
* Both conditions must be true.  

```bash
if [[ -f ~/somefile ]] || [[ -n $MY_VAR ]]; then
    printf "~/somefile exists and MY_VAR is not an empty string!\n"
fi
```
* This code is executed if EITHER `~/somefile` exists, OR (`||`) `MY_VAR` is non-zero.  


### True and False with Exit Codes in Bash
One thing to consider when using bash is that `true` and `false` work a bit differently than other programming languages.  

In most languages, `1` is `true` and `0` is `false`. In bash, this is the opposite.  
Bash conditionals operate on "exit codes" (or "return codes") rather than actual `true` or `false` statements.  
Every single program that runs on a Linux machine has an exit code.  
A zero (`0`) exit code in Linux means the program ran successfully, with zero errors.  
Anything above `0` means there was some sort of problem with execution.  

```bash
touch ./somefile     # Creating a file
[[ -f ./somefile ]]  # This will return 0 (success)
```

---

When testing conditions in bash with either single brackets `[ ]`, you're using the
`/bin/test` program (see `man [`).  

This program will return an exit code of `0` if the condition evaluates to `true`, or `1` if
the condition evaluates to `false`.  
Using double brackets `[[ ]]` does the same thing, but it is instead a keyword/builtin in bash rather than a separate binary (see `help [[`).  


## Positional Parameters (CLI Arguments)
Accessing positional parameters is important for any good bash script.  
* `$0` will always be the name of the program.  
* Any positional parameters greater than `9` require braces: `"${11}"`

The `$@` variable is an array that contains all the command line arguments that were passed to the bash script or function.  

```bash
my-function() {
    printf "The first argument: %s\n" "$1"
}

my-function "Hello"
```

You can loop over this array with a `for` loop.  
```bash
for arg in "$@"; do
    printf "Argument: %s\n" "$arg"
done
```

### Parsing Command Line Arguments
If you're writing a robust script that takes flags/options (e.g., `--help`), you'll need to parse those.
You can use the `getopts` builtin (`help getopts`) or do a simple `while` loop with the `shift` keyword. 

Below is a small script that will take the `-v` option to define a variable internally.
```bash
#!/bin/bash

while [[ -n $1 ]]; do
    case $1 in
        -h|--help)
            printf "This is the help message.\n"
            shift;
            ;;
        -v|--variable)
            shift;  # Shift $1 to the next argument
            [[ -n $1 ]] && USER_VAR=$1
            printf "Assigned USER_VAR to: %s\n" "$USER_VAR"
            shift;
            ;;
    esac
done

if [[ -n $USER_VAR ]]; then
    printf "User variable: %s\n" "$USER_VAR"
else
    printf "No variable was passed.\n"
fi
```
We can then invoke this script like this:
```bash
./script -v "My variable's value"
```

## Sourcing Files vs Executing Files
Sourcing a file in bash (using either `source` or `.`) will run all the bash code
inside that file in the **current shell instance**.  

This is different than running scripts, which spawn their own subshells to run the code.  

For instance, if we are in the `~/my-scripts` directory and have a bash script called `go-home`:
```bash
#!/bin/bash

# /home/connor/my-scripts/go-home
export MY_VAR="Hello, admin."
cd /home/connor
pwd
```

We can run this bash script and it will show:
```bash
connor@computer:~/my-scripts$ ./go-home
# output:
# /home/connor
connor@computer:~/my-scripts$
```
But, our current shell will still be in `~/my-scripts`.  
That's because the `cd` command only worked inside the subshell of the script.  

If we try to access the `MY_VAR` variable, it won't work either:
```bash
connor@computer:~/my-scripts$ echo $MY_VAR

connor@computer:~/my-scripts$ 
```
No output.  


However, if we source the file instead:
```bash
connor@computer:~/my-scripts$ source ./go-home
# or
connor@computer:~/my-scripts$ . ./go-home
connor@computer:~$
```
The output will be the same, but now the current shell will be in `/home/connor`.  
We'll also be able to access the `MY_VAR` variable.  
```bash
connor@computer:~$ echo $MY_VAR
# output: 
# Hello, admin.
connor@computer:~$ 
```
Now the variable is set in the current shell.  

This is why `.bashrc` and other shell runtime config files are sourced, not executed.  

---

## Error Handling in Bash
Error handling in bash can be done with simple `if` statements.  

Since bash checks the [**exit code**](#true-and-false-with-exit-codes-in-bash) of a
program for conditionals, you can easily use this to handle cases where a program did
not exit with a `0` exit code.  
```bash
if ! curl -O https://example.com/file.txt; then
    printf "There was an error downloading the file!\n"
else
    printf "Downloaded file.txt!\n"
fi
```
* `if ! curl`: "If curl does *not* (`!`) exit with `0`".

---

Another way to handle errors is with [command grouping](#compound-commands-command-grouping).  
```bash
{
    curl -O example.com/file.txt && printf "Downloaded file.txt!\n"
} || {
    printf "Error occurred while downloading file.txt!\n" && exit 1
}
```
This uses two command groups, separated with the OR (`||`).  
If any command in the first group fails, the second group will be executed.  

### Error Handling with Custom Functions
When writing functions, use the `return` keyword for handling errors.  
Any non-zero return code between 1 and 256 can be used to indicate a failed function.  
```bash
download-file() {
    if ! curl -O https://example.com/somefile.txt; then
        return 1
    else
        return 0
    fi
}
```
* If the `curl` command fails, the function will return `1`.  
* If the `curl` command succeeds, `0` will be returned.  

Using this methodology, we can handle errors with our own functions:
```bash
if ! download-file; then
    printf "Failed to download file!\n"
fi
```

## Debugging Bash Scripts
When writing Bash scripts, it can be difficult to narrow down where problems are.  
Luckily, we have some tools that we can use to help us debug those problems.  
* `set -x`: Put this at the beginning of your script to print out each line of code
  before executing it. This is one of the go-to tools for debugging bash code.  

* `set -e`: This will cause the script to exit if **any** command fails.  

Below is a script that implements these debugging techniques.
```bash
#!/bin/bash
set -xe  # Enable debugging and exit on failure

mkdir /tmp/mydir
cd /tmp/mydir
rm -rf /tmp/mydir
```


## Test what you've learned

If you want to try your hand at putting some of these concepts into practice, write a
bash script.  

Choose something you would normally do manually (e.g., installing a program without a
package manager) and write a script to do it for you, using functions and error
handling.  
If you run into any problems or have any questions, feel free to ask in the ProLUG discord!

Happy scripting!  

