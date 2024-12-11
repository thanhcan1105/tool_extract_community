execute as @a[tag=owner] run tag @a[tag=!owner] add member

tag @a[tag=!member] add owner
tag @a[tag=member] remove owner

execute as @a[tag=!setup_ag_v107] run function core/setup