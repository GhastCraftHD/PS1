program ueb09;

{
  @description: A simple implementation of a linked list using pointers
  @date: 08-01-2024
}

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses SysUtils, Windows;

type
  TListPointer = ^TListElement;

  TListElement = record
    value: String;
    nextElement: TListPointer;
  end;

  TCharSet = set of ansichar;
  TIndices = set of byte;

  TProgramState = (ADDITION, DELETION);

//Gets the input from the user
//@returns - user input
function getUserInput: String;
var
  input: String;
begin
  Write('Gib bitte ein Wort ein: ');
  readln(input);
  getUserInput := input;

end;

//Gets the length of the list that is linked to the entrance pointer
//@param entrance - the entrance pointer
//@return - length of the list
function getLength(entrance: TListPointer): byte;
var
  counter: byte;
begin
  counter := 0;
  while entrance <> nil do
  begin
    entrance := entrance^.nextElement;
    inc(counter);
  end;
  getLength := counter;
end;

//Gets the pointer to an element from the list
//@param index - the index of the element
//@param entrance - the entrance pointer
//@returns - the element pointer
function getElementPointer(index: integer; entrance: TListPointer): TListPointer;
var
  return: TListPointer;
  i: integer;

begin
  return := entrance;
  if index > 0 then
  begin
    for i := 1 to index do
    begin
      return := return^.nextElement;
    end;
  end
  else
    return := entrance;
  getElementPointer := return;

end;

//Adds an element to the list
//@param value - the string value
//@param entrance - the lists entrance pointer
procedure add(value: String; var entrance: TListPointer);
var
  newElement: TListPointer;
begin
  if value <> '' then
  begin
    new(newElement);
    newElement^.value := value;
    newElement^.nextElement := entrance;
    entrance := newElement;
  end;
end;

//Puts every character that occurs in the list into a set
//@param entrance - the lists entrance pointer
//@returns - the char set with all characters
function listToSet(entrance: TListPointer): TCharSet;
var
  i: byte;
  charSet: TCharSet;
begin
  charSet := [];
  while entrance <> nil do
  begin
    for i := 1 to length(entrance^.value) do
    begin
      charSet := charSet + [entrance^.value[i]];
    end;
    entrance := entrance^.nextElement;
  end;
  listToSet := charSet;
end;


//Gets the indices of the intersected elements
//@param inputSet - the set out of the user input
//@param indices - the index set
//@param entrance - the lists entrance pointer
procedure getIndices(inputSet: TCharSet; var indices: TIndices;
  entrance: TListPointer);
var
  j: byte;
  elementSet: TCharSet;
  elementValue: string;
  k: byte;
  d: ansichar;
begin
  for j := 0 to getLength(entrance) do
  begin
    elementSet := [];
    if getElementPointer(j, entrance) <> nil then
      elementValue := getElementPointer(j, entrance)^.value;
    for k := 1 to length(elementValue) do
    begin
      elementSet := elementSet + [elementValue[k]];
    end;
    for d in inputSet do
    begin
      if d in elementSet then
      begin
        if j < getLength(entrance) then
        begin
          indices := indices + [j];
        end;
      end;
    end;
  end;
end;

//Checks, if a user input is valid
//@param input - the user input
//@param entrance - the lists entrance pointer
//@param indices - the index set with intersected characters
//@param state - the programs state
function isValidInput(input: String; entrance: TListPointer;
  var indices: TIndices; state: TProgramState): boolean;
var
  i: byte;
  isValid: boolean;
  listSet: TCharSet;
  inputSet: TCharSet;
  invalidChar: TCharSet;
  c: ansichar;

begin
  invalidChar := [];
  inputSet := [];
  indices := [];
  isValid := True;
  listSet := listToSet(entrance);
  for i := 1 to length(input) do
  begin
    inputSet := inputSet + [input[i]];
  end;

  for c in inputSet do
  begin
    if c in listSet then
    begin
      invalidChar := invalidChar + [c];
      isValid := False;
    end;
    getIndices(inputSet, indices, entrance);

  end;

  if not isValid then
  begin
    case state of

      ADDITION:
        begin
          write('Die Eingabe beinhaltet bereits verwendete Zeichen -> ');
        end;
      DELETION:
        begin
          write('Alle Einträge, die die folgenden Zeichen beihnalten wurden entfernt -> ');
        end;
    end;
    for c in invalidChar do
      write(c);
    writeln;
  end;

  isValidInput := isValid;
end;

//Prints the list
//@param element - the lists entrance pointer
procedure printList(element: TListPointer);
var
  list: String;
begin
  list := 'Strings in der Liste: ';
  while element <> nil do
  begin
    list := list + element^.value;
    if (element^.nextElement <> nil) or (element^.value = '') then
    begin
      list := list + ' -> ';
    end;
    element := element^.nextElement;
  end;
  writeln(list);
end;


//Removes an element from the list
//@param index - the index of the element
//@param entrance - the lists entrance pointer
procedure remove(index: byte; entrance: TListPointer);
var
  elementPointer: TListPointer;

begin
  elementPointer := getElementPointer(index + 1, entrance);
  dispose(getElementPointer(index, entrance));
  getElementPointer(index - 1, entrance)^.nextElement := elementPointer;
end;

//Removes all elements from a list
//@param entrance - the lists entrance pointer
procedure removeAllElements(entrance: TListPointer);
var
  iterator: byte;

begin
  for iterator := 0 to getLength(entrance) - 1 do
  begin
    if (iterator < getLength(entrance) - 1) and (iterator > 0) then
      remove(iterator, entrance);
  end;
  writeln('Die Liste wurde gelöscht');
end;

var
  entrance: TListPointer = nil;
  input: String;
  indices: TIndices;
  state: TProgramState;
  index: byte;

begin
  state := ADDITION;
  repeat
    input := getUserInput;
    if isValidInput(input, entrance, indices, state) then
    begin
      add(input, entrance);
    end;
  until input = '';
  writeln('Die Liste hat die Länge ', getLength(entrance));
  printList(entrance);
  state := DELETION;
  repeat
    input := getUserInput;
    if not isValidInput(input, entrance, indices, state) then
    begin
      for index in indices do
      begin
        remove(index, entrance);
      end;

    end;
  until input <> '';
  writeln('Die Liste hat die Länge ', getLength(entrance));
  printList(entrance);
  removeAllElements(entrance);
  readln;

end.
