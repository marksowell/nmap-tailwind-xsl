<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat"/>
  <xsl:template match="/">
    <html lang="en">
      <head>
        <meta name="referrer" content="no-referrer"/> 
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/jquery.dataTables.min.css" type="text/css"/>
        <link rel="stylesheet" href="https://cdn.datatables.net/1.10.24/css/dataTables.tailwind.css" type="text/css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" type="text/css"/>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.24/js/dataTables.tailwind.min.js"></script>
        <title>Scan Report Nmap <xsl:value-of select="/nmaprun/@version"/></title>
        <style>
          body.dark-mode {
            filter: invert(1) hue-rotate(180deg);
            background-color: #111;
          }
          body.dark-mode nav {
              filter: invert(1);
              background-color: #000;
          }
          body.dark-mode #darkModeToggle {
            background-color: #111;
          }
        </style>
      </head>
      <body class="bg-gray-100 text-gray-800 pt-16">
        <nav class="bg-gray-800 text-white fixed w-full top-0 z-10">
          <div class="container mx-auto px-4 py-2 flex justify-between items-center">
              <span class="text-2xl font-bold">Scan Report</span>
              <div class="flex items-center space-x-6 ml-auto">
                <a href="#hosts" class="text-lg hover:text-gray-300">Hosts</a>
                <a href="#services" class="text-lg hover:text-gray-300">Services</a>
                <button id="darkModeToggle" class="ml-4 bg-gray-700 w-10 h-10 rounded-full flex items-center justify-center"><i id="darkModeIcon" class="fas fa-moon"></i></button>
              </div>
          </div>
        </nav>
        <div class="container mx-auto px-4">
          <h2 id="hosts" class="text-2xl font-semibold mb-2 mt-4 text-gray-800">Hosts</h2>
          <div class="max-w-full overflow-x-auto mb-6 rounded-lg shadow-lg bg-white">
            <table id="table-overview" class="display w-full pt-2">
              <thead>
                <tr>
                  <th>Address</th>
                  <th>Hostname</th>
                  <th>TCP (open)</th>
                  <th>UDP (open)</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="/nmaprun/host[ports/port[state/@state='open']]">
                  <tr>
                    <td><xsl:value-of select="address/@addr"/></td>
                    <td><xsl:value-of select="hostnames/hostname/@name"/></td>
                    <td><xsl:value-of select="count(ports/port[state/@state='open' and @protocol='tcp'])"/></td>
                    <td><xsl:value-of select="count(ports/port[state/@state='open' and @protocol='udp'])"/></td>
                  </tr>
                </xsl:for-each>
              </tbody>
            </table>
          </div>
          <h2 id="services" class="text-2xl font-semibold mb-2 mt-4 text-gray-800">Services</h2>
          <div class="max-w-full overflow-x-auto mb-6 rounded-lg shadow-lg bg-white">
            <table id="table-services" class="display w-full pt-2">
              <thead>
                <tr>
                  <th>Address</th>
                  <th>Port</th>
                  <th>Protocol</th>
                  <th>Service</th>
                </tr>
              </thead>
              <tbody>
                <xsl:for-each select="/nmaprun/host">
                  <xsl:for-each select="ports/port[state/@state='open']">
                    <tr>
                      <td><xsl:value-of select="../../address/@addr"/></td>
                      <td><xsl:value-of select="@portid"/></td>
                      <td><xsl:value-of select="@protocol"/></td>
                      <td><xsl:value-of select="service/@name"/></td>
                    </tr>
                  </xsl:for-each>
                </xsl:for-each>
              </tbody>
            </table>
          </div>
        </div>
        <script>
          $(document).ready(function() {
            $('#table-overview, #table-services').DataTable({
              "initComplete": function(settings, json) {
                $(".dataTables_length").addClass("p-4");
                $(".dataTables_filter").addClass("p-4");
                $(".dataTables_info").addClass("p-4");
                $(".dataTables_paginate.paging_simple_numbers").addClass("pr-4");
              }
            });
          });
        </script>
        <script>
          document.addEventListener("DOMContentLoaded", function() {
            const toggleButton = document.getElementById("darkModeToggle");
            const icon = document.getElementById("darkModeIcon");
        
            toggleButton.addEventListener("click", function() {
              document.body.classList.toggle("dark-mode");
              if (document.body.classList.contains("dark-mode")) {
                icon.classList.replace("fa-moon", "fa-sun"); // Change to sun icon
              } else {
                icon.classList.replace("fa-sun", "fa-moon"); // Change back to moon icon
              }
            });
          });
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
