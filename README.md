# Performancer

This PowerShell script displays performance metrics such as CPU usage, memory usage, disk read and write rates, and network received and sent rates.

(Just a tiny script, I will update irregularly)

## Installation

To install this script, clone the repository and run the command below.
Make sure to change the path to the location where you cloned the repository.
```powershell
Import-Module .\Performancer.psd1
```

## Usage

To run the script, simply execute the following command in a PowerShell console:
```powershell
Show-Performance
```

The script will display a table with the current date and time, CPU usage, memory usage, disk read and write rates, network received and sent rates. The table will update every second to display the latest performance metrics.

A -Force option is reserved for future use.

### Note

* The script requires PowerShell version 5.0 or above.
* The script may not display all performance metrics on all systems.
* The script may not display the correct format for the date and time depending on the user's language and region settings. ( Although the script will always display the date and time in the format `MMM. dd, yyyy   HH:mm:ss` )
* Edit the config file `csv_path.cfg` to modify the path to save instant output.

## Contributing

If you have any suggestions or improvements for the script, please feel free to open an issue or pull request on the GitHub repository: <https://github.com/ForeverThawn/Performancer>

## License

This script is released under the GPL License. See the <LICENSE> file for more information.