**Esx_Kashacters** - Edited To Have A Welcome Screen And Changelog, Released For Public Use :)

**Description**

My Version Edited By Me - Do What Ever You Wish :P

Adds A Welcome Screen And Loading Gif for Cool Effects ;)

**Requirements**
ESX

**INSTALLATION**

* Upload the SQL file that is included in the resource  `esx_kashacters.sql`  to your database (this is needed to know the last character a player was on.
* Comment out the  `NetworkIsSessionStarted`  loop in  *essentialmode\client\main.lua*  (you can comment out the whole Citizen.Createthread() )
* Put the  **esx_kashacters**  resource in your FiveM resource folder and edit in the  *esx_kashacters\server\main.lua*  file the first table at the top of your file to all the identifier columns and tables that are used for characters. Except user_lastcharacter
EXAMPLE:

```
local IdentifierTables = {
    {table = "users", column = "identifier"},
    {table = "owned_vehicles", column = "owner"},
    {table = "user_accounts", column = "identifier"},
}
```
**Video**
https://gyazo.com/756df04192135a047d7a031004894433

**Download**
 [Download](https://github.com/JonTronTheGreat/esx-kashacters-edited)

**Credits** 
To Kash For The Original Version - https://forum.fivem.net/t/release-esx-kashacters-multi-character/251613

To Onno For Helping Kash - https://forum.fivem.net/u/onno204/summary

Enjoy :)
