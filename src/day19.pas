{$mode delphi}

program Day19;

uses
  SysUtils, Classes;

type
  TStringArray = array of string;

function Split(const s: string; delimiter: Char): TStringArray;
var
  temp: TStringList;
  i: Integer;
begin
  SetLength(Result, 0);
  temp := TStringList.Create;
  try
    temp.StrictDelimiter := True;
    temp.Delimiter := delimiter;
    temp.DelimitedText := s;

    SetLength(Result, temp.Count);
    for i := 0 to temp.Count - 1 do
      Result[i] := Trim(temp[i]);
  finally
    temp.Free;
  end;
end;

procedure AnalyzeDesign(patterns: TStringArray; design: string; out isPossible: Boolean; out numWays: Int64);
var
  dp: array of Int64;
  i: Integer;
  pattern: string;
begin
  SetLength(dp, Length(design) + 1);
  dp[0] := 1; // Base case: one way to construct an empty design

  for i := 1 to Length(design) do
  begin
    dp[i] := 0;
    for pattern in patterns do
    begin
      if (i >= Length(pattern)) and
         (Copy(design, i - Length(pattern) + 1, Length(pattern)) = pattern) then
      begin
        dp[i] := dp[i] + dp[i - Length(pattern)];
      end;
    end;
  end;

  isPossible := dp[Length(design)] > 0;
  numWays := dp[Length(design)];
end;

procedure CalculateResults(patterns: TStringArray; designs: TStringArray; out numPossible: Integer; out totalArrangements: Int64);
var
  i: Integer;
  ways: Int64;
  possible: Boolean;
begin
  numPossible := 0;
  totalArrangements := 0;

  for i := 0 to High(designs) do
  begin
    AnalyzeDesign(patterns, designs[i], possible, ways);
    if possible then
      Inc(numPossible);
    totalArrangements := totalArrangements + ways;
  end;
end;

procedure ReadInput(out patterns: TStringArray; out designs: TStringArray);
var
  input: TStringList;
  i: Integer;
begin
  input := TStringList.Create;
  try
    input.LoadFromFile('/dev/stdin'); // Read standard input as a file

    if input.Count < 2 then
      raise Exception.Create('Invalid input format');

    // First line: patterns
    patterns := Split(input[0], ',');

    // Remaining lines: designs (skipping blank lines)
    SetLength(designs, 0);
    for i := 1 to input.Count - 1 do
      if Trim(input[i]) <> '' then
      begin
        SetLength(designs, Length(designs) + 1);
        designs[High(designs)] := Trim(input[i]);
      end;
  finally
    input.Free;
  end;
end;

var
  patterns, designs: TStringArray;
  numPossible: Integer;
  totalArrangements: Int64;
begin
  try
    // Read input
    ReadInput(patterns, designs);

    // Calculate results for both parts
    CalculateResults(patterns, designs, numPossible, totalArrangements);

    // Output results
    WriteLn('Number of possible designs (Part 1): ', numPossible);
    WriteLn('Total number of arrangements (Part 2): ', totalArrangements);
  except
    on E: Exception do
      WriteLn('Error: ', E.Message);
  end;
end.
