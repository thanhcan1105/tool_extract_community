playsound effect.gun.echo @a[r=200] ~~~ 100 1 0.01
playsound effect.player.blind @a[r=10] ~~~ 1 1 0.01
playsound effect.explosion.explode @a[r=50] ~~~ 100 1 0.01
playsound effect.explosion.debris @a[r=40] ~~~ 10 1 0.01
playsound effect.explosion.distant @a[rm=50, r=400] ~~~ 200 1 0.01

camerashake add @a[r=20] 0.25 0.35 rotational
camerashake add @a[r=20] 0.6 0.35 positional

execute as @s[tag=in_water] run particle gabrielaplok:explosion_water ~~~
execute as @s[tag=in_water] run playsound random.splash @a[r=60] ~~~ 1 1 0.01