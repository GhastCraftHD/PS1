program ueb03;
(*
  @description: A program which can generate german number plates that are registered in a federal capitol
  @date 13-11-2023
*)

{$APPTYPE CONSOLE}
{$R+Q+X-}

var
  firstCityChar: Char;
  secondCityChar: Char;
  invalidChar: Char;
  answerChar: Char;

  isCityComplete: Boolean;
  askForSecondChar: Boolean;
  isInputInvalid: Boolean;

  firstLetter: Char;
  secondLetter: Char;

  areLettersComplete: Boolean;

  number: UInt16;
  invalidNumber: UInt16;

begin
  // INITIALISING
  invalidNumber := 1;
  invalidChar := #0;
  isInputInvalid := False;

  answerChar := #0;
  secondCityChar := #0;
  secondLetter := #0;
  firstLetter := #0;
  areLettersComplete := False;

  write('Wie lautet der erste Buchstabe der Stadt: ');
  readln(firstCityChar);
  firstCityChar := upcase(firstCityChar);

  case firstCityChar of
    'B', 'P': // TIPP: already complete
      begin
        isCityComplete := True;
        askForSecondChar := False;
        secondCityChar := #0;
      end;
    'W', 'K', 'E': // TIPP: incomplete, but not valid alone. No question.
      begin
        askForSecondChar := False;
        isCityComplete := False;
      end;
    'M', 'H', 'D', 'S': // TIPP: incomplete, but valid alone. Ask question.
      begin
        askForSecondChar := True;
        isCityComplete := False;
      end;
  else
    isCityComplete := False;
    askForSecondChar := False;
    invalidChar := firstCityChar;
    isInputInvalid := True;
  end;

  if askForSecondChar and not isInputInvalid then
  begin
    write('Hat die Stadt einen zweiten Buchstaben (J/N): ');
    readln(answerChar);
    answerChar := upcase(answerChar);


    // TIPP: Guard-Entwurfsmuster
    // init invalid

    // if
    // J -> isCityComplete := False;
    // N -> isCityComplete := True;

    case answerChar of
      'J':
        isCityComplete := False;
      'N':
        begin
          isCityComplete := True;
          secondCityChar := #0;
          // TIPP: Doppelt gemoppelt. Ist bereits so initalisiert.
        end
    else
      begin
        isInputInvalid := True;
        invalidChar := answerChar;
      end;
    end;
  end;

  if not isCityComplete and not isInputInvalid then
  begin
    write('Wie lautet der zweite Buchstabe der Stadt: ');
    readln(secondCityChar);
    secondCityChar := upcase(secondCityChar);
    case firstCityChar of
      // TIPP: DRY (Don't repeat yourself)
      'W', 'K':
        isCityComplete := secondCityChar = 'I';

      { 'W', 'K':
        begin
        if secondCityChar = 'I' then
        isCityComplete := True
        else
        begin
        invalidChar := secondCityChar;
        isInputInvalid := True;
        end;
        end; }
      'D':
        begin
          if secondCityChar = 'D' then
            isCityComplete := True
          else
          begin
            invalidChar := secondCityChar;
            isInputInvalid := True;
          end;
        end;
      'E':
        begin
          if secondCityChar = 'F' then
            isCityComplete := True
          else
          begin
            invalidChar := secondCityChar;
            isInputInvalid := True;
          end;
        end;
      'H':
        begin
          if (secondCityChar = 'B') or (secondCityChar = 'H') then
            isCityComplete := True
          else
          begin
            invalidChar := secondCityChar;
            isInputInvalid := True;
          end;

        end;
      'M':
        begin
          if (secondCityChar = 'D') or (secondCityChar = 'Z') then
            isCityComplete := True
          else
          begin
            invalidChar := secondCityChar;
            isInputInvalid := True;
          end;

        end;
      'S':
        begin
          if (secondCityChar = 'B') or (secondCityChar = 'N') then
            isCityComplete := True
          else
          begin
            invalidChar := secondCityChar;
            isInputInvalid := True;
          end;

        end;
    end;
    if not isCityComplete then
    begin
      invalidChar := secondCityChar;
      isInputInvalid := True;
    end;

  end;

  if isCityComplete and not isInputInvalid then
  begin
    writeln('Gew�hlte Stadt: ', firstCityChar, secondCityChar)
  end;

  if not isInputInvalid then
  begin
    write('Bitte den ersten Buchstaben eingeben: ');
    readln(firstLetter);
    firstLetter := upcase(firstLetter);

    case firstLetter of
      'A' .. 'Z':
        begin
          write('M�chtest du noch einen zweiten Buchstaben hinzuf�gen (J/N): ');
          readln(answerChar);
          answerChar := upcase(answerChar);
        end;
    else
      begin
        isInputInvalid := True;
        invalidChar := firstLetter;
      end;
    end;
  end;

  // TIPP: super pl�tze f�r Kommentare
  if not isInputInvalid then
  begin
    case answerChar of
      'J':
        areLettersComplete := False;
      'N':
        begin
          areLettersComplete := True;
          secondLetter := #0;
        end;
    else
      begin
        areLettersComplete := False;
        isInputInvalid := True;
        invalidChar := answerChar;
      end;
    end;
  end;

  if not isInputInvalid and not areLettersComplete then
  begin
    write('Bitte den zweiten Buchstaben eingeben: ');
    readln(secondLetter);
    secondLetter := upcase(secondLetter);
  end;

  if not isInputInvalid then
  begin
    case secondLetter of
      'A' .. 'Z', #0:
        begin
          writeln('Gew�hlte Buchstaben: ', firstLetter, secondLetter);
          write('Bitte gib die Zahl ein: ');
          readln(number);
          // ALTERNATIVE: if (number >= 1 ) and (number <= 9999)
          case number of
            1 .. 9999:
              begin
              if secondCityChar = #0 then
              begin
                if secondLetter = #0 then
                writeln('Das Kennzeichen lautet ', firstCityChar,
                ' ', firstLetter, ' ', number)
                else
                writeln('Das Kennzeichen lautet ', firstCityChar,
                ' ', firstLetter, secondLetter, ' ', number);
              end;

              if secondCityChar <> #0 then
              begin
                if secondLetter = #0 then
                writeln('Das Kennzeichen lautet ', firstCityChar, secondCityChar,
                ' ', firstLetter, ' ', number)
                else
                writeln('Das Kennzeichen lautet ', firstCityChar, secondCityChar,
                ' ', firstLetter, secondLetter, ' ', number);
              end;
              end

            else begin isInputInvalid := True;
            invalidNumber := number;
            end;
            end;
            end;
            else begin isInputInvalid := True;
            invalidChar := secondLetter;
            end;
            end;
            end;

            // Beim n�chsten Mal bitte sprechendere Fehlermeldungen ;)
            if isInputInvalid then begin if invalidNumber <> 1
            then begin writeln(invalidNumber, ' <- Ung�ltiges Zeichen');
            end;
            if invalidChar <> #0 then begin writeln(invalidChar,
              ' <- Ung�ltiges Zeichen');
            end end;
            readln

            end.
