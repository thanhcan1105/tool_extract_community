execute as @s[tag=owner] run function core/score

playsound random.pop @s

gamerule recipesunlock false
gamerule sendcommandfeedback false

scoreboard players set @s ak47 30
scoreboard players set @s awp 10
scoreboard players set @s desert_eagle 10
scoreboard players set @s fnfal 20
scoreboard players set @s glock17 17
scoreboard players set @s glock18 17
scoreboard players set @s m4a1 30
scoreboard players set @s mossberg 6
scoreboard players set @s mp5a5 30

tellraw @s {"rawtext":[{"translate":"game.message.welcome_1"}]}
tellraw @s {"rawtext":[{"translate":"game.message.welcome_2"}]}
tellraw @s {"rawtext":[{"translate":"game.message.welcome_3"}]}
tellraw @s {"rawtext":[{"translate":"game.message.welcome_4"}]}
tellraw @s {"rawtext":[{"translate":"game.message.welcome_5"}]}
tellraw @s {"rawtext":[{"translate":"game.message.welcome_6"}]}

tag @s remove underground
tag @s remove sneaking
tag @s remove setup_ag_v100
tag @s remove setup_ag_v101
tag @s remove setup_ag_v102
tag @s remove setup_ag_v103
tag @s remove setup_ag_v104
tag @s remove setup_ag_v105
tag @s remove setup_ag_v106
tag @s add setup_ag_v107