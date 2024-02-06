program ueb10;
{
  @description: A program that read the contents of a text file to a list, sorts them and writes them to a new file
  @date: 15-01-2024
}

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses SysUtils, Windows;

type
  TListPointer = ^TListEntry;

  TListEntry = record
    previous: TListPointer;
    value: String;
    next: TListPointer;
  end;

  TListWrapper = record
    first: TListPointer;
    last: TListPointer;
  end;

  TSortingOperation = (ENTRY, LIST);

var
  pointerCounter: Integer;

  // @param first - the lists first pointer
  // @returns - the length of the list
function getLength(first: TListPointer): byte;
begin
  if first = nil then
    getLength := 0
  else
    getLength := 1 + getLength(first^.next);
end;

// @param index - the index of the desired entry
// @param wrapper - the list wrapper determining the list
// @returns - the pointer to the desired entry
function getEntryPointer(index: byte; wrapper: TListWrapper): TListPointer;
var
  ENTRY: TListPointer;
  i: byte;

begin
  if index < getLength(wrapper.first) div 2 then
  begin
    ENTRY := wrapper.first;
    for i := 1 to index do
    begin
      ENTRY := ENTRY^.next;
    end;

  end
  else
  begin
    ENTRY := wrapper.last;
    for i := getLength(wrapper.first) - 2 downto index do
    begin
      ENTRY := ENTRY^.previous;
    end;

  end;
  getEntryPointer := ENTRY;

end;

// Removes the desired entry from the list
// @param index - the index of the desired entry
// @param wrapper - the list wrapper determining the list
procedure removeEntry(index: byte; var wrapper: TListWrapper);
var
  ENTRY: TListPointer;
  cache: TListPointer;

begin
  ENTRY := getEntryPointer(index, wrapper);
  if getLength(wrapper.first) = 1 then
  begin
    dispose(wrapper.first);
    wrapper.first := nil;
    wrapper.last := nil;
  end
  else
  begin
    if ENTRY = wrapper.first then
    begin
      cache := wrapper.first;
      wrapper.first := ENTRY^.next;
      dispose(cache);
      ENTRY^.next^.previous := nil;
    end
    else if ENTRY = wrapper.last then
    begin
      cache := wrapper.last;
      wrapper.last := ENTRY^.previous;
      dispose(cache);
      ENTRY^.previous^.previous := nil;

    end
    else
    begin
      ENTRY^.next^.previous := ENTRY^.previous;
      ENTRY^.previous^.next := ENTRY^.next;
    end;

  end;
  dec(pointerCounter);
  writeln(pointerCounter);

end;

// Adds an entry to the list
// @param entry - the value to be stored
// @param wrapper - the lists wrapper
procedure addEntry(ENTRY: String; var wrapper: TListWrapper);
var
  entryPointer: TListPointer;

begin
  new(entryPointer);
  inc(pointerCounter);
  entryPointer^.value := ENTRY;
  if getLength(wrapper.first) = 0 then
  begin
    wrapper.first := entryPointer;
    wrapper.last := entryPointer;
  end
  else
  begin
    entryPointer^.previous := wrapper.last;
    wrapper.last^.next := entryPointer;
    wrapper.last := entryPointer;
  end;
end;

// Removes every entry from the list
// @param wrapper - the lists wrapper
procedure disposeList(var wrapper: TListWrapper);
var
  entryPointer: TListPointer;
  pointerCache: TListPointer;
begin
  entryPointer := wrapper.first;
  while entryPointer <> nil do
  begin
    pointerCache := entryPointer^.next;
    dispose(entryPointer);
    entryPointer := pointerCache;
    dec(pointerCounter);
  end;
end;

// Prints every entry of the list
// @param wrapper - the lists wrapper
procedure printList(wrapper: TListWrapper);
var
  entryPointer: TListPointer;

begin
  writeln('Strings in der Liste: ');
  writeln;
  entryPointer := wrapper.first;
  while entryPointer <> nil do
  begin
    writeln(entryPointer^.value);
    entryPointer := entryPointer^.next;
  end;

end;

// Checks if a file exists
// @param name - the filename
function isValidFile(var name: String): boolean;
var
  valid: boolean;

begin
  valid := True;
  write('Bitte gib einen Dateinamen ein: ');
  readln(name);
  if not FileExists(name) then
  begin
    writeln('Die Datei ', name, ' konnte nicht gefunden werden');
    valid := False;
  end;
  isValidFile := valid;

end;

// Sorts the list by entries
// @param wrapper - the lists wrapper
procedure sortList(wrapper: TListWrapper);
var
  currentPointer: TListPointer;
  current: String;
  compare: String;
  isSorted: boolean;
  i: byte;

begin
  repeat
    isSorted := True;
    for i := 0 to getLength(wrapper.first) - 1 do
    begin
      currentPointer := getEntryPointer(i, wrapper);
      if currentPointer^.next <> nil then
      begin
        current := currentPointer^.value;
        compare := currentPointer^.next^.value;
        if ord(current[1]) > ord(compare[1]) then
        begin
          isSorted := False;
          currentPointer^.value := compare;
          currentPointer^.next^.value := current;
        end;
      end;

    end;
  until isSorted;

end;

// Sorts every entry alphabetically
// @param wrapper - the lists wrapper
procedure sortEntries(wrapper: TListWrapper);
var
  currentPointer: TListPointer;
  currentString: String;
  current: char;
  compare: char;
  isSorted: boolean;
  i: byte;

begin
  currentPointer := wrapper.first;
  while currentPointer <> nil do
  begin
    currentString := currentPointer^.value;
    repeat
      isSorted := True;
      for i := 1 to length(currentString) do
      begin
        if i <> length(currentString) then
        begin
          current := currentString[i];
          compare := currentString[i + 1];
          if ord(current) > ord(compare) then
          begin
            isSorted := False;
            currentString[i] := compare;
            currentString[i + 1] := current;
          end;

        end;
      end;
    until isSorted;
    currentPointer^.value := currentString;
    currentPointer := currentPointer^.next;

  end;
end;

// Asks the user, how to sort the list
// @param wrapper - the lists wrapper
procedure sort(wrapper: TListWrapper; var operation: TSortingOperation);
var
  input: String;
  isValid: boolean;

begin
  isValid := False;
  repeat
    write('Nach welcher Variante soll sortiert werden(Eintrag/Liste): ');
    readln(input);
    input := uppercase(input);
    if (input = 'E') or (input = 'EINTRAG') then
    begin
      writeln('Jeder Eintrag der Liste wurde zeichenweise sortiert');
      writeln;
      sortEntries(wrapper);
      isValid := True;
      operation := ENTRY;
    end
    else if (input = 'L') or (input = 'LISTE') then

    begin
      writeln('Die gesamte Liste wurde alphabetisch sortiert');
      writeln;
      sortList(wrapper);
      isValid := True;
      operation := LIST;
    end
    else
    begin
      writeln('Ung�ltige Eingabe, bitte benutze "E" um jeden Eintrag zeichenweise zu sortieren,');
      writeln('oder "L" um die gesamte Liste eintragsweise zu sortieren');
    end;
  until isValid;
end;

// Reads a file to the list
// @param filename - the name of the file
// @param wrapper - the lists wrapper
procedure readFileToList(filename: String; var wrapper: TListWrapper);
var
  textFile: text;
  content: String;

begin
  try
    AssignFile(textFile, filename);
    try
      Reset(textFile);
      while not Eof(textFile) do
      begin
        readln(textFile, content);
        addEntry(content, wrapper);
      end;
    finally
      CloseFile(textFile);
    end;

  except
    writeln('Fehler beim Dateizugriff');
  end;
end;

// Writes a list to a new file
// @param filename - the name of the file
// @param operation - the sorting operation, the list was sorted by
// @param wrapper - the lists wrapper
procedure writeListToFile(filename: String; operation: TSortingOperation;
  wrapper: TListWrapper);
var
  textFile: text;
  entryPointer: TListPointer;
  modifiedName: String;
begin
  if filename[length(filename) - 3] = '.' then
  begin
    delete(filename, length(filename) - 3, 4);

  end;
  case operation of
    ENTRY:
      modifiedName := filename + '_zeichen.txt';
    LIST:
      modifiedName := filename + '_zeile.txt';
  end;
  try
    AssignFile(textFile, modifiedName);
    try
      ReWrite(textFile);
      entryPointer := wrapper.first;
      while entryPointer <> nil do
      begin
        writeln(textFile, entryPointer^.value);
        entryPointer := entryPointer^.next;
      end;
    finally
      CloseFile(textFile);
    end;
  except
    writeln('Fehler beim Dateizugriff');
  end;
  writeln;
  case operation of

    ENTRY:
      writeln('Die zeichenweise sortierte Liste wurde in der Datei "',
        modifiedName, '" abgespeichert');
    LIST:
      writeln('Die eintragsweise sortierte Liste wurde in der Datei "',
        modifiedName, '" abgespeichert')
  end;

end;

var
  listWrapper: TListWrapper;
  filename: String;
  operation: TSortingOperation;

begin
  pointerCounter := 0;
  listWrapper.first := nil;
  listWrapper.last := nil;
  if isValidFile(filename) then
  begin
    writeln;
    readFileToList(filename, listWrapper);
    printList(listWrapper);
    writeln;
    sort(listWrapper, operation);
    printList(listWrapper);
    writeListToFile(filename, operation, listWrapper);
    disposeList(listWrapper);
    writeln;
    if pointerCounter <> 0 then
    begin
      writeln('Fehler beim Freigeben des Speichers, ', pointerCounter,
        ' Pointer wurde nicht freigegeben!');
    end
    else
    begin
      writeln('Die Liste wurde freigegeben!');
    end;
  end;
  readln;

end.
