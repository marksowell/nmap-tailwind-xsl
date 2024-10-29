# nmap-tailwind-xsl
An XSL stylesheet for rendering Nmap XML output with a modernized UI using Tailwind CSS and DataTables.

## Overview

`nmap-tailwind-xsl` provides a streamlined interface to view Nmap scan results in a browser with enhanced, mobile-responsive styling using [Tailwind CSS](https://tailwindcss.com) and interactive tables with [DataTables](https://datatables.net/).

### Features
- **Modern UI**: Styled with Tailwind CSS for a cleaner and more responsive layout.
- **Interactive Data**: Includes DataTables for easy sorting and pagination of Nmap scan results.
- **Scan Report**: Only displays hosts with open ports for a focused scan summary.
- **Clear Section Navigation**: Accessible navigation links for "Hosts" and "Services".
- **Dark Mode**: Toggle between light and dark mode comfortable viewing experience.

## Dependencies

This project uses the following versions specified in the XSL file:

| Dependency      | Version                                       |
|-----------------|-----------------------------------------------|
| **jQuery**      | v3.7.1 |
| **DataTables**  | v2.1.8 |
| **Tailwind CSS**| Latest via Tailwind Play CDN |


## Installation
Clone the Repository
```
git clone https://github.com/marksowell/nmap-tailwind-xsl.git
```

## Getting Started

1. Run an Nmap Scan With XML Output
   
   ```bash
   nmap -oX scan.xml [target]
   ```
> [!TIP]
> 
> **If you have multiple XML files you can combine them**
> 1. Install `xmlstarlet` (if not already installed)
>    
>    ```bash
>    sudo apt-get install xmlstarlet
>    ```
> 3. Create the Combined XML File
>    ```bash
>    echo '<?xml version="1.0" encoding="UTF-8"?>' > combined_nmap_output.xml
>    echo '<nmaprun>' >> combined_nmap_output.xml
>    ```
> 4. Extract and Append <host> Elements
>    ```bash
>    for file in *.xml; do
>    # Skip the combined output file
>    if [ "$file" != "combined_nmap_output.xml" ]; then
>        xmlstarlet sel -t -c "/nmaprun/host" "$file" >> combined_nmap_output.xml
>    fi
>    done
>    ```
> 5. Close the Root <nmaprun> Tag
>    ```bash
>    echo '</nmaprun>' >> combined_nmap_output.xml
>    ```
> 6. Use `xmllint` to Validate the Combined XML File
>    ```bash
>    xmllint combined_nmap_output.xml --noout
>    ```

2. Use the `nmap_tailwind_xsl.xsl` Stylesheet to Create a HTML Report Using `xsltproc`
   
   ```
   xsltproc -o scan_report.html ./nmap-tailwind.xsl combined_nmap_output.xml
   ```

## License

This project is licensed under the [Creative Commons BY-SA 4.0 License](https://creativecommons.org/licenses/by-sa/4.0/).

### Attribution
`nmap-tailwind-xsl` is inspired by the original work [`nmap-bootstrap-xsl`](https://github.com/honze-net/nmap-bootstrap-xsl) by Andreas Hontzia, which is also licensed under CC BY-SA 4.0. This project includes modifications to update the UI and functionality.
