scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=0}] desert_eagle 10
clear @s[scores={desert_eagle=10}, hasitem={item=gabrielaplok:desert_eagle_mag, data=0}] gabrielaplok:desert_eagle_mag 0 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=1}] desert_eagle 9
clear @s[scores={desert_eagle=9}, hasitem={item=gabrielaplok:desert_eagle_mag, data=1}] gabrielaplok:desert_eagle_mag 1 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=2}] desert_eagle 8
clear @s[scores={desert_eagle=8}, hasitem={item=gabrielaplok:desert_eagle_mag, data=2}] gabrielaplok:desert_eagle_mag 2 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=3}] desert_eagle 7
clear @s[scores={desert_eagle=7}, hasitem={item=gabrielaplok:desert_eagle_mag, data=3}] gabrielaplok:desert_eagle_mag 3 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=4}] desert_eagle 6
clear @s[scores={desert_eagle=6}, hasitem={item=gabrielaplok:desert_eagle_mag, data=4}] gabrielaplok:desert_eagle_mag 4 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=5}] desert_eagle 5
clear @s[scores={desert_eagle=5}, hasitem={item=gabrielaplok:desert_eagle_mag, data=5}] gabrielaplok:desert_eagle_mag 5 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=6}] desert_eagle 4
clear @s[scores={desert_eagle=4}, hasitem={item=gabrielaplok:desert_eagle_mag, data=6}] gabrielaplok:desert_eagle_mag 6 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=7}] desert_eagle 3
clear @s[scores={desert_eagle=3}, hasitem={item=gabrielaplok:desert_eagle_mag, data=7}] gabrielaplok:desert_eagle_mag 7 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=8}] desert_eagle 2
clear @s[scores={desert_eagle=2}, hasitem={item=gabrielaplok:desert_eagle_mag, data=8}] gabrielaplok:desert_eagle_mag 8 1

scoreboard players set @s[hasitem={item=gabrielaplok:desert_eagle_mag, data=9}] desert_eagle 1
clear @s[scores={desert_eagle=1}, hasitem={item=gabrielaplok:desert_eagle_mag, data=9}] gabrielaplok:desert_eagle_mag 9 1

execute as @s[tag=!disable_empty_mags] run give @s[scores={desert_eagle=1..}] gabrielaplok:desert_eagle_mag 1 10