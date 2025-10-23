## Weather Command (`weather.sh`)

A simple bash script to fetch and display the weather for a specified city directly in your terminal.

### Description

This command uses the `wttr.in` service to provide a quick, text-based weather forecast, including current conditions and a 3-day outlook.

### Dependencies

* `curl`: This script requires `curl` to be installed to make web requests.

### Usage

1.  Make the script executable:
    ```bash
    chmod +x weather.sh
    ```

2.  Run the script with a city name as an argument:
    ```bash
    ./weather.sh [city_name]
    ```

### Example

```bash
./weather.sh Satara