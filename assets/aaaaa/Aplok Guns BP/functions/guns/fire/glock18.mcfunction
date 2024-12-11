event entity @s gabrielaplok:fire

execute as @s[tag=!underground] run execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.glock18.fire @a[r=200] ^^^0.10 100 1 0.01
execute as @s[tag=underground] run execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.glock18.fire.reverb @a[r=200] ^^^0.10 100 1 0.01
execute as @s[tag=!underground] run execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.glock18.fire_silenced @a[r=20] ^^^0.10 100 1 0.01
execute as @s[tag=underground] run execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.glock18.fire_silenced.reverb @a[r=20] ^^^0.10 100 1 0.01

execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playanimation @s animation.glock18.fire.silenced fire 0 "!q.is_item_name_any('slot.weapon.mainhand', 0, 'gabrielaplok:glock18')"
execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playanimation @s animation.glock18.fire fire 0 "!q.is_item_name_any('slot.weapon.mainhand', 0, 'gabrielaplok:glock18')"

camerashake add @s[tag=sneaking] 0.02 0.2 rotational
camerashake add @s[tag=!sneaking] 0.04 0.2 rotational

scoreboard players remove @s[scores={glock18=1..}, m=!c] glock18 1

function effect/muzzle_flash