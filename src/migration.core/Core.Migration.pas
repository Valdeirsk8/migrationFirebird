unit Core.Migration;

interface

uses
  System.Classes, System.SysUtils, System.IoUtils;

type

  TMigration = class
  private

  public
    function Execute():TMigration;
    class function New():TMigration;
  end;

implementation

{ TMigration }

uses common.Types;

function TMigration.Execute: TMigration;
Var
  ArrayOfFiles:TArray<String>;
  S: String;
begin
  ArrayOfFiles := TDirectory.GetFiles(GetCurrentDir, TFindFileExpression.Migration);
  for S in ArrayOfFIles do begin
    writeln(s);
  end;

  Result := Self;
end;

class function TMigration.New: TMigration;
begin
  Result := TMigration.Create();
end;

end.
