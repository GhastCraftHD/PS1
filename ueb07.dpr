program ueb07;
(*
  @description: The popular Milton-Bradley game Connect Four implemented in Pascal
  @date 13-12-2023
*)

{$APPTYPE CONSOLE}
{$R+,Q+,X-}

uses
  System.SysUtils,
  Windows;

const
  COLS = 7;
  ROWS = 6;
  WIN_LEN = 4;
  SLEEPTIME = 1000;

  RED = 12;
  YELLOW = 14;
  BLUE = 9;
  WHITE = 7;
  BLACK = 0;

  TILE = '██';

type
  TWidth = 1 .. COLS;
  THeight = 1 .. ROWS;
  TState = (stEmpty, stRed, stYellow);
  TField = array [TWidth, THeight] of TState;

  // Sets the console's text color
  // @param
  // color - the color value
procedure setTextColor(color: word);
begin
  if SetConsoleTextAttribute(GetStdHandle(STD_OUTPUT_HANDLE), color) then;
end;

// Set the cursor coordinates in the console
// @param
// x,y - the coordinate values
procedure setConsolePosition(x, y: byte);
var
  coord: _COORD;
begin
  coord.x := x;
  coord.y := y;
  if SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord) then;
end;

// Checks if the parameter coordinates are within bounds of the field
// @param
// col, row - the coordinate values
function isValidCoord(col, row: integer): boolean;
begin
  isValidCoord := ((col <= high(TWidth)) and (col >= low(TWidth))) and
    ((row <= high(THeight)) and (row >= low(THeight)));
end;

// Initialises a blank playing field
// @returns
// A TField which is filled with stEmpty
function initField: TField;
var
  col: TWidth;
  row: THeight;
begin
  for col := low(TWidth) to high(TWidth) do
  begin
    for row := low(THeight) to high(THeight) do
    begin
      initField[col, row] := stEmpty;
    end;
  end;
end;

// Sets the console color according to the input state
// @param
// state - the state of which the color should be adjusted to
procedure setStateColor(state: TState);
begin
  case state of
    stEmpty:
      setTextColor(BLACK);
    stYellow:
      setTextColor(YELLOW);
    stRed:
      setTextColor(RED);
  end;
end;

// Clears the console and resets the cursor to 0, 0
procedure clearField;

var
  col, row: word;

begin
  setConsolePosition(0, 0);
  for col := low(TWidth) to high(TWidth) * (COLS div 4) do
  begin
    for row := low(THeight) to high(THeight) * (ROWS div 4) do
    begin
      setTextColor(BLACK);
      write(TILE);
    end;
    writeln;
  end;
end;

// Prints the current field
// @param
// field - the field that shall be printed
procedure printField(field: TField);

var
  col, row: word;

begin
  clearField;
  setConsolePosition(0, 0);
  for row := low(THeight) to high(THeight) * 2 + 1 do
  begin
    for col := low(TWidth) to high(TWidth) * 2 + 1 do
    begin
      if (col mod 2 <> 0) or (row mod 2 <> 0) then
      begin
        setTextColor(BLUE);
      end
      else
      begin
        setStateColor(field[col div 2, row div 2]);
      end;
      write(TILE);
    end;
    writeln;
  end;

end;

// Asks the user for input and return the according column
// @returns
// The column that was entered or 0 when the input is invalid or out of bounds
function getCol(player: TState): byte;

var
  input: string;
  column: integer;
  isInputValid: boolean;

begin
  setStateColor(player);
  write('Bitte die Spalte eingeben : ');
  readln(input);
  isInputValid := tryStrToInt(input, column);
  if isInputValid then
  begin
    if isValidCoord(column, low(TWidth)) then
    begin
      getCol := column
    end
    else
    begin
      writeln('Eingabe ist nicht im erlaubten Bereich!');
      getCol := 0;
    end;
  end
  else
  begin
    writeln('Eingabe ist keine gültige Zahl');
    getCol := 0;
  end;
end;

// Checks if the column is full
// @param
// field - the field that has the column that shall be checked
// col - the column that shall be checked
// @returns
// True, when the input column is full
function isColFull(field: TField; col: TWidth): boolean;

var
  row: THeight;
  return: boolean;

begin
  return := True;
  for row := high(THeight) downto low(THeight) do
  begin
    if field[col, row] = stEmpty then 
    begin
      return := False;
    end;

  end;
  isColFull := return;
end;

// Inserts the stone into the given column
// @param
// field - the field, the stone is to be inserted into
// col - the column of the field
// player - the player to which the stone belongs to
procedure insertStone(var field: TField; col: TWidth; player: TState);
var
  row: THeight;
  isStonePlaced: boolean;

begin
  isStonePlaced := False;
  if not isColFull(field, col) then
  begin
    for row := high(THeight) downto low(THeight) do
    begin
      if (field[col, row] = stEmpty) and (not isStonePlaced) then
      begin
        field[col, row] := player;
        isStonePlaced := True;
      end;

    end;
  end;

end;

// Checks if the field is full
// @params
// field - the field that shall be checked if full
// @returns
// True, when the input field is full
function isFieldFull(field: TField): boolean;

var
  fieldFull: boolean;
  col: TWidth;

begin
  fieldFull := True;
  for col := low(TWidth) to high(TWidth) do
  begin
    fieldFull := fieldFull and isColFull(field, col);
  end;
  isFieldFull := fieldFull;
end;

// Checks if the input stone is part of a winning row
// @params
// field - the field where the stone is located
// col, row - the coordinates of the stone
// colInc rowInc - the incrementors which determine the direction that is checked
//@returns
//True, if the stone is part of a winning row
function hasConnectFour(field: TField; col, row: integer;
  colInc, rowInc: Int8): boolean;

var
  currentCol, currentRow: integer;
  iterator, stonesInARow: word;
  isSameStone: boolean;

begin
  stonesInARow := 1;
  for iterator := 1 to WIN_LEN - 1 do
  begin
    currentCol := col + iterator * colInc;
    currentRow := row + iterator * rowInc;
    if isValidCoord(currentCol, currentRow) then
    begin
      isSameStone := field[currentCol, currentRow] = field[col, row];
      if isSameStone then
      begin
        inc(stonesInARow);
      end
      else
      begin
        hasConnectFour := False;
      end;
    end
    else
    begin
      hasConnectFour := False;
    end;
  end;
  hasConnectFour := stonesInARow = WIN_LEN;
end;

//Determines if there is a winning row in the field
//@params
//field -  the field that shall be cheked for winning rows
//@returns
//The player color if there is a winner or the empty state if there is no winner yet
function getWinner(field: TField): TState;

var
  row : integer;
  col: integer;
  winningRow: boolean;
  return: TState;

begin
  winningRow := False;
  return := stEmpty;
  row := low(THeight);
  col := low(TWidth);

  while (row <= high(THeight)) and not winningRow do
  begin
    while (col <= high(TWidth)) and not winningRow do
    begin
      if field[col, row] <> stEmpty then
      begin
        winningRow := hasConnectFour(field, col, row, 1, 0) or
          hasConnectFour(field, col, row, 0, 1) or
          hasConnectFour(field, col, row, 1, 1) or
          hasConnectFour(field, col, row, -1, 1);
        if winningRow then
        begin
          return := field[col, row];
        end;
      end;

      inc(col);
    end;

    col := low(TWidth);
    inc(row);
  end;
  getWinner := return;
end;

var
  field: TField;
  column: integer;
  player: TState;
  playerString: String = '';
  hasWinner: boolean = False;
  fieldFull: boolean = False;

begin
  field := initField;
  player := stRed;
  repeat
    printField(field);
    repeat
      column := getCol(player);
      if column = 0 then
      begin
        sleep(SLEEPTIME);
        printField(field);
      end
      else
      begin
        if not isColFull(field, column) then
        begin
          insertStone(field, column, player);
          case player of
            stRed:
              player := stYellow;
            stYellow:
              player := stRed;
          end;
        end
        else
        begin
          writeln('Die Spalte ist voll');
          sleep(SLEEPTIME);
        end;
      end;
    until column <> 0;
    fieldFull := isFieldFull(field);
    hasWinner := getWinner(field) <> stEmpty;
  until hasWinner or fieldFull;
  if hasWinner then
  begin
    case player of
      stRed:
        begin
          player := stYellow;
          playerString := 'Der gelbe Spieler';
        end;
      stYellow:
        begin
          player := stRed;
          playerString := 'Der rote Spieler';
        end;
    end;
    printField(field);
    setStateColor(player);
    writeln(playerString, ' hat das Spiel gewonnen');
  end
  else
  begin
    if fieldFull then
    begin
      printField(field);
      setTextColor(WHITE);
      writeln('Das Spielfeld ist voll. Unentschieden!')
    end;
  end;
  readln

end.
