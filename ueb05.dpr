program ueb05;
(*
  @description: A small program, that messes with strings
  @date: 27-11-2023
*)

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses
  System.SysUtils,
  Windows;

var
  enteredSentence: String;
  selectedOption: char;

  isSentenceEntered: boolean = False;

  index: Integer;

  upperCaseAmount: Word = 0;
  lowerCaseAmount: Word = 0;

procedure setTextColor(color: Word);
begin
  if SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color) then;

end;

begin

  repeat
    //Printing out selectable options
    setTextColor(3);
    writeln('W�hle eine der folgenden Optionen aus:');
    writeln('[A]: Satz eingeben');
    writeln('[B]: Anzahl Gro�- und Anzahl Kleinbuchstaben im Satz bestimmen');
    writeln('[C]: Gro�-/Kleinschreibung vertauschen');
    writeln('[D]: Vokale verdoppeln');
    writeln('[X]: Ende');
    writeln;
    setTextColor(7);

    readln(selectedOption);
    selectedOption := upcase(selectedOption);

    if isSentenceEntered or (selectedOption = 'A') then
    begin
      case selectedOption of
        //Logic for entering a sentence; setting isSentenceEntered to true
        'A':
          begin
            writeln;
            write('Bitte gib deinen Satz ein: ');
            readln(enteredSentence);
            writeln;
            writeln('Eingegebener Satz: ', enteredSentence);
            writeln;
            isSentenceEntered := True;
          end;
        //Counting the amount of upper and lower case characters
        'B':
          begin
            upperCaseAmount := 0;
            lowerCaseAmount := 0;
            for index := 1 to length(enteredSentence) do
            begin
              case enteredSentence[index] of
                'A' .. 'Z':
                  inc(upperCaseAmount);
                'a' .. 'z':
                  inc(lowerCaseAmount);
              end;
            end;
            writeln;
            writeln('In dem Satz sind ', upperCaseAmount, ' Gro�buchstaben');
            writeln('In dem Satz sind ', lowerCaseAmount, ' Kleinbuchstaben');
            writeln;
          end;
        //Switching the character cases
        'C':
          begin
            for index := 1 to length(enteredSentence) do
            begin
              case enteredSentence[index] of
                'A' .. 'Z':
                  enteredSentence[index] :=
                    char(ord(enteredSentence[index]) + 32);
                'a' .. 'z':
                  enteredSentence[index] :=
                    char(ord(enteredSentence[index]) - 32);
              end;
            end;
            writeln;
            writeln('Der Satz mit vertauschter Gro�schreibung lautet: ', enteredSentence);
            writeln;
          end;
        //Doubling all vowels
        'D':
          begin
            index := 1;
            while index <= length(enteredSentence) do
            begin
              case enteredSentence[index] of
                'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U':
                  begin
                    insert(enteredSentence[index], enteredSentence, index);
                    index := index + 2;
                  end;
              else
                begin
                  Index := index + 1
                end;
              end;
            end;
            writeln;
            writeln('Der Satz mit verdoppelten Vokalen: ', enteredSentence);
            writeln;
          end;
      else
        begin
          //Detecting if invalid option was selected
          if selectedOption <> 'X' then
          begin
            writeln;
            setTextColor(12);
            write('Die Option ');
            setTextColor(7);
            write(selectedOption);
            setTextColor(12);
            writeln(' existiert nicht. Bitte w�hle eine g�ltige Option');
            setTextColor(7);
            writeln;
          end;
        end;

      end;
    end;
    //Throwing error when no sentence was entered
    if (selectedOption <> 'X') and not isSentenceEntered then
    begin
      writeln;
      setTextColor(12);
      writeln('Bitte gib zuerst einen Satz ein');
      setTextColor(7);
      writeln;
    end;

  until selectedOption = 'X';

end.
