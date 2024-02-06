program ueb04;
(*
  @description: A program that loops through a range of numbers and checks for special occurrences
  @date: 20-11-2023
*)

{$APPTYPE CONSOLE}

{$R+,Q+,X-}

uses
  System.SysUtils,
  Windows;

const
  LOWER_BORDER = 1;
  UPPER_BORDER = 10000;

var
  currentNumber : UInt64;
  cubicRoot : UInt64;

  isCubic : Boolean;

  currentDigit : byte;
  processedNumber : UInt64;
  digitCounter : byte;
  mostOccurringDigitAmount : byte;
  mostOccurringDigit : byte;


procedure setTextColor(color : word);
begin
  if setConsoleTextAttribute(getStdHandle(STD_OUTPUT_HANDLE), color) then;
end;

begin
  isCubic := False;
  for currentNumber := LOWER_BORDER to UPPER_BORDER do
    begin

      cubicRoot := 1;
      mostOccurringDigitAmount := 0;
      mostOccurringDigit := 0;

      //PROCESSING
      while(cubicRoot * cubicRoot * cubicRoot <= currentNumber) do  //Checking if the current number is cubic
      begin
        isCubic := cubicRoot * cubicRoot * cubicRoot = currentNumber;
        cubicRoot := cubicRoot + 1;
      end;

      for currentDigit := 0 to 9 do //Getting the digit that occurrs most
        begin
          processedNumber := currentNumber;
          digitCounter := 0;
          repeat
            if processedNumber mod 10 = currentDigit then //Detect the last digit
            digitCounter := digitCounter + 1;
            processedNumber := processedNumber div 10; //Removes last digit from currentNumber
          until processedNumber = 0; //Stops loop, if entire number was checked
          if digitCounter > mostOccurringDigitAmount then //if a new digit occurs more then the last saved one -> overwrite
          begin
            mostOccurringDigitAmount := digitCounter;
            mostOccurringDigit := currentDigit;
          end;
        end;

      //OUTPUT
      write('Nummer: ');
      setTextColor(12);
      write(currentNumber:6);
      setTextColor(7);
      write(' Gerade: ', (currentNumber mod 2 = 0):5, ' Kubikzahl: ', isCubic:5, ' Haeufigste Ziffer: ', mostOccurringDigit);
      writeln;
    end;
    readln
end.
