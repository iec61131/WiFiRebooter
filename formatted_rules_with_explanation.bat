
;# improved example based on https://tasmota.github.io/docs/Rules/#watchdog-for-wi-fi-router-or-modem

;# Var1 => ping time interval in minutes ( default 1min)
;# Var2 => Counter for Google DNS (8.8.8.8) not reachable or wifi down
;# Var3 => last timestamp of outage caused by internet/ISP down
;# Var4 => inital boot up wait time for Wifi / modem to be ready or after forced wifi restart. Default 10min. (var4 >= var1)
;# Var5 => current interval time in minutes culculated at runtime ( default set to same value as var4)

;# set unix time to 2023/01/01 to allow timer mechanism to work for rules
;# hint:  https://world.hey.com/goekesmi/using-tasmota-without-a-network-a-post-preserved-from-the-past-303b26f0
Rule1 ON Power1#Boot Do Time 1672531201 ENDON

Rule2
ON Power1#Boot do backlog Var1 1; Var2 0; Var3 0; Var4 10; Var5 10; ENDON
ON Time#Minute|%Var5% DO backlog LedState 0; Var; Delay 100; Ping4 8.8.8.8; ENDON
ON Ping#8.8.8.8#Success==0 DO backlog Var5 %Var4%; Power1 0; Delay 40; Power1 1; Add2 1; Var3 %timestamp%; ENDON
ON Ping#8.8.8.8#Success>0 DO backlog LedState 1; Var5 %Var1%; ENDON
