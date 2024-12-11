event entity @s gabrielaplok:fire

execute as @s[tag=!underground] run execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.desert_eagle.fire @a[r=200] ^^^0.10 100 1 0.01
execute as @s[tag=underground] run execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.desert_eagle.fire.reverb @a[r=200] ^^^0.10 100 1 0.01
execute as @s[tag=!underground] run execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.desert_eagle.fire_silenced @a[r=20] ^^^0.10 100 1 0.01
execute as @s[tag=underground] run execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.desert_eagle.fire_silenced.reverb @a[r=20] ^^^0.10 100 1 0.01

execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playanimation @s animation.desert_eagle.fire.silenced fire 0 "!q.is_item_name_any('slot.weapon.mainhand', 0, 'gabrielaplok:desert_eagle')"
execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playanimation @s animation.desert_eagle.fire fire 0 "!q.is_item_name_any('slot.weapon.mainhand', 0, 'gabrielaplok:desert_eagle')"

camerashake add @s[tag=sneaking] 0.06 0.2 rotational
camerashake add @s[tag=!sneaking] 0.08 0.2 rotational

scoreboard players remove @s[scores={desert_eagle=1..}, m=!c] desert_eagle 1

function effect/muzzle_flash