# simple-manpage-generator

Project Name: simple-manpage-generator
Project Description: A simple shell script creating a simple manpage from some information about your project (program name, program parameters, etc.)
Project License: MIT-License
Used Technology: Linux-Manpage-Files (roff-texts) and Unix-Shell-Scripts (sh not bash)

## Usage

To use this repository, you can either directly copy and edit the template.1-file for your own purposes or you can run the associated script with:

1. `chmod +x create-manpage.sh`
2. `./create-manpage.sh`

Then, after you have successfully created your manpage, you can either continue to edit the manpage in a text-editor orr you can preview it with...

`man -l [name of manpage-file.1]`

..., for example,...

`man -l mymanfile.1`

... and then you can continue to use the manpage-file for other purposes (like including it in a source-tree or deb-package).
