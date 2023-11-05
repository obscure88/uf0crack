# uf0crack
A hash cracking tool that works with parallel programming.

![Ekran görüntüsü 2023-11-05 132653](https://github.com/thebunjo/uf0crack/assets/138582603/58acbf5d-ce0b-45ed-8cfa-7fbdd66745a5)

# Installation

sudo chmod +x install.sh && ./install.sh

# Project

Project Name: UF0Crack - Universal Hash Cracking Tool

Project Description:

UF0Crack is a versatile hash cracking tool designed to break hashed passwords using a given wordlist and hash algorithm. It provides a straightforward way to attempt password recovery by comparing hash values of known and potential passwords. UF0Crack supports a variety of hash algorithms and offers efficient parallel processing for faster results.

Key Features:

Multi-Algorithm Support: UF0Crack supports multiple hash algorithms, including MD5, SHA-1, SHA-2 (with various bit lengths), SHA-3, RIPEMD-160, and Whirlpool. You can choose the algorithm that matches the hashed password.

Parallel Processing: UF0Crack leverages parallel processing to split the wordlist into chunks and check for password matches concurrently. This speeds up the cracking process, especially when using a large wordlist.

Easy Configuration: The tool is user-friendly and provides options for specifying the path to the wordlist, the hash to crack, and the chosen hash algorithm.

Usage:

Choose a wordlist containing potential passwords.
Provide the hash to crack, which is typically obtained from the target system.
Select the appropriate hash algorithm used by the target system.
Run the UF0Crack tool, and it will attempt to match the hash with the passwords in the wordlist.
Sample Usage:

bash
Copy code
ruby uf0crack.rb -w wordlist.txt -h 5f4dcc3b5aa765d61d8327deb882cf99 -a md5
Notes:

UF0Crack aims to assist in legitimate scenarios such as password recovery and security assessments.
Always ensure you have the appropriate permissions before attempting to crack any hash.
This tool is created for educational and security testing purposes only.
Project Owner and GitHub Page:

Project Owner: Bunjo
GitHub Page: https://github.com/thebunjo
