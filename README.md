# Smart WiFi Restarting Unit

<div style="background-color: #228B22; color: white; padding: 10px; border-radius: 5px; margin-bottom: 15px;">
  <strong>Verified with Tasmota Version:</strong> 13.2.0.3(tasmota-4M)
</div>

This guide will walk you through creating a Smart WiFi Restarting Unit using a Tasmota-supported smart plug, specifically the Sonoff S31. This project is based on the Tasmota firmware and involves some hardware modifications using a soldering iron. Ensure you have the necessary physical resources listed below before starting.

## Physical Resources Required:

1. Tasmota-supported smart plug (e.g., [Sonoff S31](https://a.co/d/egYRv0p))
2. Soldering iron
3. USB-to-UART converter with 3.3V (e.g., [USB-to-UART Converter](https://a.co/d/6l37PIg))

## Software Resources:

- [Tasmota Firmware](https://ota.tasmota.com/tasmota/)
- [Using Tasmota without a network](https://world.hey.com/goekesmi/using-tasmota-without-a-network-a-post-preserved-from-the-past-303b26f0)

## Installation Steps:

1. **Flash Tasmota Firmware:**
   - Follow the official Tasmota firmware flashing instructions provided [here](https://ota.tasmota.com/tasmota/).
   - Connect the USB-to-UART converter to the Sonoff S31 for firmware flashing.

2. **Hardware Modifications:**
   - Open the Sonoff S31 casing. [instructions](https://tasmota.github.io/docs/devices/Sonoff-S31/)
   - Identify and solder necessary connections according to the instructions in the [Tasmota documentation](https://ota.tasmota.com/tasmota/).
   - Exercise caution when soldering to avoid damage.

3. **Configuration:**
   - Once flashed, power up the Sonoff S31.
   - Connect to the default Tasmota WiFi network using the provided documentation.
   - Access the Tasmota WebUI (default IP: 192.168.4.1) to configure WiFi credentials.

4. **Modifications:**
   - upload the `autoexec.bat` file to the GUI via `Consoles` -> `Manage File System`
   - go to terminal via `Consoles` -> `Console` and add execute *line-by-line*:
   - Check out the [formatted_rules_with_explanation.bat](formatted_rules_with_explanation.bat) file for pre-configured rules and explanations.
   - ```bash
     Rule1 ON Power1#Boot Do Time 1672531201 ENDON
     Rule2 ON Power1#Boot do backlog Var1 1; Var2 0; Var3 0; Var4 10; Var5 10; ENDON ON Time#Minute|%Var5% DO backlog LedState 0; Var; Delay 100; Ping4 8.8.8.8; ENDON ON Ping#8.8.8.8#Success==0 DO backlog Var5 %Var4%; Power1 0; Delay 40; Power1 1; Add2 1; Var3 %timestamp%; ENDON ON Ping#8.8.8.8#Success>0 DO backlog LedState 1; Var5 %Var1%; ENDON
     ```
   - Hard reboot via power-on / power-off device

## Frequently Asked Questions (FAQ):

**1. How to Change WiFi Credentials:**

   1.1 **Using WebUI:**
   - If still connected to the current network, access the Tasmota WebUI by entering the Sonoff S31 IP address in a web browser.
   - Navigate to the "Configuration" tab and update the WiFi credentials.

   1.2 **Using Sonoff Button:**
   - To force Tasmota into hostapd mode, press and hold the Sonoff button for >40 seconds.
   - Once in hostapd mode, connect any device to the unprotected SSID "tasmota-*."
   - Access the Tasmota configuration interface through the connected device to change WiFi credentials.

**2. Why not using the recommended rule in the docs?**
   
2.1 **Missing unix time**
- after reboot of a modem/router no NTP is possible
- The rules are dependent on Rule1, which sets the initial Unix time. Ensure that Rule1 is executed before other rules to establish the correct time reference.

2.2 **reset config disable**
- with latest tasmato release, regular reboots within <10sec can lead to disable rules. Fixed in `autoexec.bat`

2.3 **Missing ramp-up time reboots modem/router too early** 
- A ramp-up time of, for example, 10 minutes is missing in the rules. Adding a delay or ramp-up time is essential to allow the modem/router to fully restart before subsequent commands are executed. Adjust the timing in the rules to accommodate the restart time of your specific modem/router.

2.4. **Variable init**
- Without an active Wifi ( which is not available upon restart) the triggers needs to be `Power1#Boot` instead of `system#boot`
- see [discussion](https://github.com/arendst/Tasmota/issues/9026#issuecomment-668879510)

**3. Additional Information:**
   - For more detailed information, troubleshooting, and advanced configurations, refer to the [Tasmota Documentation](https://ota.tasmota.com/tasmota/).

**Note:** This guide assumes a basic understanding of soldering and familiarity with the Tasmota firmware. Always follow safety precautions and guidelines provided by the hardware and firmware documentation.
