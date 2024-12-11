event entity @s gabrielaplok:fire

execute as @s[tag=!underground] run execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.awp.fire @a[r=400] ^^^0.10 100 1 0.01
execute as @s[tag=underground] run execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.awp.fire.reverb @a[r=400] ^^^0.10 100 1 0.01
execute as @s[tag=!underground] run execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.awp.fire_silenced @a[r=40] ^^^0.10 100 1 0.01
execute as @s[tag=underground] run execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playsound gun.awp.fire_silenced.reverb @a[r=40] ^^^0.10 100 1 0.01

execute at @s if entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playanimation @s animation.awp.fire.silenced fire 0 "!q.is_item_name_any('slot.weapon.mainhand', 0, 'gabrielaplok:awp')"
execute at @s unless entity @s[hasitem={item=gabrielaplok:silencer, location=slot.inventory, slot=2}] run playanimation @s animation.awp.fire fire 0 "!q.is_item_name_any('slot.weapon.mainhand', 0, 'gabrielaplok:awp')"

camerashake add @s[tag=sneaking] 0.06 0.2 rotational
camerashake add @s[tag=!sneaking] 0.08 0.2 rotational
camerashake add @s[tag=!sneaking] 0.08 0.2 positional

scoreboard players remove @s[scores={awp=1..}, m=!c] awp 1

function effect/muzzle_flash