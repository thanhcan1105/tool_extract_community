event entity @s gabrielaplok:fire

execute as @s[tag=!underground] run execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.m4a1.fire @a[r=200] ^^^0.10 100 1 0.01
execute as @s[tag=underground] run execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.m4a1.fire.reverb @a[r=200] ^^^0.10 100 1 0.01
execute as @s[tag=!underground] run execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.m4a1.fire_silenced @a[r=20] ^^^0.10 100 1 0.01
execute as @s[tag=underground] run execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.m4a1.fire_silenced.reverb @a[r=20] ^^^0.10 100 1 0.01

execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playanimation @s animation.m4a1.fire.silenced fire 0 "!q.is_item_name_any('slot.weapon.mainhand', 0, 'gabrielaplok:m4a1')"
execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playanimation @s animation.m4a1.fire fire 0 "!q.is_item_name_any('slot.weapon.mainhand', 0, 'gabrielaplok:m4a1')"

execute at @s unless entity @s[hasitem={item=gabrielaplok:foregrip, location=slot.inventory, slot=3}] run camerashake add @s[tag=sneaking] 0.02 0.2 rotational
execute at @s unless entity @s[hasitem={item=gabrielaplok:foregrip, location=slot.inventory, slot=3}] run camerashake add @s[tag=!sneaking] 0.04 0.2 rotational
execute at @s if entity @s[hasitem={item=gabrielaplok:foregrip, location=slot.inventory, slot=3}] run camerashake add @s[tag=sneaking] 0.01 0.1 rotational
execute at @s if entity @s[hasitem={item=gabrielaplok:foregrip, location=slot.inventory, slot=3}] run camerashake add @s[tag=!sneaking] 0.02 0.1 rotational

scoreboard players remove @s[scores={m4a1=1..}, m=!c] m4a1 1

function effect/muzzle_flash