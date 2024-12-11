/**
 * Hello, u're looking to steal my code, good luck!
 * If I were you I would at least ask permission before that,
 * I would be happy instead of you stealing my code and having to take drastic measures.
 * Well, thank you, Gabriel Aplok.
 *
 * It took me about 4-6 months to design all of this systems. ❤️
*/

import*as e from"@minecraft/server";let COMMANDS={"enable empty_mags":{command:"tag @s remove disable_empty_mags",message:"[+] You have enabled empty magazines, when the gun is out of ammo you receive an empty magazine in inventory."},"disable empty_mags":{command:"tag @s add disable_empty_mags",message:"[-] You have disabled empty magazines, when the gun is out of ammo you no longer receive an empty magazine in inventory."},settings:{command:"playsound random.pop @s"}};e.system.beforeEvents.watchdogTerminate.subscribe(e=>{e.cancel=!0}),e.world.beforeEvents.chatSend.subscribe(e=>{let{sender:a,message:s}=e;if(!s.startsWith("!"))return;e.cancel=!0;let n=s.substring(1);if(!(n in COMMANDS)){a.sendMessage(`\xa7c${n} is not a valid command`);return}let{command:m,message:t}=COMMANDS[n];m&&a.runCommandAsync(m),t&&a.sendMessage(`\xa7e${t}`)});