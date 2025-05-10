# Example Workflows

The [`.github/workflows`](../workflows) directory contains [`.github/workflows/CI_update_remote.yml` workflow](../workflows/CI_update_remote.yml), which listens for a specific command from the central Notepad++ repository, so that the plugintemplate can correctly keep certain files in sync with updates from Notepad++.  As a plugin author, that command will, unfortunately, not be sent to use (it's a resource-prohibitive procedure to notify _every_ plugin author, or even every plugin author who "subscribes", so it was decided to not be done).  That workflow is set to _not_ run when someone creates a repo based on this template.

Since that workflow won't work for you, feel free to delete [`.github/workflows/CI_update_remote.yml` workflow](../workflows/CI_update_remote.yml) -- though, since it won't run unless the repo matches `npp-plugins/plugintemplate` and it receives a message from the Notepad++ repo (which it won't), you don't actually have to do anything to stop it from running.

However, the good news is that, as a plugin author, you can use a _similar_ workflow to update those files in your plugin's repository, whether you want to do it on a schedule ("every month" or "every day"), or just on-demand (you can manually trigger it to check for updates), or both.  This directory contains an example of each of the three, and the sections below describe each one.  To use one of these examples, copy it into the [`.github/workflows`](../workflows) directory, and edit the file as described below to customize the behavior.

Do not run these workflows if you customize any of the files mentioned in the "Other details", because this workflow will overwrite those anytime they are different in your repository compared to the main repository, whether it's caused by an upstream edit or by a customization on your end.

## Scheduled Updates: `CI_update_remote_schedule.yml`

If you want to check for updates from the Notepad++ repository on a fixed schedule, you can copy `CI_update_remote_schedule.yml` to [`.github/workflows`](../workflows).

By default, it will check once per month, using the syntax
```
  # on schedule (using cron syntax)
  schedule:
    - cron: "0 0 1 * *" #< the first day of every month, at 00:00 UTC
```

The `cron: ...` line uses [crontab syntax](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html#tag_20_25_07), and here are a few examples:

```
    - cron: "0 0 1 * *" #< the first day of every month, at 00:00 UTC
    - cron: "0 0 * * *" #< every day at 00:00 UTC
    - cron: "23 13 1,15 * *" #< the first and fifteenth of every month, at 13:23 UTC
```
You can feel free to set it to whatever time and schedule you desire (keeping in mind that GitHub might not appreciate you running this multiple times per day (ignoring the fact that it would be pretty useless, since the files don't change very often)).  Really, once a month should be sufficient for scheduled updates.

## On-Demand Updates: `CI_update_remote_ondemand.yml`

If you only want to check for updates from the Notepad++ repository when you feel like it, you can copy `CI_update_remote_ondemand.yml` to [`.github/workflows`](../workflows). It doesn't need any editing to make it available.

To request the update, navigate to your repo's **Action** tab, select `CI_update_remote_ondemand`, and use the **Run workflow** button to run the workflow.

## Both: `CI_update_remote_both.yml`

If you want to check for updates from the Notepad++ repository on a fixed schedule or on demand, you can copy `CI_update_remote_both.yml` to [`.github/workflows`](../workflows).  You can customize the schedule as per the instructions above.

## Other details

By default, these actions check a specific list of files:
- `PluginInterface.h` and `Notepad_plus_msgs.h` and `menuCmdID.h` define the interface with the main Notepad++ application.
- `Docking.h` and `dockingResource.h` define extras needed when you want to have one or more of your windows dock with Notepad++.
- `Scintilla.h` and `Sci_Position.h` define the interface with the Scintilla library, so your plugin can send messages to the view1 and view2 editor panels.

If you want it to check other files, you can edit the `$pair` associative array to include the other files.  It is up to you to ensure that copying those files directly from the Notepad++ source code will be compatible with your plugin.  (You can feel free to edit the workflow, so if you want to automate some procedure to automatically apply edits compared to the file that you copy, that is your prerogative.)

The workflow copies the new files into your repository, builds them, and (if it builds okay), commits to your repository.  If there are errors during the build, you can look at the error messages to see where things went wrong.  (If you want to change the order, you could have it commit _before_ it builds, which makes sure you have the new files; then, if it fails, you could then debug your code to figure out why the new files are incompatible.  If you don't change the order, you could manually grab the files, and do your debug locally before committing both your changes and the new files.)

### Automatic Release

There is a minuscule chance that you might want this workflow to automatically create a GitHub release of your plugin.  Since we figured out the sequence for doing the plugintemplate release, that section is shared at the end of the workflow, but it's commented out.  Uncomment that section if you want the automatic-release feature.
