on *:unban:#: { 
  if ($adv.chans(chans)) { 
    if ($istok($adv.chans,$chan,44) !== $true) { halt } 
  }  
  if ($timer(adv.rem.ban. $+ $chan $+ $bnick)) { .timeradv.rem.ban. $+ $chan $+ $bnick off }
}


on *:sockopen:adv.a: {
  sockwrite -n $sockname GET $mid($remove($adv.update.url,http://),$pos($remove($adv.update.url,http://),/,1))) HTTP/1.0
  sockwrite -n $sockname Host: $gettok($adv.update.url,2,47)
  sockwrite -n $sockname Connection: close
  sockwrite -n $sockname
}
on *:sockread:adv.a: {
  sockread %adv.u
  if ($istok($adv.commands,$gettok(%adv.u,1,32),32) == $true) {   
    if ($exists(" $+ $scriptdir $+ db\ $+") == $false) { mkdir " $+ $scriptdir $+ db $+ " } 
    if (setsection * iswm %adv.u) { set %section $replace($gettok(%adv.u,2,32),MaskStrings,BadWords) | halt }
    if (settype * iswm %adv.u) { set %type $gettok(%adv.u,2,32) | halt }
    if (writeini * iswm %adv.u) {
      if ($read($adv.ufile,wn,$remove(%adv.u,writeini $+ $chr(32))) == $null) { write $adv.ufile $remove(%adv.u,writeini) }
    }
    if (removeini * iswm %adv.u) { write -dw $+ $remove(%adv.u,removeini) $adv.ufile | halt }
    if (setupdateinterval * iswm %adv.u) && ($adv.aupdate == 1) { .timeradvupdate 1 $calc($gettok(%adv.u,2,32) * 60) adv.autoupdate | halt }
    if (setupdateurl * iswm %adv.u) { writeini -n $adv.rpl.file(config) config u.url $gettok(%adv.u,2,32) | halt }
  }
}
on *:sockclose:adv.a: { unset %section | unset %type | unset %adv.u }
on *:load: {
  adv.autoupdate
  if ($$?!="Sveiki, Aciu kad naudotistes ADV Seek MRC $crlf Sis vedlys jum pades lengviau sureguliuot scripta. $crlf jeigu norite sukonfiguruot scipta vedlio pagalba, spauskite YES jeigu ne, tada jums reiks rankiniu budu suvesti informacija i adv.users.ini faila" == $true) { adv.wizard }
}
on *:unload: { timeradv* off }
on !*:join:*: {
  if ($adv.chans(chans)) { 
    if ($istok($adv.chans,$chan,44) !== $true) { halt } 
  }  
  if ($adv.blacklist($fulladdress)) { adv.bans -a $chan $gettok($ifmatch,1,124) $nick $gettok($ifmatch,2,124) | halt }
  if ($timer(adv.notscan. $+ $nick $+ $chan)) || ($adv.onjoinscan == 0) || ($adv.protect($nick) == $true) { halt }
  adv.j.scan -i

  if ($read(" $+ $scriptdir $+ db\adv_proxy_Hosts.ini",w,$gettok($fulladdress,2,64))) { 
    var %x $numtok($adv.chans,44)
    var %y 1
    while (%x >= %y) {
      if ($nick ison $gettok($adv.chans,%y,44)) && ($me isop $gettok($adv.chans,%y,44)) { adv.bans -a $gettok($adv.chans,%y,44) $nick }
      inc %y
    }   
    halt
  } 
  .timeradv.notscan. $+ $nick $+ $chan 1 60 return
  write " $+ $scriptdir $+ adv.join.tmp" $nick
  if (!%adv.join.queoe) { set %adv.join.queoe 1 | adv.scan }
}
alias adv.scan { whois $read(" $+ $scriptdiradv.join.tmp",1) }
;311 ident ip vardas
raw 311:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { adv.scan.words w $3- | haltdef } }
;319 kanalai
raw 319:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { haltdef } }
;312 serveris
raw 312:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { haltdef } }
;307 identified with ns
raw 307:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { haltdef } }
;275 using ssl
raw 275:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { haltdef } }
;301 afk
raw 301:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { adv.scan.words w $3- | haltdef } }
;317 idle
raw 317:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { haltdef } }
;313 IRC OP
raw 313:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { haltdef } }
;401 nepamenu :)
raw 401:*: { if (%adv.join.queoe) && ($read(" $+ $scriptdir $+ adv.join.tmp",1) == $2) { haltdef } }
;318 end of whois
raw 318:*: { 
  if (%adv.join.queoe == 1) {
    if (!%adv.found) && (!%vir.found) { adv.inc.notscan $read(" $+ $scriptdir $+ adv.join.tmp",1) }
    if (%adv.found) { 
      var %x $numtok($adv.chans,44)
      var %y 1
      while (%x >= %y) {   
        if ($2 ison $gettok($adv.chans,%y,44)) && ($me isop $gettok($adv.chans,%y,44)) { adv.bans -a $gettok($adv.chans,%y,44) $2 }
        inc %y
      }   
    } 
    unset %adv.found 
    if (%vir.found) { .notice $2 $adv.vir.msg | unset %vir.found }
    write -dl1 " $+ $scriptdir $+ adv.join.tmp"
    if ($lines(" $+ $scriptdir $+ adv.join.tmp") > 0) { adv.scan }
    else { unset %adv.join.queoe } 
    haltdef
  }
  haltdef
}
on *:open:?:*: {
  if ($adv.protect($nick) !== $true) {
    write " $+ $scriptdir $+ adv.join.tmp" $nick
    adv.scan.words m $1- 
    if (!%adv.join.queoe) { set %adv.join.queoe 1 | adv.scan }
  }
}

on *:connect: { 
  if ($ini($adv.rpl.file(userfile),users,0) == 0) { echo -a Nerasta jokiu useriu bote, prasome sukurti administratoriaus logina pasinaudojus komanda /adv.admin | quit | halt } 
  $iif($adv.aupdate == 1,adv.autoupdate,) 
  remini -n $adv.rpl.file(userfile) loged 
  unset %adv.join.queoe
}
on *:start: { adv.delnot.scan }
on ^*:text:?adv *:*: {
  if ($mid($1,1,1) != !) && ($mid($1,1,1) != .) { halt } 
  if ($adv.users(loged,$nick) == $true) { 
    if ($2 == setscantimes) && (s isincs $adv.users(access,$nick)) && ($$3 isnum) &&  ($3 >= 0) { writeini -n $adv.rpl.file(config) config notscan $3 | notice $nick $iif($3 == 0,nicku nebskanavimas po pasirinkto skanavimo kiekio ir neaptikos virusu ar reklamos scriptu isjungtas,nicku nebskanavimas po pasirinkto skanavimo kiekio ir neaptikos virusu ar reklamos scriptu nustatyta $+ $chr(44) kad nebeskanuotu po $3 skanavimu) | haltdef }
    if ($2 == tempban) && (b isincs $adv.users(access,$nick)) && ($$3 isnum) &&  ($3 >= 0) { writeini -n $adv.rpl.file(config) config ban.time $3 | .notice $nick $iif($3 = 0,automatinis bano nuemimas isjungtas,bano nuemimo laiko tarpas pakeistas i $3 minut[es/ciu]) }
    if ($2 == autoupdate) && (a isincs $adv.users(access,$nick)) && ($3 == 1) || ($3 == 0) && ($2 == autoupdate) && (a isincs $adv.users(access,$nick)) { writeini -n $adv.rpl.file(config) config autoupdate $3 | .timeradvupdate $iif($3 == 0,off,1 $calc(240 * 60) adv.autoupdate) | .notice $nick automatinis atnaujinimas $iif($3 == 1,ijungtas,isjungtas) }
    if ($2 == onjoinscan) && (j isincs $adv.users(access,$nick)) && ($$3 == 1) || ($3 == 0) && ($2 == onjoinscan) && (j isincs $adv.users(access,$nick)) { writeini -n $adv.rpl.file(config) config onjoinscan $3 | .notice $nick prisijungianciu i kanala nicku skanavimas $iif($3 == 1,ijungtas,isjungtas) }
    if ($2 == update) && (a isincs $adv.users(access,$nick)) { adv.autoupdate | .notice $nick boto atnaujinimas paleistas }
    if ($2 == setadvmsg) && (m isincs $adv.users(access,$nick))  { writeini -n $adv.rpl.file(config) config adv.msg $$3- | .notice $nick Reklamerio isspyrimo zinute pakeista i: $3- }
    if ($2 == setvirmsg) && (m isincs $adv.users(access,$nick))  { writeini -n $adv.rpl.file(config) config vir.msg $$3- | .notice $nick Apie viruso pranesimo zinute pakeista i: $3- } 
    if ($2 == setvirchanmsg) && (m isincs $adv.users(access,$nick)) { writeini -n $adv.rpl.file(config) config vir.ch.msg $$3- | .notice $nick Pranesimo apie virusa i kanala zinute pakeista i $adv.virch.msg(<Virusuotas_nickas>)  }
    if ($2 == msgvirchan) && (m isincs $adv.users(access,$nick))  && ($3 == 1) || ($3 == 0) && ($2 == setvirchanmsg) && (m isincs $adv.users(access,$nick)) { writeini -n $adv.rpl.file(config) config msg.vir.ch $$3 | notice $nick Pranesimas i kanala apie virusa $iif($3 == 1,ijungtas,isjungtas)  }
    if ($2 == setenemymsg) && (m isincs $adv.users(access,$nick)) { writeini -n $adv.rpl.file(config) config enemy.msg $$3- | .notice $nick Ispyrimo zinute, kai isspiriamas nickas uz tai, kad jis enemyliste pakeista i: $3-   }  
    if ($2 == protectops) && (p isincs $adv.users(access,$nick))  && ($3 == 1) || ($3 == 0) && ($2 == protectops) && (p isincs $adv.users(access,$nick)) { writeini -n $adv.rpl.file(config) config protect.ops $$3 | notice $nick op'u neskanavimas $iif($3 == 1,ijungtas,isjungtas)  }
    if ($2 == protectvoices) && (p isincs $adv.users(access,$nick)) && ($3 == 1) || ($3 == 0) && ($2 == protectvoices) && (p isincs $adv.users(access,$nick)) { writeini -n $adv.rpl.file(config) config protect.voices $$3 | notice $nick voice'u neskanavimas $iif($3 == 1,ijungtas,isjungtas) }
    if ($2 == protecthalfops) && (p isincs $adv.users(access,$nick)) && ($3 == 1) || ($3 == 0) && ($2 == protecthalfops) && (p isincs $adv.users(access,$nick)) { writeini -n $adv.rpl.file(config) config protect.halfops $$3 | notice $nick halfop'u neskanavimas $iif($3 == 1,ijungtas,isjungtas) }
    if ($2 == addprotect) && (p isincs $adv.users(access,$nick)) { 
      if (!$readini($adv.rpl.file(userfile),protect,$$3)) { writeini -n $adv.rpl.file(userfile) protect $$3 protect | .notice $nick $$3 idetas saugomuju sarasa..  }
      else { .notice $nick $$3 jau yra saugomuju sarase }
    }
    if ($2 == delprotect) && (p isincs $adv.users(access,$nick)) { 
      if ($readini($adv.rpl.file(userfile),protect,$$3)) { remini -n $adv.rpl.file(userfile) protect $$3 | .notice $nick $$3 pasalintas is saugomuju saraso  } 
      else { .notice $nick $$3 nerastas saugomuju sarase  }
    }
    if ($2 == listprotect) && (p isincs $adv.users(access,$nick)) { adv.play.users -p }
    if ($2 == listadvword) && (w isincs $adv.users(access,$nick)) { adv.play.db advword Reklamos botu atpazinimo raktazodziu }
    if ($2 == listvirword) && (w isincs $adv.users(access,$nick)) { adv.play.db virword Virusu atpazinimo raktazodziu }
    if ($2 == listadvtext) && (w isincs $adv.users(access,$nick)) { adv.play.db advtext Reklamos botu atpazinimo pilnu sakiniu }
    if ($2 == listvirtext) && (w isincs $adv.users(access,$nick)) { adv.play.db virtext Virusu atpazinimo pilnu sakiniu }
    if ($2 == deladvword) && (w isincs $adv.users(access,$nick)) { adv.del.db advword $$3 }
    if ($2 == deladvtext) && (w isincs $adv.users(access,$nick)) { adv.del.db advtext $$3 }
    if ($2 == delvirword) && (w isincs $adv.users(access,$nick)) { adv.del.db virword $$3 }
    if ($2 == delvirtext) && (w isincs $adv.users(access,$nick)) { adv.del.db virtext $$3 }
    if ($2 == addadvword) && (w isincs $adv.users(access,$nick)) { write " $+ $scriptdir $+ db\adv_adv_BadWords.ini" $$3- | .notice $nick zodis $+([,$3-,]) pridetas  }
    if ($2 == addvirword) && (w isincs $adv.users(access,$nick)) { write " $+ $scriptdir $+ db\adv_vir_BadWords.ini" $$3- | .notice $nick zodis $+([,$3-,]) pridetas }
    if ($2 == addadvtext) && (w isincs $adv.users(access,$nick)) { write " $+ $scriptdir $+ db\adv_adv_fullstrings.ini" $$3- | .notice $nick stringas $3- pridetas  }
    if ($2 == addvirtext) && (w isincs $adv.users(access,$nick)) { write " $+ $scriptdir $+ db\adv_vir_fullstrings.ini" $$3- | .notice $nick stringas $3- pridetas  } 
    if ($2 == deluser) && (u isincs $adv.users(access,$nick)) { if ($adv.users(isadmin,$3) == $true) || (($adv.users(isop,$3) == $true)) { .notice $nick klaida istrinant vartojoja: Neturite tam teisiu }
      elseif ($adv.users(isuser,$3) == $true) { remini -n $adv.rpl.file(userfile) users $3 | .notice $nick vartotojas $3 istrintas } 
      else { .notice $nick Toks vartotojas nerastas }
    } 
    if ($2 == adduser) && (u isincs $adv.users(access,$nick)) { 
      if ($adv.users(isadmin,$3) == $true) || (($adv.users(isop,$3) == $true)) { .notice $nick Klaida pridedant vartojoja } 
      elseif ($len($removecs($$5,j,a,m,w,p,b,e,s)) == 0) { writeini -n $adv.rpl.file(userfile) users $3 $md5($4) $+ $chr(124) $+ $5 | .notice $nick Vartotojas $3 sekmingai pridetas  }
      else { .notice $nick rasta nezinomu teisiu flagu, prasome pasitikrinti parasyta komanda ir meginti vel $+([,nezinomi flagai: $removecs($$5,j,a,m,w,p,b,e,s),]) }
    }
    if ($2 == listusers) { if ($adv.users(isadmin,$nick) == $true) || (($adv.users(isop,$nick) == $true)) { adv.play.users -u } }   
    if ($2 == addop) {
      if ($adv.users(isadmin,$nick) == $true) && ($3 != $nick) { writeini -n $adv.rpl.file(userfile) users $3 $md5($$4) $+ $chr(124) $+ o | .notice $nick boto operatorius pridetas }  
      else { .notice $nick klaida pridedant operaturiu, pasitikrinkite komanda ir isitikinkite, kad turite tam reikiamas teises } 
    }
    if ($2 == delop) { 
      if ($adv.users(isadmin,$nick) == $true) && ($3 != $nick) { 
        if ($adv.users(isop,$3) == $true) { remini -n $adv.rpl.file(userfile) users $$3 | .notice $nick operatorius $3 istrintas }
        else { .notice $nick operatorius nerastas, arba sis zmogus nera operatorius }    
      }
      else { .notice $nick klaida istrinant operaturiu, pasitikrinkite komanda ir isitikinkite, kad turite tam reikiamas teises  | haltdef  }      
      haltdef   
    }

    if ($2 == help) { .play $nick commands.txt 1500 }  
    if ($2 == listset) { adv.list.settings | haltdef }
    if ($2 == addenemy) && (e isincs $adv.users(access,$nick)) { write $iif($chr(33) !isin $$3," $+ $scriptdir $+ db\adv_blacklist_masks.ini" $3 $+ !*@*," $+ $scriptdir $+ db\adv_blacklist_masks.ini" $3) $+ $chr(124) $+ $4- | .notice $nick priesas pridetas su maske $+([,$iif($chr(33) !isin $$3,$3 $+ !*@*,$3),]) }
    if ($2 == listenemy) && (e isincs $adv.users(access,$nick)) { adv.play.db enemylist Priesu }
    if ($2 == delenemy) && (e isincs $adv.users(access,$nick)) { adv.del.db enemylist $$3  }
    haltdef 
  }
}


on !*:nick: { 
  if ($adv.users(loged,$nick) == $true) { 
    remini -n $adv.rpl.file(userfile) loged $nick
  }
  if ($adv.blacklist($address($newnick,5))) { 
    var %mask $ifmatch     
    var %x $numtok($adv.chans,44)
    var %y 1
    while (%x >= %y) {  
      if ($newnick ison $gettok($adv.chans,%y,44)) && ($me isop $gettok($adv.chans,%y,44)) { adv.bans -a $gettok($adv.chans,%y,44) $gettok(%mask,1,124) $newnick $gettok(%mask,2,124) }
      inc %y
    }   
  }
}
on ^*:text:?login *:?: {
  if ($mid($1,1,1) != !) && ($mid($1,1,1) != .) { halt }
  if ($adv.users(loged,$nick) == $true) { halt }  
  if ($adv.users(login,$nick,$$2) == $true ) {
    writeini -n $adv.rpl.file(userfile) loged $nick logedin
    .notice $nick jus sekmingai prisijungete prie boto valdymo sistemos, jeigu nezinote boto komandu, rasykite !adv help
    haltdef
  }
}
on ^*:text:?logout:*: { 
  if ($mid($1,1,1) != !) && ($mid($1,1,1) != .) { halt }
  if ($adv.users(loged,$nick) == $true) { remini -n $adv.rpl.file(userfile) loged $nick | .notice $nick jus sekmingai atsijungete nuo sistemos | haltdef
  }
}

on !*:part:*: {
  if ($adv.users(loged,$nick) == $true) { remini -n $adv.rpl.file(userfile) loged $nick } 
  if ($adv.chans(chans)) { 
    if ($istok($adv.chans,$chan,44) !== $true) { halt } 
  } 
  if ($adv.protect($nick) !== $true) { adv.scan.words p $1- }
}
on !*:quit: {
  if ($adv.users(loged,$nick) == $true) { remini -n $adv.rpl.file(userfile) loged $nick }
  if ($adv.chans(chans)) { 
    if ($istok($adv.chans,$chan,44) !== $true) { halt } 
  } 
  if ($adv.protect($nick) !== $true) { adv.scan.words q $1- }
}
on !*:kick:*: {
  if ($adv.users(loged,$knick) == $true) { remini -n $adv.rpl.file(userfile) loged $knick }
}
on *:text:*:*: {
  if ($adv.chans(chans)) && ($chan) { 
    if ($istok($adv.chans,$chan,44) !== $true) { halt } 
  } 
  if ($adv.protect($nick) !== $true) { adv.scan.words m $1- }
}
on *:action:*:*: {
  if ($adv.chans(chans)) && ($chan) { 
    if ($istok($adv.chans,$chan,44) !== $true) { halt }
  }
  if ($adv.protect($nick) !== $true) { adv.scan.words m $1- }
}
on *:notice:*:*: {
  if ($adv.chans(chans)) && ($chan) { 
    if ($istok($adv.chans,$chan,44) !== $true) { halt } 
  }  
  if ($adv.protect($nick) !== $true) { adv.scan.words m $1- }
}
;--------------------------------------------------------------------------------------------------
alias adv.enemy.msg { return $readini($adv.rpl.file(config),config,enemy.msg) }
alias adv.virch.msg { return $replace($readini($adv.rpl.file(config),config,vir.ch.msg),<nick>,$1) }
alias adv.virch { return $iif($readini($adv.rpl.file(config),config,msg.vir.ch),$ifmatch,0) }
alias adv.users { 
  if ($1 == loged) { if ($readini($adv.rpl.file(userfile),loged,$2)) { return $true }  
  else { return $false }  }
  if ($1 == access) { if ($gettok($readini($adv.rpl.file(userfile),users,$2),2,124) == o) { return jamwpbeus }
  else { return $gettok($readini($adv.rpl.file(userfile),users,$2),2,124) } }
  if ($1 == isadmin) { if ($gettok($readini($adv.rpl.file(userfile),users,$2),2,124) === O) { return $true }
  else { return $false } } 
  if ($1 == login) { if ($md5($3) == $gettok($readini($adv.rpl.file(userfile),users,$2),1,124)) { return $true } 
  else { return $false } }
  if ($1 == isuser) { if ($readini($adv.rpl.file(userfile),users,$2)) { return $true }
  else { return $false } }
  if ($1 == isop) { if ($gettok($readini($adv.rpl.file(userfile),users,$2),2,124) === o) { return $true }
  else { return $false } }
}
alias adv.play.users {
  .timerplay.users* off
  if ($1 == -u) {
    set %adv.users $ini($adv.rpl.file(userfile),users,0)
    var %x 1
    .msg $nick Useris :: Teises  
    while (%adv.users >= %x) {
      set %adv.user $ini($adv.rpl.file(userfile),users,%x)
      set %adv.access $adv.users(access,%adv.user)
      $iif($adv.users(isop,%adv.user) == $true, set %adv.access Operatorius)
      $iif($adv.users(isadmin,%adv.user) == $true, set %adv.access Administratorius)
      .timerplay.users. $+ $nick $+ . $+ %x 1 $calc(%x * 2) .msg $nick %adv.user :: %adv.access
      inc %x
    }
    .timerplay.users. $+ $nick $+ .end 1 $calc(%x * 2 + 2) .msg $nick --Useriu saraso pabaiga--
  }
  if ($1 == -p) { 
    set %adv.users $ini($adv.rpl.file(userfile),protect,0)
    var %x 1
    .msg $nick Saugomuju vartotoju sarasas
    while (%adv.users >= %x) {
      .timerplay.users $+ %x 1 $calc(%x * 2) .msg $nick $ini($adv.rpl.file(userfile),protect,%x)
      inc %x 
    }
    timerplay.users.end 1 $calc(%x * 2 + 2) .msg $nick --Saugomuju vartotoju saraso pabaiga--
  }
  haltdef
  unset %adv.users
  unset %adv.user
  unset %adv.access
}
alias adv.protect {
  if ($adv.not.scan($1) == $true) || ($adv.users(loged,$1) == $true) { return $true }  
  if (!$chan) { goto skipprotecchan }  
  if ($readini($adv.rpl.file(config),config,protect.ops) == 1) && ($1 isop $chan) { return $true }
  if ($readini($adv.rpl.file(config),config,protect.voices) == 1) && ($1 isvoice $chan) { return $true }
  if ($readini($adv.rpl.file(config),config,protect.halfops) == 1) && ($1 ishop $chan) { return $true }  
  :skipprotecchan  
  if (!$2) { goto skipcchan }
  if ($readini($adv.rpl.file(config),config,protect.ops) == 1) && ($1 isop $2) { return $true }
  if ($readini($adv.rpl.file(config),config,protect.voices) == 1) && ($1 isvoice $2) { return $true }
  if ($readini($adv.rpl.file(config),config,protect.halfops) == 1) && ($1 ishop $2) { return $true }  
  :skipcchan  
  if ($readini($adv.rpl.file(userfile),protect,$1)) { return $true }
  else { return $false }
}

alias adv.admin { 
  ;  if ($ini($adv.rpl.file(userfile),users,0) !== 0) { echo -a Pagrindinis administratorius jau yra sukurtas! | halt }
  var %admin $$?="Ivesk dabar nicka pagrindinio administratoriaus, kuris tures auksciausias teises bote"
  :pass
  var %pass $$?*="Ivesk slaptazodi kurio reix norint adminui %admin prisijungti prie boto"
  var %pass2 $$?*="Pakartok slaptazodi"
  if (%pass === %pass2) { writeini -n $adv.rpl.file(userfile) users %admin $md5(%pass) $+ $chr(124) $+ O | echo -a Administratorius nicku %admin sukurtas }
  else { echo -a slaptazodziai neatitinka, prasome ivesti is naujo! | goto pass }
}
alias -l adv.list.settings {
  var %x $findfile(" $+ $scriptdir $+ db\",*.*,0)
  var %y 1
  var %z 0

  while (%x >= %y) { 
    set %file $findfile(" $+ $scriptdir $+ db\",*.*, %y )   
    var %a $file(%file).size
    var %z $calc( %a + %z ) 
    inc %y 
  }
  unset %file 
  var %p.ops $iif($adv.protect.ops == $true,Ijungtas,Isjungtas)
  var %p.voices $iif($adv.protect.voices == $true,Ijungtas,Isjungtas)
  var %p.halfops $iif($adv.protect.halfops == $true,Ijungtas,Isjungtas)
  .msg $nick Automatinis atnaujinimas yra  $+ $iif($adv.aupdate == 1,ijungtas,isjungtas) $+  :: Ateinanciu nicku skanavimas yra  $+ $iif($adv.onjoinscan == 1,ijungtas,isjungtas) $+  :: $iif($adv.ban.time !== 0,Automatinio bano nuemimas yra nustatytas $+ $chr(44) kad banas bus nuimtas po $calc($adv.ban.time / 60) minuciu,Automatinis banu nuemimas yra isjungtas)
  .timer 1 1 .msg $nick Op'u Neskanavimas yra %p.ops :: Voice'u neskanavimas yra %p.voices :: Halfop'u neskanavimas yra %p.halfops
  .timer 1 2 .msg $nick reklamos botu isspyrimo zinute yra: $adv.adv.msg
  .timer 1 3 .msg $nick Virusuotu asmenu perspejimo zinute yra: $adv.vir.msg
  .timer 1 4 .msg $nick Pranesimo i kanala apie virusuota asmeni zinute yra tokia: $adv.virch.msg(<virusuotas_nickas>)  
  .timer 1 5 .msg $nick Zmogus rastas priesu sarase bus ispirtas su sia zinute: $adv.enemy.msg
  .timer 1 6 .msg $nick $iif(!$adv.chans(chans),Botas stebi visus kanalus,Botas stebi tik siuos kanalus:  $+ $replace($adv.chans(chans),$chr(44),$chr(32)) $+ ) :: boto duomenu baze uzima  $+ $round($calc(%z / 1024),3) $+ KB :: Botas jau praskanavo vartotojus  $+ $adv.j.scan $+  kartu(-us), bei isspyre  $+ $adv.k.scan $+  vartotoju(-us)
  .timer 1 7 .msg $nick Is visu praskanuotu vartotoju $round($adv.calc.pr($adv.scan.stats(s),$adv.scan.stats(k)),0) $+ % vartotoju buvo atpazinti, kaip reklamos botai
  if ($readini($adv.rpl.file(config),config,notscan) !== 0) && ($readini($adv.rpl.file(config),config,notscan)) { .timer 1 8 .msg $nick Botas nustatytas, kad po $readini($adv.rpl.file(config),config,notscan) vartotojo skanavimu is eiles, ir neradus reklamerio boto, sis vartotojas daugiau nebebutu skanuojamas }
  .timer 1 9 .msg $nick apie virusu uzsikretusi asmeni botas i kanala $iif($adv.virch == 1,pranesa,nepranesa)
}
alias adv.blacklist { 
  adv.scan.stats -s $gettok($$1,1,33) 
  var %x $lines(" $+ $scriptdir $+ db\adv_blacklist_masks.ini")
  var %y 1
  while (%x >= %y) {
    if ($gettok($read(" $+ $scriptdir $+ db\adv_blacklist_masks.ini",%y),1,124) iswm $$1) { adv.scan.stats -k $gettok($$1,1,33) | return $read(" $+ $scriptdir $+ db\adv_blacklist_masks.ini",%y) }
    inc %y
  }
  return 
}
alias adv.rpl.file { 
  if ($1 == advword) { return " $+ $scriptdir $+ db\adv_adv_BadWords.ini" }
  if ($1 == advtext) { return " $+ $scriptdir $+ db\adv_adv_fullstrings.ini" }
  if ($1 == virword) { return " $+ $scriptdir $+ db\adv_vir_BadWords.ini" }
  if ($1 == virtext) { return " $+ $scriptdir $+ db\adv_vir_fullstrings.ini" }
  if ($1 == enemylist) { return " $+ $scriptdir $+ db\adv_blacklist_masks.ini" }
  if ($1 == userfile) { return " $+ $scriptdir $+ db\adv_users.ini" } 
  if ($1 == config) { return " $+ $scriptdir $+ adv.config.ini" }
  if ($1 == stats) { return " $+ $scriptdir $+ db\adv_stats_scaned.ini" }
}
alias -l adv.del.db { 
  var %section $1 
  var %line $2
  if (%line < 1) || (%line > $lines($adv.rpl.file(%section))) { notice $nick Toks numeris nerastas | halt }
  notice $nick $iif(%section !== enemylist,$read($adv.rpl.file(%section),n,%line),$gettok($read($adv.rpl.file(%section),n,%line),1,124)) istrinta is duomenu bazes
  write -dl $+ %line $adv.rpl.file(%section)
  haltdef
}
alias -l adv.play.db {
  .timeradv.db.list* off    
  var %x $lines($adv.rpl.file($1))
  var %y 1
  msg $nick ---------- $+ $2- sarasas----------
  while (%x >= %y) { .timeradv.db.list $+ $nick $+ %y 1 $calc(%y * 2) msg $nick  $+ %y $+  -  $iif($1 != enemylist,$ $+ read( $+ $adv.rpl.file($1) $+ ,n, $+ %y $+ ),$gettok($read($adv.rpl.file($1),n,%y),1,124) $iif($gettok($read($adv.rpl.file($1),n,%y),2,124), -- $ifmatch,) ) | inc %y }
  .timeradv.db.list $+ $nick $+ %y 1 $calc(%y * 2) msg $nick ---------- $+ $2- saraso pabaiga----------
  haltdef    
}
alias adv.protect.ops { return $iif($readini($adv.rpl.file(config),config,protect.ops) == 1,$true,$false) }
alias adv.protect.voices { return $iif($readini($adv.rpl.file(config),config,protect.voices) == 1,$true,$false) }
alias adv.protect.halfops { return $iif($readini($adv.rpl.file(config),config,protect.halfops) == 1,$true,$false) }
alias adv.calc.pr { 
  var %y $$1
  var %z $$2
  return $calc(%z * 100 / %y)
}

alias adv.scan.stats {
  if ($1 == -s) { writeini -n $adv.rpl.file(stats) scan $2 1 }
  if ($1 == -k) { writeini -n $adv.rpl.file(stats) kick $2 1 }
  if ($1 == s) { return $ini($adv.rpl.file(stats),scan,0) }
  if ($1 == k) { return $ini($adv.rpl.file(stats),kick,0) }
}
alias adv.inc.notscan { 
  if ($readini($adv.rpl.file(config),config,notscan) == 0) || (svecias??????? iswm $1) { return }
  var %times $gettok($readini($adv.rpl.file(userfile),scan_times,$1),1,124) 
  if ($2 == null) { remini -n $adv.rpl.file(userfile) scan_times $1 }
  else { writeini -n $adv.rpl.file(userfile) scan_times $1 $calc(%times + 1) $+ $chr(124) $+ $ctime }
}
alias adv.not.scan {
  var %limit $readini($adv.rpl.file(config),config,notscan)
  if (%limit == 0) || (!%limit) { return $false }  
  if ($readini($adv.rpl.file(userfile),scan_times,$1)) {
    var %x $gettok($readini($adv.rpl.file(userfile),scan_times,$1),1,124)
    writeini -n $adv.rpl.file(userfile) scan_times $1 %x $+ $chr(124) $+ $ctime
  } 
  if (%x >= %limit) { return $true } 
  else { return $false }
}
alias adv.delnot.scan { 
  echo -a ADV - Ieskoma duomenu bazeje vartotoju, kurie nepasirode ilgiau, nei 30 dienu...  :: isviso duomenu bazeje rasta $ini($adv.rpl.file(userfile),scan_times,0) Vartotoju
  var %time $ctime
  var %x $ini($adv.rpl.file(userfile),scan_times,0)
  var %y 1
  while (%x >= %y) {
    if ($calc($ctime - $gettok($readini($adv.rpl.file(userfile),scan_times,$ini($adv.rpl.file(userfile),scan_times,%y)),2,124)) > 2419200) { write adv.rem.tmp $ini($adv.rpl.file(userfile),scan_times,%y) }
    inc %y 
  }
  var %x $lines(adv.rem.tmp)
  var %y 1
  while (%x >= %y) {
    remini -n $adv.rpl.file(userfile) scan_times $read(adv.rem.tmp,%y)
    inc %y
  }
  .remove adv.rem.tmp
  echo ADV - Paieska baigta, rasta %x vartotoju, paieska truko $duration($calc($ctime - %time))
}
alias adv.j.scan {
  if ($1 == -i) { writeini -n $adv.rpl.file(config) counter s.nicks $calc($readini($adv.rpl.file(config),counter,s.nicks) + 1) }
  else { return $readini($adv.rpl.file(config),counter,s.nicks) }
}

alias adv.k.scan {
  if ($1 == -i) { writeini -n $adv.rpl.file(config) counter k.count $calc($readini($adv.rpl.file(config),counter,k.count) + 1) }
  else { return $readini($adv.rpl.file(config),counter,k.count) }
}
alias adv.ban.time { 
  if (!$readini($adv.rpl.file(config),config,ban.time)) { return 0 }
  else { return $calc($readini($adv.rpl.file(config),config,ban.time) * 60) }
}
alias adv.bans { 
  if ($1 == -a) { 
    mode $2 +b $3
    if ($4) { adv.inc.notscan $4 null }
    else { adv.inc.notscan $iif($chr(33) !isin $3,$3,$gettok($3,1,33)) null }
    if ($iif($chr(33) !isin $3,$3,$gettok($3,1,33)) ison $2) || ($4 ison $2) {
      adv.k.scan -i
      if ($4) { adv.scan.stats -k $4 | kick $2 $4 $iif(!$5,$adv.adv.msg,$5-) $+(<,$adv.k.scan,>) }
      else { adv.scan.stats -k $iif($chr(33) !isin $3,$3,$gettok($3,1,33)) | kick $2 $iif($chr(33) !isin $3,$3,$gettok($3,1,33)) $iif(!$5,$adv.adv.msg,$5-) $+(<,$adv.k.scan,>) }
    }
    if ($adv.ban.time != 0) { .timeradv.rem.ban. $+ $2 $+ $3 1 $adv.ban.time adv.bans -r $2 $3 }
  }
  if ($1 == -r) { mode $2 -b $3 }
}
;#--adv.setup disabled until gui is created--#
;alias adv.setup { dialog -m adv.setup adv.setup }

alias adv.aupdate { return $readini($adv.rpl.file(config),config,autoupdate) }
alias adv.onjoinscan { return $readini($adv.rpl.file(config),config,onjoinscan) }
alias adv.update.url { return $readini($adv.rpl.file(config),config,u.url) }
alias adv.chans { if ($1 = chans) { return $readini($adv.rpl.file(config),config,chans) } 
  elseif ($readini($adv.rpl.file(config),config,chans)) { return $readini($adv.rpl.file(config),config,chans) }
  else {
    var %x $chan(0)
    var %y 1
    while (%x >= %y) { var %z %z $+ $chan(%y) $+ $chr(44) | inc %y }
    return %z
  }
}
alias adv.ufile { return $+(",$scriptdir,db\adv_,%type,_,%section,.ini,") }
alias adv.vir.msg { return $readini($adv.rpl.file(config),config,vir.msg) }
alias adv.adv.msg { return $readini($adv.rpl.file(config),config,adv.msg) }
alias adv.commands { return setsection settype writeini removeini setupdateinterval setupdateurl }
alias adv.autoupdate { sockopen adv.a $gettok($adv.update.url,2,47) 80 }
alias adv.wizard { 
  var %admin $$?="Ivesk dabar nicka pagrindinio administratoriaus, kuris tures auksciausias teises bote"
  :pass
  var %pass $$?*="Ivesk slaptazodi kurio reix norint adminui %admin prisijungti prie boto"
  var %pass2 $$?*="Pakartok slaptazodi"
  if (%pass === %pass2) { writeini -n $adv.rpl.file(userfile) users %admin $md5(%pass) $+ $chr(124) $+ O | echo -a Administratorius nicku %admin sukurtas, judam toliau.. }
  else { echo -a slaptazodziai neatitinka, prasome ivesti is naujo! | goto pass }
  :chans
  var %chans $?="Dabar iveskite kanalus, kuriuose noresite, kad veiktu botas. Kanalus atskirkite kableliais pvz: #kanalas1,#kanalas2,#kanalas3 ir t.t. Jeigu norite, kad botas veiktu visuose kanaluose, palikite si laukeli tuscia"
  if ($chr(32) isin %chans) { echo -a klaida ivedinejant kanalus, pakartokite! | goto chans }
  else { writeini -n $adv.rpl.file(config) config chans %chans | echo -a Kanalai sekmingai irasyti: $replace(%chans,$chr(44),$chr(32))  }
  echo -a Stai tiek, pagrindiniai dalykai sukonfiguruoti, visa kita gali sukonfiguruot pasiskaites readme.txt faila, taip pat jame bus parasyta visos boto komandos, ir kaip naudotis
}
alias adv.scan.words { 
  if ($2- == $null) { return }  
  var %word $strip($2-)
  if ($1 == m) && (#?* #?* iswm $2-) {
    if ($count($2-,$gettok($2,1,32)) >= 5) { 
      set %adv.found 1 
      goto skipvir
    }
  }
  if ($chan) && ($1 == m) { goto skipchan }
  var %x 1 
  while ($lines(" $+ $scriptdir $+ db\adv_adv_BadWords.ini") >= %x) {
    if (* $+ $read(" $+ $scriptdir $+ db\adv_adv_BadWords.ini",n,%x) $+ * iswm %word) { set %adv.found 1 }
    inc %x
  }
  var %x 1
  while ($lines(" $+ $scriptdir $+ db\adv_adv_fullstrings.ini") >= %x) {
    if ($read(" $+ $scriptdir $+ db\adv_adv_fullstrings.ini",n,%x) == %word) { set %adv.found 1 }
    inc %x
  } 
  :skipchan
  var %x 1
  if ($timer(adv.vir.notscan. $+ $nick)) { goto skipvir }
  while ($lines(" $+ $scriptdir $+ db\adv_vir_BadWords.ini") >= %x) {
    if (* $+ $read(" $+ $scriptdir $+ db\adv_vir_BadWords.ini",n,%x) $+ * iswm %word) { set %vir.found 1 }
    inc %x
  }
  var %x 1
  while ($lines(" $+ $scriptdir $+ db\adv_vir_fullstrings.ini") >= %x) {
    if ($read(" $+ $scriptdir $+ db\adv_vir_fullstrings.ini",n,%x) == %word) { set %vir.found 1 }
    inc %x
  }
  if (%vir.found) { .timeradv.vir.notscan. $+ $nick 1 60 return }
  :skipvir
  if ($1 == w) { adv.scan.stats -s $read(adv.join.tmp,1) }
  else { adv.scan.stats -s $nick }
  if ($1 == p) {
    if (%adv.found) { 
      if ($me isop $chan) { 
        adv.bans -a $chan $nick
      } 
      unset %adv.found 
    }
    if (%vir.found) { .notice $nick $adv.vir.msg | unset %vir.found }
  }
  if ($1 == q) {
    if (%vir.found) { unset %vir.found }
    if (%adv.found) { 
      unset %adv.found
      var %y 1
      while ($numtok($adv.chans,44) >= %y) { adv.bans -a $gettok($adv.chans,%y,44) $nick | inc %y }
    }
  }
  if ($1 == m) {
    if (%vir.found) { .notice $nick $adv.vir.msg | adv.mass.msg $nick $adv.virch.msg($nick) | unset %vir.found }
    if (%adv.found) { 
      var %x $numtok($adv.chans,44)
      var %y 1
      while (%x >= %y) {  
        if ($nick ison $gettok($adv.chans,%y,44)) && ($me isop $gettok($adv.chans,%y,44)) { adv.bans -a $gettok($adv.chans,%y,44) $nick }
        inc %y
        unset %adv.found   
      }
    }
  }
}
alias adv.mass.msg {
  adv.inc.notscan $1 null
  if ($adv.virch == 0) { return }
  var %nick $1
  var %msg $2-
  var %x = $numtok($adv.chans,44)
  var %y 1
  var %time 1
  while (%x >= %y) {
    if (%nick ison $gettok($adv.chans,%y,44)) && ($me ison $gettok($adv.chans,%y,44)) { .timer 1 %time msg $gettok($adv.chans,%y,44) %msg | inc %time }
    inc %y
  }
}
