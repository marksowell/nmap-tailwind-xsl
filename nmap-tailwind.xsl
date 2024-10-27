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
        <link rel="icon" href="data:image/svg+xml, %3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 28 28'%3E%3Ccircle cx='14' cy='14' r='13.9' fill='%231f2937' stroke='%23231f20' stroke-miterlimit='10' stroke-width='.1'/%3E%3Cpath fill='%23231f20' d='m20.5 17.5-13-.1'/%3E%3Cpath fill='none' stroke='%23fff' stroke-miterlimit='10' stroke-width='1.8' d='M20.5 17.5h-8.6'/%3E%3Cpath fill='%23fff' d='m12.8 14.4-5.3 3 5.3 3.1v-6.1z'/%3E%3Cpath fill='%23231f20' d='M7.5 10.5h13'/%3E%3Cpath fill='none' stroke='%23fff' stroke-miterlimit='10' stroke-width='1.8' d='M7.5 10.5h8.6'/%3E%3Cpath fill='%23fff' d='m15.2 13.6 5.3-3.1-5.3-3.1v6.2z'/%3E%3C/svg%3E" type="image/svg+xml"/>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.24/js/dataTables.tailwind.min.js"></script>
        <title>Scan Report<xsl:value-of select="/nmaprun/@version"/></title>
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
      <body class="bg-gray-100 text-gray-800">
        <nav class="bg-gray-800 text-white fixed w-full top-0 z-10 shadow-sm">
          <div class="container max-w-full px-10 py-3 flex justify-between items-center">
              <span class="text-3xl font-semibold">Scan Report</span>
              <div class="flex items-center space-x-6 ml-auto">
                <a href="#hosts" class="text-lg hover:text-gray-300">Hosts</a>
                <a href="#services" class="text-lg hover:text-gray-300">Services</a>
                <button id="darkModeToggle" class="ml-4 bg-gray-700 w-10 h-10 rounded-full flex items-center justify-center"><i id="darkModeIcon" class="fas fa-moon"></i></button>
              </div>
          </div>
        </nav>
        <div class="container max-w-full px-10">
          <h2 id="hosts" class="text-2xl font-semibold mb-2 text-gray-800 pt-20">Hosts</h2>
          <div id="shadow" class="max-w-full overflow-x-auto mb-6 rounded-md shadow-sm bg-white">
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
          <div class="max-w-full overflow-x-auto mb-6 rounded-md shadow-sm bg-white">
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
              },
              "lengthMenu": [ [10, 25, 50, 100, 1000, -1], [10, 25, 50, 100, 1000, "All"] ] 
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
                const shadows = Array.from(document.getElementsByClassName("shadow-sm"));
                shadows.forEach(element => element.classList.replace("shadow-sm", "shadow-none"));
              } else {
                icon.classList.replace("fa-sun", "fa-moon"); // Change back to moon icon
                const noShadows = Array.from(document.getElementsByClassName("shadow-none"));
                noShadows.forEach(element => element.classList.replace("shadow-none", "shadow-sm"));
              }
            });
          });
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
