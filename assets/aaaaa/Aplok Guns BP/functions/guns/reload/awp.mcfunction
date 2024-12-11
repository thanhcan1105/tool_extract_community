scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=0}] awp 10
clear @s[scores={awp=10}, hasitem={item=gabrielaplok:awp_mag, data=0}] gabrielaplok:awp_mag 0 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=1}] awp 9
clear @s[scores={awp=9}, hasitem={item=gabrielaplok:awp_mag, data=1}] gabrielaplok:awp_mag 1 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=2}] awp 8
clear @s[scores={awp=8}, hasitem={item=gabrielaplok:awp_mag, data=2}] gabrielaplok:awp_mag 2 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=3}] awp 7
clear @s[scores={awp=7}, hasitem={item=gabrielaplok:awp_mag, data=3}] gabrielaplok:awp_mag 3 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=4}] awp 6
clear @s[scores={awp=6}, hasitem={item=gabrielaplok:awp_mag, data=4}] gabrielaplok:awp_mag 4 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=5}] awp 5
clear @s[scores={awp=5}, hasitem={item=gabrielaplok:awp_mag, data=5}] gabrielaplok:awp_mag 5 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=6}] awp 4
clear @s[scores={awp=4}, hasitem={item=gabrielaplok:awp_mag, data=6}] gabrielaplok:awp_mag 6 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=7}] awp 3
clear @s[scores={awp=3}, hasitem={item=gabrielaplok:awp_mag, data=7}] gabrielaplok:awp_mag 7 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=8}] awp 2
clear @s[scores={awp=2}, hasitem={item=gabrielaplok:awp_mag, data=8}] gabrielaplok:awp_mag 8 1

scoreboard players set @s[hasitem={item=gabrielaplok:awp_mag, data=9}] awp 1
clear @s[scores={awp=1}, hasitem={item=gabrielaplok:awp_mag, data=9}] gabrielaplok:awp_mag 9 1

execute as @s[tag=!disable_empty_mags] run give @s[scores={awp=1..}] gabrielaplok:awp_mag 1 10