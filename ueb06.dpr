program ueb06;
(*
  @Description: A program, which test utility functions and procedures
  @date 04-12-2023
*)

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses
  System.SysUtils,
  Windows;

const
  COLOR_BLUE = 3;
  COLOR_RED = 12;
  COLOR_TEAL = 11;
  COLOR_GREEN = 10;
  COLOR_WHITE = 7;

  // Sets the consoles text colour
  // @param color color value
procedure setTextColor(color: word);
begin
  if SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color) then;
end;

// PrintStat Procedure
// Prints out stats about the input parameter string
//@param
//s - String of which the stats will be printed out
procedure printStat(s: string);
var
  upperCaseCounter: byte;
  lowerCaseCounter: byte;
  digitCounter: byte;

  Iterator: byte;

begin
  digitCounter := 0;
  lowerCaseCounter := 0;
  upperCaseCounter := 0;

  for Iterator := 1 to length(s) do
  begin
    case s[Iterator] of
      '0' .. '9':
        inc(digitCounter);
      'a' .. 'z':
        inc(lowerCaseCounter);
      'A' .. 'Z':
        inc(upperCaseCounter);
    end;
  end;

  writeln('s: "', s, '" Gro�: ', upperCaseCounter, ' Klein: ', lowerCaseCounter,
    ' Ziffern: ', digitCounter);
end;

(* Replace-Digits Function *)

// Helper-Function
// Returns the string value of a digit from 0 (zero) to 9 (nine)
//@param
//digit - the digit that is to be written out into a string
function digitToWord(digit: char): string;
begin
  case digit of
    '0':
      digitToWord := 'null';
    '1':
      digitToWord := 'eins';
    '2':
      digitToWord := 'zwei';
    '3':
      digitToWord := 'drei';
    '4':
      digitToWord := 'vier';
    '5':
      digitToWord := 'f�nf';
    '6':
      digitToWord := 'sechs';
    '7':
      digitToWord := 'sieben';
    '8':
      digitToWord := 'acht';
    '9':
      digitToWord := 'neun';
  end;
end;

// Main-Function
// Iterates through a string
// Checks whether the string contains a number
// If it is a number, on the index before the number, the string from the helper function is placed
// then the original number is deleted
//@param
//s - string of which the numbers are to be replaced
//@return
//  string where any digits are written out
function replaceDigits(s: string): string;
var
  result: string;
  Iterator: byte;

begin
  result := '';

  for Iterator := 1 to length(s) do
  begin
    case s[Iterator] of
      '0' .. '9':
        begin
          if (Iterator = 1) or (s[Iterator - 1] = ' ') then
          begin
            result := result + upcase(digitToWord(s[Iterator])[1]);
            result := result + copy(digitToWord(s[Iterator]), 2,
              length(digitToWord(s[Iterator])))
          end
          else
            result := result + digitToWord(s[Iterator]);
        end;
    else
      result := result + s[Iterator];
    end;
  end;

  replaceDigits := result;
end;

(* Delete-Digits Function *)
//Function that removes any digits that are in the given range and counts the deletions
//@params
//s - The string of which the digits are to be deleted
//digits - the range of digits that should be deleted from s
//@out
//count - the count of deleted digits
//@return
//  The string in which every digit in the input range was deleted
function deleteDigits(s, digits: string; var count: byte): string;
var
  Iterator: byte;
  index: byte;

begin
  count := 0;
  for index := 1 to length(digits) do
  begin
    Iterator := 1;
    while Iterator <= length(s) do
    begin
      if pos(digits[index], s, Iterator) <> 0 then
      begin
        delete(s, pos(digits[index], s), 1);
        inc(count);
      end;
      inc(Iterator);
    end;
  end;
  deleteDigits := s;
end;

(* SumUp Function *)
//Function that sums up the numbers that occur in the input string
//@param s - The string which contains the numbers that will be summed up
//@return The sum of the numbers that occured in the input string
function sumUp(s: string): word;
var
  iterator: byte;
  numberAsString: string;
  result : word;

begin
  result := 0;
  numberAsString := '0';
  for iterator := 1 to length(s) do
    begin
      case s[iterator] of
        '0'..'9': numberAsString := numberAsString + s[iterator]
        else
        begin
          result := result + strToInt(numberAsString);
          numberAsString := '0';
        end;
      end;
    end;
    result := result + strToInt(numberAsString);

  sumUp := result;
end;

// Deklaration
var
  expectedDigits: byte = 0;
  expectedLowerCase: byte = 0;
  expectedUpperCase: byte = 0;

  testValue: string;
  expectedResult: string;
  count: byte = 0;
  expectedCount: byte = 0;
  digits: string;
  expectedSum: word = 0;

begin

  (* Tests for "printStat Procedure" *)
  setTextColor(COLOR_TEAL);
  writeln('Testing the printStat function:');
  writeln;

  // Test 1
  setTextColor(COLOR_BLUE);
  writeln('check for right counters');
  setTextColor(COLOR_WHITE);
  testValue := 'Das ist mein Satz Nummer 1';
  expectedDigits := 1;
  expectedLowerCase := 17;
  expectedUpperCase := 3;
  writeln('"', testValue, '"');
  writeln('Erwartete Gro�buchstaben: ', expectedUpperCase,
    ' Erwartete Kleinbuchstaben : ', expectedLowerCase, ' Erwartete Ziffern: ',
    expectedDigits);

  writeln;
  writeln('Ergebnis: ');
  printStat(testValue);
  writeln;

  // Test 2
  setTextColor(COLOR_BLUE);
  writeln('check count in a string with special characters');
  setTextColor(COLOR_WHITE);
  testValue := '!"�$%&/()=';
  expectedDigits := 0;
  expectedLowerCase := 0;
  expectedUpperCase := 0;
  writeln('"', testValue, '"');
  writeln('Erwartete Gro�buchstaben: ', expectedUpperCase,
    ' Erwartete Kleinbuchstaben : ', expectedLowerCase, ' Erwartete Ziffern: ',
    expectedDigits);

  writeln;
  writeln('Ergebnis: ');
  printStat(testValue);
  writeln;

  // Test 3
  setTextColor(COLOR_BLUE);
  writeln('check count in a string with only digits');
  setTextColor(COLOR_WHITE);
  testValue := '111222333';
  expectedDigits := 9;
  expectedLowerCase := 0;
  expectedUpperCase := 0;
  writeln('"', testValue, '"');
  writeln('Erwartete Gro�buchstaben: ', expectedUpperCase,
    ' Erwartete Kleinbuchstaben : ', expectedLowerCase, ' Erwartete Ziffern: ',
    expectedDigits);

  writeln;
  writeln('Ergebnis: ');
  printStat(testValue);
  writeln;

  // Test 4
  setTextColor(COLOR_BLUE);
  writeln('Check if program breaks when string has max chars');
  setTextColor(COLOR_WHITE);
  testValue := '1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sd';
  expectedDigits := 77;
  expectedLowerCase := 77;
  expectedUpperCase := 76;
  writeln('"', testValue, '"');
  writeln('Erwartete Gro�buchstaben: ', expectedUpperCase,
    ' Erwartete Kleinbuchstaben : ', expectedLowerCase, ' Erwartete Ziffern: ',
    expectedDigits);

  writeln;
  writeln('Ergebnis: ');
  printStat(testValue);
  writeln;

  // Test 5
  setTextColor(COLOR_BLUE);
  writeln('check the result from an empty string');
  setTextColor(COLOR_WHITE);
  testValue := '';
  expectedDigits := 0;
  expectedLowerCase := 0;
  expectedUpperCase := 0;
  writeln('"', testValue, '"');
  writeln('Erwartete Gro�buchstaben: ', expectedUpperCase,
    ' Erwartete Kleinbuchstaben : ', expectedLowerCase, ' Erwartete Ziffern: ',
    expectedDigits);

  writeln;
  writeln('Ergebnis: ');
  printStat(testValue);
  writeln;



  (* Tests for "Replace-Digits Function" *)
  setTextColor(COLOR_TEAL);
  writeln('Testing the replaceDigits function:');
  setTextColor(COLOR_WHITE);
  writeln;

  // Test 1 - check for replacing of the digits

  setTextColor(COLOR_BLUE);
  writeln('check for replacing of the digits');
  setTextColor(COLOR_WHITE);
  testValue := 'Es ist 10 Uhr';
  expectedResult := 'Es ist Einsnull Uhr';
  writeln('replaceDigits(', testValue, ') -> ', expectedResult);
  if replaceDigits(testValue) = expectedResult then
  begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', replaceDigits(testValue));
    setTextColor(COLOR_WHITE);
  end;

  // Test 2  - check for uppercase at the start
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('check for uppercase at the start');
  setTextColor(COLOR_WHITE);
  testValue := '2+39aaA';
  expectedResult := 'Zwei+dreineunaaA';
  writeln('replaceDigits(', testValue, ') -> ', expectedResult);
  if replaceDigits(testValue) = expectedResult then
  begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', replaceDigits(testValue));
    setTextColor(COLOR_WHITE);
  end;

  // Test 3 - check for uppercase after a space
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('check for uppercase at after a space');
  setTextColor(COLOR_WHITE);
  testValue := 'Zahlen von 1 bis 9 schreibt man aus!';
  expectedResult := 'Zahlen von Eins bis Neun schreibt man aus!';
  writeln('replaceDigits(', testValue, ') -> ', expectedResult);
  if replaceDigits(testValue) = expectedResult then
  begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', replaceDigits(testValue));
    setTextColor(COLOR_WHITE);
  end;

  // Test 4 - test an empty string
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('check an empty string');
  setTextColor(COLOR_WHITE);
  testValue := ' ';
  expectedResult := ' ';
  writeln('replaceDigits(', testValue, ') -> ', expectedResult);
  if replaceDigits(testValue) = expectedResult then
  begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', replaceDigits(testValue));
    setTextColor(COLOR_WHITE);
  end;

  // Test 5 - test an empty string
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('check for long boi');
  setTextColor(COLOR_WHITE);
  testValue := '1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0T1H8sdZ#c0';
  expectedResult := 'EinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnullTeinsHachtsdZ#cnull';
  writeln('replaceDigits(', testValue, ') -> ', expectedResult);
  if replaceDigits(testValue) = expectedResult then
  begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', replaceDigits(testValue));
    setTextColor(COLOR_WHITE);
  end;

  (* Tests for "Delete-Digits Function" *)
  writeln;
  setTextColor(COLOR_TEAL);
  writeln('Tests for deleteDigits function: ');
  setTextColor(COLOR_WHITE);
  writeln;

  // Test 1 - test digit deletion in a simple case
  setTextColor(COLOR_BLUE);
  writeln('test digit deletion in a simple case');
  setTextColor(COLOR_WHITE);
  testValue := '112 ist die Feuerwehr und 110 die Polizei';
  digits := '6351';
  expectedResult := '2 ist die Feuerwehr und 0 die Polizei';
  expectedCount := 4;
  writeln('deleteDigits(', testValue, ') -> ', expectedResult);
  writeln('Zu l�schende Digits: ', digits, ' -> erwarteter Wert: ',
    expectedCount);
  if deleteDigits(testValue, digits, count) = expectedResult then
  begin
    if expectedCount = count then
    begin
    setTextColor(COLOR_GREEN);
      writeln('OK');
      setTextColor(COLOR_WHITE);
      writeln('Gel�schte Zeichen: ', count);
    end
    else
    begin
      setTextColor(COLOR_RED);
      writeln('FEHLER beim count: count = ', count, ' aber erwartet war: ',
      expectedCount);
      setTextColor(COLOR_WHITE);
    end;
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER ', deleteDigits(testValue, digits, count));
    setTextColor(COLOR_WHITE);

  end;
  // Test 2 - Digits at the beginning and in the middle of the string
  writeln;
  writeln('Digits at the beginning and in the middle of the string');
  testValue := '123abc456def789';
  digits := '2467';
  expectedResult := '13abc5def89';
  expectedCount := 4;
  writeln('deleteDigits(', testValue, ') -> ', expectedResult);
  writeln('Zu l�schende Digits: ', digits, ' -> erwarteter Wert: ',
    expectedCount);
  if deleteDigits(testValue, digits, count) = expectedResult then
  begin
    if expectedCount = count then
    begin
    setTextColor(COLOR_GREEN);
      writeln('OK');
      setTextColor(COLOR_WHITE);
      writeln('Gel�schte Zeichen: ', count);
    end
    else
    begin
      setTextColor(COLOR_RED);
      writeln('FEHLER beim count: count = ', count, ' aber erwartet war: ',
      expectedCount);
      setTextColor(COLOR_WHITE);
    end;
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER ', deleteDigits(testValue, digits, count));
    setTextColor(COLOR_WHITE);

  end;

  // Test 3 - Digits spread across the string
  writeln;
  writeln('Digits spread across the string');
  testValue := '1122aa3344bb5566cc7788dd';
  digits := '2467';
  expectedResult := '11aa33bb55cc88dd';
  expectedCount := 8;
  writeln('deleteDigits(', testValue, digits, ') -> ', expectedResult);
  writeln('Zu l�schende Digits: ', digits, ' -> erwarteter Wert: ',
    expectedCount);
  if deleteDigits(testValue, digits, count) = expectedResult then
  begin
    if expectedCount = count then
    begin
    setTextColor(COLOR_GREEN);
      writeln('OK');
      setTextColor(COLOR_WHITE);
      writeln('Gel�schte Zeichen: ', count);
    end
    else
    begin
      setTextColor(COLOR_RED);
      writeln('FEHLER beim count: count = ', count, ' aber erwartet war: ',
      expectedCount);
      setTextColor(COLOR_WHITE);
    end;
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER ', deleteDigits(testValue, digits, count));
    setTextColor(COLOR_WHITE);

  end;
  // Test 4 - empty input
  writeln;
  writeln('empty input');
  testValue := '';
  digits := '';
  expectedResult := '';
  expectedCount := 0;
  writeln('deleteDigits(', testValue, digits, ') -> ', expectedResult);
  writeln('Erwartetes Ergebnis: leerer String');
  if deleteDigits(testValue, digits, count) = expectedResult then
  begin
    if expectedCount = count then
    begin
    setTextColor(COLOR_GREEN);
      writeln('OK');
      setTextColor(COLOR_WHITE);
      writeln('Gel�schte Zeichen: ', count);
    end
    else
    begin
      setTextColor(COLOR_RED);
      writeln('FEHLER beim count: count = ', count, ' aber erwartet war: ',
      expectedCount);
      setTextColor(COLOR_WHITE);
    end;
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER ', deleteDigits(testValue, digits, count));
    setTextColor(COLOR_WHITE);

  end;

  // Test 5 - testing different special characters
  writeln;
  writeln('testing different special characters');
  testValue := '!@#%123$&';
  digits := '(*&)';
  expectedResult := '!@#%123$';
  expectedCount := 1;
  writeln('deleteDigits(', testValue, ') -> ', expectedResult);
  writeln('Zu l�schende Digits: ', digits, ' -> erwarteter Wert: ',
    expectedCount);
  if deleteDigits(testValue, digits, count) = expectedResult then
  begin
    if expectedCount = count then
    begin
    setTextColor(COLOR_GREEN);
      writeln('OK');
      setTextColor(COLOR_WHITE);
      writeln('Gel�schte Zeichen: ', count);
    end
    else
    begin
      setTextColor(COLOR_RED);
      writeln('FEHLER beim count: count = ', count, ' aber erwartet war: ',
      expectedCount);
      setTextColor(COLOR_WHITE);
    end;
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER ', deleteDigits(testValue, digits, count));
    setTextColor(COLOR_WHITE);

  end;

  (* Tests for "SumUp Function" *)
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('Testing the sumUp function:');
  setTextColor(COLOR_WHITE);

  // Test 1 - Test for a normal sentence containing two numbers
  writeln;
  setTextColor(COLOR_TEAL);
  writeln('Test for a normal sentence containing two numbers');
  setTextColor(COLOR_WHITE);
  testValue := '2 und 2 sollte vier ergeben';
  expectedSum := 4;
  writeln('sumUp(', testValue, ') -> ', expectedSum);
  if sumUp(testValue) = expectedSum then
  begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', sumUp(testValue));
    setTextColor(COLOR_WHITE);
  end;

  // Test 2 - Test for a string with special characters
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('Test for a string with special characters');
  setTextColor(COLOR_WHITE);
  testValue :=
    'Die Konferenz beginnt um ca. 10 und endet um ca. 5 - oder nicht?';
  expectedSum := 15;
  writeln('sumUp(', testValue, ') -> ', expectedSum);
  if sumUp(testValue) = expectedSum then
    begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', sumUp(testValue));
    setTextColor(COLOR_WHITE);
  end;

  // Test 3 - Test for a sentence with longer numbers
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('Test for a sentence with multiple numbers and negative sign');
  setTextColor(COLOR_WHITE);
  testValue := '123 456 -789';
  expectedSum := 1368;
  writeln('sumUp(', testValue, ') -> ', expectedSum);
  if sumUp(testValue) = expectedSum then
    begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', sumUp(testValue));
    setTextColor(COLOR_WHITE);
  end;

  // Test 4 - Test for an empty string
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('Test for an empty string');
  setTextColor(COLOR_WHITE);
  testValue := '';
  expectedSum := 0;
  writeln('sumUp(', testValue, ') -> ', expectedSum);
  if sumUp(testValue) = expectedSum then
    begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', sumUp(testValue));
    setTextColor(COLOR_WHITE);
  end;

  // Test 5 - Test for a string without numbers
  writeln;
  setTextColor(COLOR_BLUE);
  writeln('Test for a string without numbers');
  setTextColor(COLOR_WHITE);
  testValue := 'Keine Zahlen hier';
  expectedSum := 0;
  writeln('sumUp(', testValue, ') -> ', expectedSum);
  if sumUp(testValue) = expectedSum then
    begin
    setTextColor(COLOR_GREEN);
    writeln('OK');
    setTextColor(COLOR_WHITE);
  end
  else
  begin
    setTextColor(COLOR_RED);
    writeln('FEHLER: ', sumUp(testValue));
    setTextColor(COLOR_WHITE);
  end;

  readln;

end.
