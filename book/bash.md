# Bonus Section: Bash

Bash is a shell that we use on Linux, but it's also a programming language.  
Every command you execute in the terminal is a line of Bash code.  
If you've done anything in the terminal on Linux, you've already written bash code.  

Bash scripting is just putting the code we'd run in the terminal into a file.  

## Ideas
- `set -x` usage
    * using `set -x` at the beginning of a script enables debugging. I
    * This will show how every line of code is being interpreted by Bash as it happens. 
    * This can be very useful when debugging a bash script.
- `trap` for trapping signals - exiting gracefully
    * Traps are only effective within the script or function they're defined in.  
- `set`/`shopt` for shell options
- `shellcheck`: A tool used to lint and debug shell code.
    - Can be run on the command line.  
    - Supports integration with vim.  


## Table of Contents
* [Ideas](#ideas) 
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
    * [Accessing Arrays](#accessing-arrays) 
    * [Parameter Expansion](#parameter-expansion) 
* [Conditional Logic](#conditional-logic) 
    * [if-statements](#if-statements) 
    * [Using the `!` operator](#using-the--operator) 
    * [Testing Multiple Conditions at Once](#testing-multiple-conditions-at-once) 
    * [Short Circuit Logic](#short-circuit-logic) 
    * [True and False with Exit Codes in Bash](#true-and-false-with-exit-codes-in-bash) 
* [CLI Arguments](#cli-arguments) 
* [Sourcing Files vs Executing Files](#sourcing-files-vs-executing-files) 
* [Shell Options](#shell-options) 
    * [Enabling Shell Options](#enabling-shell-options) 


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
* `printf`: Matches the `printf` of most other programming languages, so it's good to
  learn if you want to learn other languages.  

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

Why is this important? Say you want to group commands that affect variables.  
If you use a subshell to assign variables, the variable won't perist after the
rest of the subshell execution.  
```bash
# Create an empty variable
declare MY_VAR
( MY_VAR="Hello"; printf "%s\n" "$MY_VAR"; )
# output: Hello
printf "%s\n" "$MY_VAR"
# No output 
```

Since using braces `{ ... }` does not spawn a subshell, any changes made inside that
grouping will persist even after the group is done executing.  
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

---

Command grouping with `{ ... }` is exactly what a [function](#writing-a-function) does. A function just
gives the group of commands a name.  

In short:
* Use braces `{ ... }` if you need to capture the output or if you need variables
  to persist to the parent shell.  
* Use parentheses `( ... )` if you do *not* need the output of the commands and do
  *not* need variable changes to persist to the parent shell.  


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

However, if you export variables inside a script that you've executed, those variables will not be available to the parent shell (your instance of bash).  

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

Using braces like this will allow you to perform [**parameter expansions**](#parameter-expansion), and if the variable is an array, it will allow you to access the array's elements.  

### Accessing Arrays
If your variable is an array, you need to use braces to access the values.  

```bash
echo "${MY_ARRAY[0]}"  # Output a single value
echo "${MY_ARRAY[@]}"  # Output all values separately
echo "${MY_ARRAY[*]}"  # Combine all values into one string and output that string
```



### Parameter Expansion
Parameter expansion is a way to modify the value of a variable at the same time that
you access it.  
Some common uses for parameter expansion:
```bash
echo "${#MY_VAR}"               # output the length of the variable
echo "${MY_VAR:="some value"}"  # Assign a default value to the variable if it's not set
echo "${MY_VAR:-"some value"}"  # Use (but don't assign) a default value for the variable if it's not set
echo "${MY_VAR//old/new}"       # Perform a substitution on the variable (line an in-line sed)
echo "${MY_VAR%old/new}"        # perform a substitution on the variable
```

* There are a lot of options for parameter expansions.  
    * Use `man bash` and type `/parameter expansion` to search for the section on it.  

One expansion that's particularly useful is the walrus operator `:=`.  
This is a great way to define variables if they're not set, without overwriting them if they are.  
```bash
: "${MY_VAR:="goodbye"}"
```
* This sets the `MY_VAR` variable to `goodbye` if it's not currently set, but does
  not overwrite it.  

A good trick to avoid getting `shellcheck` warnings is to use the `:` (colon) command
and passing the assignment as an argument.  
The `:` command is simply a dummy command. It does nothing and returns `0`, which evaluates to `true` in bash.  

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
```

---

This can also be done in-line (on a single line) by using semicolons:
```bash
if [[ -n $MY_VAR ]]; then printf "MY_VAR is not empty!\n"; fi
```
This is generally how you will do an if-statement from the command line.  

---

### Using the `!` operator
You can use the `!` (not) operator to check if the condition is false instead.  
```bash
if [[ ! -n $MY_VAR ]]; then
    printf "MY_VAR is an empty string!\n"
fi
```

---


Another useful conditional expression is `-f`, which checks to see if a file exists.  
```bash
if [[ -f ~/somefile ]]; then
    printf "File exists!\n"
elif [[ -f ~/someotherfile ]]; then
    printf "~/somefile doesn't exist, but ~/someotherfile does exist!\n"
else
    printf "None of the files exist!"
fi
```

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

### Short Circuit Logic
Because Bash evalutates conditions in order, left to right, you can use what some
refer to as "short circuit logic".  
This is a conditional statement that doesn't employ a full `if` statement.  


### True and False with Exit Codes in Bash
One thing to consider when using bash is that `true` and `false` work a bit differently than other programming languages.  

In most languages, `1` is `true` and `0` is `false`. In bash, this is the opposite.  
This is because bash conditionals generally operate on "exit codes" (somtimes called
"return codes") rather than actual `true` or `false` statements.  
Every single program that runs on a Linux machine has an exit code.  
A zero (`0`) exit code in Linux means the program ran successfully, with zero errors.  
Anything above `0` means there was some sort of problem with execution.  

```bash
MY_VAR="Hello, admin."
if [[ -n $MY_VAR ]]; then
    printf "%s\n" "$MY_VAR"
fi
```
When testing conditions in bash with either single brackets `[ ]`, you're using the
`/bin/test` program.  
This will return an exit code of `0` if the condition evaluates to `true`, or `1` if
the condition evaluates to `false`.  
Using double brackets `[[ ]]` does the same thing, but it is instead a keyword in bash rather than a separate binary.  

## Positional Parameters (CLI Arguments)
When passing arguments on the command line to a script or a function, those arguments
are stored in special variables; `$1`, `$2`, `$3`, etc..
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

## Shell Options
There are a number shell options you can enable to add functionality to bash.  

A list of shell options is stored in the `BASHOPTS` environment variable.  

There are two main builtins you'll use to set shell options:
* `set`: For POSIX shell options.  
    * When something is POSIX-Compatible, that means it will work in other shells (like `zsh`, `csh`, `dash`, etc.).  
* `shopt`: For Bash-specific shell options.  
Since these are builtins, you'll use `help <cmd>` instead of `man <cmd>` to read their documentation.  

---

Both `set` and `shopt` are able to set and unset options that modify the shell's behavior, but each of them controls a different type of options.  
| Command           |  Scope            | Purpose
|-------------------|-------------------|-
| `set`             |  POSIX-Compatible | Controls shell-wide behavior, including positional parameters and error handling. 
|  `shopt`          |  Bash-Specific    | Enables or disables Bash-specific features (`extglob`, `globstar`, etc.)



### Enabling Shell Options (`shopt`)
Using `shopt`, we can enable bash features.  

* `shopt -s <option>`: Enable (`-s`et) the given `<option>`.  
* `shopt -u <option>`: Disable (`-u`nset) the given `<option>`.  


Let's try using `**` to recursively list all files in current directories and subdirectories.  
```bash
ls **
```
This will show all directories and their contents, but only the first level.  
It won't go down through each one beyond the first level.  

Let's enable `globstar` and try again.  
```bash
shopt -s globstar
ls **
```
Do you notice a difference?  

There are a lot of these shell options.  
```bash
help shopt
man bash   # type '4512G' to go to line 4512, or type '/^SHELL BUILTIN' and scroll to 'shopt'
```


## Error Handling in Bash
Error handling in bash can be done with simple `if` statements.  

Since bash checks the [**exit code**](#true-and-false-with-exit-codes-in-bash) of a
program for conditionals, you can easily use this to handle cases where a program did
not exit with a `0` exit code.  
```bash
if ! curl -O https://example.com/file.txt; then
    printf "There was an error downloading the file!\n"
fi
```
* `if ! curl`: "If curl does *not* (`!`) exit with `0`".


## Formatting Data
* A neat trick for combining all elements of an array into, for instance, CSV:
  ```bash
  printf "%s," "$@"
  ```
    * This uses `printf` to print each element in the array individually, and use a
      comma each time an argument is printed.  


<!-- metacharacter -->
<!--       A character that, when unquoted, separates words.  One of the following: -->
<!--       |  & ; ( ) < > space tab newline -->
<!-- control operator -->
<!--       A token that performs a control function.  It is one of the following symbols: -->
<!--       || & && ; ;; ;& ;;& ( ) | |& <newline> -->

