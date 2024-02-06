{
 Description: Berechnung der benötigten Astronauten und Raketen für die Mondmission
 Date: 06-11-2023
}

program ueb02;

{$APPTYPE CONSOLE}

{$R+,Q+,X-}

uses
  System.Math;

const
  ROCKET_SEATS = 6;
  COUNTRY1 = 'Allgerien';
  COUNTRY2 = 'Bootswana';
  COUNTRY3 = 'Moongolien';

var
 astronautsC1 : byte;
 astronautsC2 : byte;
 astronautsC3 : byte;

 isAdditionalRocketNeeded : Boolean;
 totalRockets : byte;

 totalAstronauts : byte;
 isLastRocketFull : Boolean;
 astronautsInLastRocket : byte;

 maxAstronauts : byte;
 minAstronauts : byte;

 haveMostAstronautsC1 : Boolean;
 haveMostAstronautsC2 : Boolean;
 haveMostAstronautsC3 : Boolean;

 haveLeastAstronautsC1 : Boolean;
 haveLeastAstronautsC2 : Boolean;
 haveLeastAstronautsC3 : Boolean;

 isOneAstronautPerCountry : Boolean;
 hasOneCountryMostAstronauts: Boolean;

begin
   //INPUT
   write('Wie viele Astronauten kommen aus ', COUNTRY1, '? ');
   readln(astronautsC1);
   write('Wie viele Astronauten kommen aus ', COUNTRY2, '? ');
   readln(astronautsC2);
   write('Wie viele Astronauten kommen aus ', COUNTRY3, '? ');
   readln(astronautsC3);

   //PROCESSING
   totalAstronauts := astronautsC1 + astronautsC2 + astronautsC3;

   isAdditionalRocketNeeded := (totalAstronauts mod ROCKET_SEATS) > 0;

   totalRockets := totalAstronauts div ROCKET_SEATS + byte(isAdditionalRocketNeeded);

   isLastRocketFull := Boolean(byte(totalAstronauts <> 0)* byte(totalAstronauts mod ROCKET_SEATS = 0));

   astronautsInLastRocket := byte(isLastRocketFull) * ROCKET_SEATS;

   astronautsInLastRocket := astronautsInLastRocket + totalAstronauts mod ROCKET_SEATS;


   maxAstronauts := max(astronautsC1, max(astronautsC2, astronautsC3));
   minAstronauts := min(astronautsC1, min(astronautsC2, astronautsC3));


   haveMostAstronautsC1 := astronautsC1 = maxAstronauts;
   haveMostAstronautsC2 := astronautsC2 = maxAstronauts;
   haveMostAstronautsC3 := astronautsC3 = maxAstronauts;

   haveLeastAstronautsC1 := astronautsC1 = minAstronauts;
   haveLeastAstronautsC2 := astronautsC2 = minAstronauts;
   haveLeastAstronautsC3 := astronautsC3 = minAstronauts;

   isOneAstronautPerCountry := astronautsC1 * astronautsC2 * astronautsC3 <> 0;

   hasOneCountryMostAstronauts := totalAstronauts - maxAstronauts - minAstronauts <> maxAstronauts;



   //OUTPUT
   writeln;
   writeln('Es werden insgesamt ', totalRockets, ' Raketen der Größe ', ROCKET_SEATS, ' benötigt.');
   writeln;
   writeln('In der letzten Rakete sitzt/sitzen ', astronautsInLastRocket, ' Astronaut.');
   writeln;
   writeln('Insgesamt ist/sind ', totalAstronauts, ' Astronaute(en) vorhanden.');
   writeln;
   writeln('Die maximale Anzahl aus einem Land ist ', maxAstronauts, ', die minimale ist ', minAstronauts);
   writeln;
   writeln(COUNTRY1, ' hat die meisten Astronauten: ', haveMostAstronautsC1);
   writeln(COUNTRY2, ' hat die meisten Astronauten: ', haveMostAstronautsC2);
   writeln(COUNTRY3, ' hat die meisten Astronauten: ', haveMostAstronautsC3);
   writeln(COUNTRY1, ' hat die wenigsten Astronauten: ', haveLeastAstronautsC1);
   writeln(COUNTRY2, ' hat die wenigsten Astronauten: ', haveLeastAstronautsC2);
   writeln(COUNTRY3, ' hat die wenigsten Astronauten: ', haveLeastAstronautsC3);
   writeln;
   writeln('Aus jedem Land ist mindestens ein Astronaut vorhanden: ', isOneAstronautPerCountry);
   writeln('Es gibt eindeutig ein Land mit den meisten Astronauten: ', hasOneCountryMostAstronauts);
   readln



end.
