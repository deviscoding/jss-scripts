# JSS Scripts
This library contains a number of CLI scripts designed to work with Jamf, including Extension Attributes, installers, preference setters, uninstallers, and more.

## Dependencies

For convenience, some scripts may dependencies on the following tools:
- [JQ](https://github.com/stedolan/jq) (JSON)
- [YQ](https://github.com/mikefarah/yq) (YAML)
- [JSS Easy](https://github.com/deviscoding/jss-easy) (JSS Convenience Utility)  
- [MacPrefer](https://github.com/deviscoding/mac-prefer) (Docks, Preferences, Adobe Apps)
- [DockUtil](https://github.com/kcrawford/dockutil) (Mac Docks)

Any script that has a dependency not contained within macOS by default should indicate that dependency in a comment block at the top of the script.  Using scripts contained within this repo, it is fairly easy to set up policies for your systems to download and install these dependencies.

### Script Structure

To reduce the time investment in using these scripts, all scripts should follow the following basic structure:

1. A comment block indicating purpose, dependencies, source/author.
2. Input variables required for the script, each documented.
3. Other variables used within the script, each documented.
4. Any functions used within the script, each documented.
5. The runtime code of the script.

Additionally, scripts with similar functions should be named with the same naming conventions.  For instance, two scripts that both install something might be named _install-xxxxx.sh_.

Most scripts in this repo are bash scripts, however in a few cases where bash was not well suited for the task, PHP has been used.  My focus is on getting the job done, not on the language used.

### Script Templates
Some of the scripts contained within the repo are "templates" from which to create multiple scripts with similar purposes.  These scripts have an uppercase T at the end of their filename to distinguish them from ready-to-use scripts.

The changes needed in these scripts should be self-explanatory and documented with comments.

### Extension Attributes
The scripts that provide information to be used in Jamf Extension Attributes are located in the _attributes_ directory.  The output of these scripts is wrapped in a <result> tag for processing by Jamf's recon functionality.

In cases where the script should provide boolean-style information, they should return uppercase strings of **TRUE** or **FALSE**, properly wrapped in a <result> tag.

In cases where a system may or may not have a value, such as the version of an installed binary, the scripts should generally return the string **None**.

### Can you add...
The majority of the scripts in this repo are in day-to-day use in a Jamf managed macOS environment.  I am happy to take a look at adding requested features, if they seem like they might be useful within that environment.   You are also welcome to submit pull requests, and to fork this repo.


