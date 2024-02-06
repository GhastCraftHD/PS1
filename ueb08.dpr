program ueb08;
(*
  @description: The program allows you to enter foods with different attributes
  and determines attributes that occur more than once between the entered foods.
  @date 18-12-2023
*)

//TO-DO Schleife aus dem Hauptprogramm auslagern
//TO-DO Beheben, dass das Programm abstürtzt, wenn man bei den Attributen einen leeren String eingibt
//TO-TO readAll zu einer Prozedur ändern

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses
  SysUtils, Windows;

const
  NO_OF_FOODS = 5;

type
  TAttribute = (attLecker, attTeuer, attGesund, attSalzig, attSuess);
  TAttributeSet = set of TAttribute;

  TFood = record
    name: String;
    isVegetarian: boolean;
    attributes: TAttributeSet;
  end;

  TFoods = array [1 .. NO_OF_FOODS] of TFood;

const
  ATTRIBUTE_NAMES: array [TAttribute] of string = ('lecker', 'teuer', 'gesund',
    'salzig', 'suess');

  // sets the console-position to the parameter-values
  // @params
  // x - console-position on the x-axis
  // y - console-position on the y-axis
procedure setConsolePosition(x, y: byte);
var
  coord: _COORD;
begin
  coord.x := x;
  coord.y := y;
  if SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord) then;
end;

// clears the console, starting from the desired position
// @params
// xA - desired x-axis position of the console (used for the setConsolePosition procedure within this procedure)
// yA - desired y-axis position of the console (used for the setConsolePosition procedure within this procedure)
procedure clearField(xA, yA: byte);

var
  x, y: byte;

begin
  setConsolePosition(xA, yA);
  for x := 0 to 10 do
  begin
    for y := 0 to 79 do
    begin
      write(' ');
    end;
    writeln;
  end;
  setConsolePosition(xA, yA);
end;

// reads the name of an entered food
// returns the name as a string
// @params
// cancelledInput - receives true or false showing whether the input was cancelled or not
// @return
// the name that was entered by the user
function readName(var cancelledInput: boolean): String;

var
  input: String;

begin
  write('Bitte gib den Namen des Lebensmittles ein: ');
  readln(input);
  input[1] := uppercase(input)[1];
  if (length(input) < 4) and not(input = 'X') then
  begin
    writeln('Ung�ltige Eingabe');
    input := readName(cancelledInput);
  end;
  if input = 'X' then
  begin
    cancelledInput := True;
  end;
  readName := input;

end;

// the function reads wheter a entered food is vegetatrian or not
// it returns a boolean - true if the food is vegetarian, false if it is not
// @params
// cancelledInput - receives true or false showing whether the input was cancelled or not
// @return
// true, if the input is vegetarian, false if it is not
function readIsVegetarian(var cancelledInput: boolean): boolean;

var
  input: String;

begin
  write('Handelt es sich um ein vegetarisches Lebensmittel (Ja/Nein): ');
  readln(input);
  input := uppercase(input);

  if (input = 'JA') or (input = 'NEIN') or (input = 'X') then
  begin
    if input = 'X' then
    begin
      cancelledInput := True;
    end;

    readIsVegetarian := input = 'JA';
  end
  else
  begin
    writeln('Ung�ltige Eingabe');
    readIsVegetarian := readIsVegetarian(cancelledInput);
  end;
end;

// reads the attributes from the user, also showing the user which attributes are possible to enter and how to add or delete them
// returns a set of attributes which were assigned to this food
// @params
// cancelledInput - receives true or false showing whether the input was cancelled or not
// @return
// a set of attributes, assigned to the specific food
function readAttributes: TAttributeSet;
var
  attributes: TAttributeSet;
  attribute: TAttribute;
  input: String;
  validAttribute: boolean;

begin
  attributes := [];
  repeat
    validAttribute := False;
    writeln('Welche Eigenschaften hat das Lebensmittel?');
    writeln('M�gliche Eigenschaften sind: lecker, teuer, gesund, salzig, s��');
    writeln('Vor dem eingegeben Wort: [+] zum Hinzuf�gen, [-] zum L�schen einer Eigenschaft');

    readln(input);

    if input <> '' then
    begin
      if (input[1] = '+') or (input[1] = '-') or (input = 'X') or (input = 'x')
      then
      begin
        for attribute := low(TAttribute) to high(TAttribute) do
        begin
          if input = '+' + ATTRIBUTE_NAMES[attribute] then
          begin
            validAttribute := True;
            include(attributes, attribute);
          end;
          if input = '-' + ATTRIBUTE_NAMES[attribute] then
          begin
            exclude(attributes, attribute);
            validAttribute := True;
          end;
          if (input = 'x') or (input = 'X') then
          begin
            validAttribute := True;
          end
          else
          begin
            validAttribute := validAttribute or False;
          end;
        end;
        if not validAttribute then
        begin
          writeln('Ung�ltige Eingabe');
        end;
      end
      else if input <> 'X' then
      begin
        writeln('Ung�ltige Eingabe');
      end;
    end;
    sleep(500);
    clearField(0, 2);
  until (input = 'X') or (input = 'x');
  clearField(0, 0);
  readAttributes := attributes;
end;

// reads all foods as long as the food-array is filled
// returns a boolean that is true, if the input is cancelled or false if it is not cancelled
// @params
// foods - array of foods from the type TFoods
// fillLevel - the amount of foods already entered in the food-array
// @return
// true, if the reading was cancelled, false if not
procedure readAll(var foods: TFoods; var fillLevel: byte);

var
  food: TFood;
  iterator: byte;
  cancelledInput: boolean;

begin
  repeat

    cancelledInput := False;

    for iterator := 0 to 2 do
    begin
      if not cancelledInput then
      begin
        case iterator of
          0:
            food.name := readName(cancelledInput);
          1:
            food.isVegetarian := readIsVegetarian(cancelledInput);
          2:
            food.attributes := readAttributes;
        end;
      end;
    end;

    if not cancelledInput then
    begin
      if fillLevel <= NO_OF_FOODS then
      begin
        inc(fillLevel);
        foods[fillLevel] := food;
      end
      else
      begin
        writeln('Die maximale Anzahl an Lebensmitteln wurde erreicht');
        sleep(1000);
      end;
    end;
  until cancelledInput or (fillLevel = NO_OF_FOODS);
end;

// converts a set of attributes to a string
// @params
// attributeSet - a set of attributes
// @return
// returns the converted set of attributes as a string
function attributeSetToString(attributeSet: TAttributeSet): String;

var
  return: String;
  attribute: TAttribute;

begin
  return := '';
  for attribute := low(TAttribute) to high(TAttribute) do
  begin
    if attribute in attributeSet then
    begin
      if return <> '' then
      begin
        return := return + ', ';
      end;
      return := return + ATTRIBUTE_NAMES[attribute];
    end;
  end;

  attributeSetToString := return;
end;

// print a food with its entered information
// @param
// food - a record of a food containing the name, the vegetarian-state and the foods attributes
procedure printFood(food: TFood);

begin
  writeln('Name: ', food.name);
  writeln('Vegetarisch: ', food.isVegetarian);
  if attributeSetToString(food.attributes) <> '' then
  begin
    writeln('Attribute: ', attributeSetToString(food.attributes));
  end
  else
  begin
    writeln('Dieses Lebensmittel hat keine Attribute');
  end;
  writeln;
end;

// prints all entered foods
// @params
// foods - array of entered foods
// fillLevel - the amount of foods entered
procedure printAllFoods(foods: TFoods; fillLevel: byte);

var
  iterator: byte;

begin
  clearField(0, 0);
  if fillLevel <> 0 then
  begin
    for iterator := 1 to fillLevel do
    begin
      writeln(iterator, '. EINGEGEBENES NAHRUNGSMITTEL');
      printFood(foods[iterator]);
    end;
  end
end;

// gets all used attributes from all foods
// @params
// foods - array of foods
// @return
// A set of attributes from all foods
function getAllAttributes(foods: TFoods): TAttributeSet;

var
  allAttributes: TAttributeSet;
  food: TFood;

begin
  allAttributes := [];
  for food in foods do
  begin
    allAttributes := allAttributes + food.attributes;
  end;

  getAllAttributes := allAttributes;

end;

// calculates the attributes that the user could have used but did not
// @params
// usedAttributes - a set of attributes from a food
// @return
// a set of attributes containing only the attributes that were not used - but could have been used
function calcUnusedAttributes(usedAttributes: TAttributeSet): TAttributeSet;

var
  possibleAttributes: TAttributeSet;
  attribute: TAttribute;

begin
  possibleAttributes := [];
  for attribute := low(ATTRIBUTE_NAMES) to high(ATTRIBUTE_NAMES) do
  begin
    include(possibleAttributes, attribute);
  end;

  for attribute := low(TAttribute) to high(TAttribute) do
  begin
    if attribute in usedAttributes then
    begin
      possibleAttributes := possibleAttributes - [attribute];
    end;
  end;

  calcUnusedAttributes := possibleAttributes;
end;

// calculates the reused attributes
// returns the attributes that were used more than once
// @params
// foods - array of foods that were entered by the user
// @returns
// set of attributes containing the more than once used attributes
function calcReusedAttributes(foods: TFoods): TAttributeSet;

var
  multipleAttributes: TAttributeSet;
  i, j: byte;
  foodX, foodY: TFood;
  intersectionOfAttributes: TAttributeSet;

begin
  multipleAttributes := [];
  for i := low(foods) to high(foods) do
  begin
    foodX := foods[i];
    for j := i + 1 to high(foods) do
    begin
      foodY := foods[j];

      if foodX.name <> foodY.name then
      begin
        intersectionOfAttributes := foodX.attributes * foodY.attributes;

        multipleAttributes := multipleAttributes + intersectionOfAttributes;
      end;

    end;
  end;
  calcReusedAttributes := multipleAttributes;
end;

var
  foods: TFoods;
  fillLevel: byte = 0;

begin
  readAll(foods, fillLevel);
  if fillLevel = 0 then
    writeln('Es wurden keine Lebensmittel eingelagert')
  else
  begin
    printAllFoods(foods, fillLevel);
    writeln('Nicht genutzte Attribute sind: ',
      attributeSetToString(calcUnusedAttributes(getAllAttributes(foods))));
    writeln('Attribute, die h�ufiger verwendet wurden, sind: ',
      attributeSetToString(calcReusedAttributes(foods)));
  end;
  readln;

end.
