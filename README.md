# Get-Rules & Groups v1.1 :recycle: :beginner:
* :diamond_shape_with_a_dot_inside: Dumps ALL ("Allow") **Firewall Rules** from Windows Defender Firewall with Advanced Security. 
* :diamond_shape_with_a_dot_inside: Reconverts them into applicables one through "netsh advfirewall firewall add rule".
* :diamond_shape_with_a_dot_inside: Will get dumped & converted in: %USERPROFILE%\Rules\FWCommands.txt
* :diamond_shape_with_a_dot_inside: Prompts user to open the dump/rules location, for analysis/learning/re-apply/backups.
* :open_file_folder: To-do: Add to extraction/conversion: Deny rules :no_entry:
* :warning: Packages in rules won't be applied/converted/extracted to rules (to-do)

![image](https://user-images.githubusercontent.com/91343617/147798910-7dc5afd3-d63a-435e-8d82-8338cd4a4e72.png)

## Instructions:

* __Right-click the script, run in PowerShell__ :repeat_one:

> Get-Rules Block :cinema:
> 1. Creates the Rules folder in %USERPROFILE%\Rules if not present
> 2. Dumps all "allowed" firewall rules into a textfile at %USERPROFILE%\Rules\FW-Rules.txt
> 3. Stock the rules into a variable from the file dumped (user can use custom file/path)
> 4. Parse each rules ending at '(?<=Action:                               Allow)'
> 5. Create a .txt of each rules at %USERPROFILE%\Rules\$i.txt
> 6. Increment until none left

![image](https://user-images.githubusercontent.com/91343617/147798014-032e47a0-d412-4a5f-b934-0e879ba99917.png)

> Conversion (Rules, Groups) :arrows_counterclockwise:
> 1. Gets the last item of the rules dumped, then starts the loop until last rule
> 2. Starting from rule #1, it'll extract all rule's parameters into variables
> 3. Then create a netsh command to re-enter it as needed, with rule's variables
> 4. Each set of variables creates a command which is added to a command file
> 5. Final textfile contains all commands ready to be applied, in the 'netsh' format.

![image](https://user-images.githubusercontent.com/91343617/147798717-e9763699-5f01-418d-80d6-535f6f6d69cc.png)
![image](https://user-images.githubusercontent.com/91343617/147798855-5a5e5030-85f0-4136-bd1b-32ca203a4445.png)
![image](https://user-images.githubusercontent.com/91343617/147798831-1544997e-0cff-47a4-a8b7-8fbb97f03e6a.png)

I created this dumper to easily re-create multiple rules I needed. Be sure to note the packages or you may be missing some stuff, lemme know if anything is wrong! 
With the "Export Policy" option, you can't select which to export/import, (like the predefined firewall rules) you have to overwrite the whole set :x:
