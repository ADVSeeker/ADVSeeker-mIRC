ADV Seeker MRC 0.2 vartotojo instrukcija

    1. Reikalavimai
    2. Script'o idiegimas i mIRC klienta
    3. Naudojimas
     3.1 Boto konfiguravimas 
     3.2 Boto naudojimas
    4. Licenzija
    5. Apie
    6. Kontaktai
    7. Linkejimai

----------------------------------------------
  1. Reikalavimai
----------------------------------------------

mIRC klientas su 6.16 versija arba naujesne
jeigu naudojate senesni klienta, parsisiuskite
naujausia versija is http://mirc.com

----------------------------------------------
  2. Script'o idiegimas
----------------------------------------------

isarchyvuokit visus failus i mirc direktorija
ir mirc'e rasykite /load -rs adv.mrc

----------------------------------------------
  3.1 Boto konfiguravimas
----------------------------------------------

uzkrovus bota su vedlio pagalba galite 
minimaliai sukonfoguruoti bota, kad jis butu
paruostas darbui.
Taciau. jeigu vedlio pagalbos atsisakete
ji iskviesti galite su komanda /adv.wizard
jeigu norite rankiniu budu sukonfiguruot, tai
atsidarykite su betkokiu textiniu editorium 
adv.users.ini faila ir ten pagal save 
uzpildykite laukus. prie kuriu yra paaiskinimai
toliau pas bota iveskite komanda /adv.admin
ir sekite tolimesnius nurodymus, kuriu pagalba
susikursite botui pagrindini administratoriu.
Taipogi su /adv.admin galite sukurti daugiau
nei viena pagrindini administratoriu.

----------------------------------------------
 3.2 Naudojimas
----------------------------------------------

Komandos:
 * !adv setscantimes <kartai> - po kiek skanavimu is eiles ir neradus jokio reklamerio boto tame nicke, daugiau jo nebeskanuotu, jeigu norite isjungti sita dalyka, tai nustatykite reiksme 0 (!adv setscantimes 0)
 * !adv help - parasys i privata visas boto komandas
 * !adv listset - parodo boto nustatimus bei nedidelia boto statistika
 * !adv tempban <minutes> - nustato, po kiek laiko minutemis botas nuimtu bana, kuri pac botas ir uzdejo, jeigu norite sita dalyka isjungti, tada nustatykite reiksme 0 t.y. (!adv tempban 0)
 * !adv autoupdate <1/0> - ijungti, arba isjungti automatini atnaujinima
 * !adv onjoinscan <1/0> - ijungti, arba isjungti ateinanciu nicku skanavima
 * !adv update - paleisti boto atnaujinima
 * !adv setadvmsg <zinute...> - pakeisti zinute, su kuria isspirtu reklameri is kanalo
 * !adv setvirmsg <zinute...> - pakeisti zinute, kuria pranestu botas virusu apsikretusiu nicku
 * !adv servirchanmsg <zinute..> - Pakeist zinute, su kokia butu pranesama i kanala, kad nickas turi virusa.. naudokit zinuteje <nick> kad toje vietoje zinutes butu pakeista i virusuota nicka
 * !adv setenemymsg <zinute..> - Pakeisti zinute, su kuria butu ispirti vartotojai rasti priesu sarase be jokios jiem specelios zinutes
 * !adv msgvirchan <1/0> - Ijungti arba isjungti pranesimus i kanala apie virusuota asmeni
 * !adv addprotect <nickas> - prideti nicka prie saugomuju saraso *
 * !adv delprotect <nickas> - pasalinti nicka is saugomuju saraso *
 * !adv listprotect - parodys vartotojus, kurie yra saugomuju sarase
 * !adv protectops <1/0> - Ijungus botas neskanuos ir nespardys Op'u
 * !adv protectvoices <1/0> - Ijungus botas neskanuos ir nespardys Voice'u
 * !adv protecthalfops <1/0> - Ijungus botas neskanuos ir nespardys Halfop'u
 * !adv addadvword <zodis/fraze> - prideti raktazodi prie reklamos botu paieskos
 * !adv addvirword <zodis/fraze> - prideti raktazodi prie virusuoto asmens paieskos
 * !adv addadvtext <zodis/fraze> - prideti pilna teksta prie reklamerio boto paieskos
 * !adv addvirtext <zodis/fraze> - prideti pilna teksta prie virusuoto asmens paieskos
 * !adv listadvword - parodo visus reklamos botu atpazinimo raktazodzius ir ju numerius
 * !adv listadvtext - parodo visus reklamos botu atpazinimo pilnus sakinius ir ju numerius 
 * !adv listvirword - parodo visus virusu atpazinimo raktazodzius ir ju numerius
 * !adv listvirtext - parodo visus virusu atpazinimo pilnus sakinius ir ju numerius
 * !adv deladvword <numeris> - istrina reklamos botu atpazinimo raktazodi (kad suzinot numei, pasinaudokit komanda !adv listadvword)
 * !adv deladvtext <numeris> - istrina reklamos botu atpazinimo pilna sakini (kad suzinot numei, pasinaudokit komanda !adv listadvtext)
 * !adv delvirword <numeris> - istrina viruso atpazinimo raktazodi (kad suzinot numei, pasinaudokit komanda !adv listvirword)
 * !adv delvirtext <numeris> - istrina viruso atpazinimo pilna sakini (kad suzinot numei, pasinaudokit komanda !adv listvirtext)
 * !adv adduser <nickas> <slaptazodis> <ajmpwbe>** - prideti prie boto vartotoja ****
 * !adv deluser <nickas> - pasalinti  - pasalinti nicka is boto vartotoju saraso ****
 * !adv listusers - parodys visus vartotojus pas bota
 * !adv addop <nickas> <slaptazodis> - prideti boto operatoriu ***
 * !adv delop <nickas> - pasalinti boto operatoriu ***
 * !adv addenemy <nickas/maske> <isspyrimo zinute> - prideti prieso nicka arba maske i priesu sarasa (tai kazkas panasaus i akicka tik bote :])
 * !adv delenemy <numeris> - istrinti priesa is saraso, kad suzinot numeri, pasinaudokit !adv listenemy komanda
 * !adv listenemy - parodo visas maskes esancias priesu sarase bei ju numerius
 * !login <slaptazodis> - prisijnti prie boto
 * !logout - atsijungti nuo boto


* - nickai esantys siame sarase sarase nebus skanuojami, ar nera jie reklameriai, virusuoti nickai, ir pan.

** - teisiu flagu pagalba galite kiekvienam vartotojui duot atskiru komandu galiojima 
pvz norime, kad vartotojui galiotu komandos update ir setscantimes tada darome
!adv adduser nickas pass sa
jeigu kad visos komandos, iskyrus negaletu keist boto zinuciu tai !adv adduser nickas pass seajpwb
Komandu galiojimo flagai:
s - galimybe reguliuoti, po kiek praskanavimu nicko daugiau nebeskanuotu (setscantimes)
e - galimybe valdyti priesu sarasa (addenemy - delenemy - listenemy)
a - galimybe ijungti arba isjungti automatini atnaujinima, bei ji paleisti (autoupdate - update)
j - galimybe ijungti arba isjungti prisijungianciu vartotoju skanavima (onjoinscan)
m - galimybe keisti boto zinutes (setadvmsg - setvirmsg - ir t.t.)
p - galimybe prideti ir pasalinti vartotojus is saugomuju saraso, bei nustatyt, ka botas skanuotu, o ka ne (addprotect - delprotect - protectops - protectvoices - protecthalfops - listprotect)
w - galimybe prideti reklameriu bei virusu frazes bei zodzius, kuriuos aptikes botas elgtusi atitinkamai (addadvword - addvirword - addadvtext - addvirtext - listadvword - deladvword ir t.t. :)))
b - galimybe reguliuoti, po kiek laiko botas nuimtu banus, kuriuos pac botas ir yra uzdejas (tempban)
(teisiu flaguose didziosios raides nuo mazuju skiriasi!)

*** - prideti ir pasalinti boto operatorius gali tik pagrindinis administratorius, kuris buvo sukurtas idiegiant bota.. operatoriai turi visas teises iskyrus negali prideti, arba pasalinti kitu operatoriu.

**** - Siomis komandomis gali naudotis tik boto operatoriai ir administratorius



----------------------------------------------
  4. Licenzija
----------------------------------------------

Sis skriptukas platinamas pagal BSD licenzija, kuria galite perskaityti cia:
 http://www.opensource.org/licenses/bsd-license.php

----------------------------------------------
  5. Apie
----------------------------------------------

ADV Seeker MRC skriptas yra sukurtas naudojantis originaliojo ADV Seeker TCL 0.1 specifikacijomis, todel veikia
dauguma komandu, kurios yra pasiekiamos ir TCL versijai, abiems skriptams atnaujinimas ish duomenu bazes veikia
analogiskai, t.y. naudojama tapati duomenu baze. Skripto autoriai tikisi, kad shis skriptukas, pades daugeliui geriau 
apsiginti nuo ivairiausiu reklameriu. Gal net atsiras ivairiausiu modifikaciju, kurios dar labiau pades nelygioje kovoje
su reklameriais (tiesa nepamirekite atsizvelgti i licenzija!). :-)

----------------------------------------------
  6. Kontaktai
----------------------------------------------

  WWW: http://www.skycommunity.lt
  IRC: Vycka_xxx (MRC versija) & MekDrop (TCL versija/duombazes administravimas)

----------------------------------------------
  7. Linkejimai
----------------------------------------------

 sMatis uz bandymus sukurti kazka panasaus ir moraline parama :-)