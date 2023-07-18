unit model.config;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, json.files;

type

  { TModelConfig }

  TModelConfig = class
    private
      FConfig: String;
    public
      constructor Create;
      function GetConfig(AConfig: String): String;
      procedure SetConfig(AConfig: String; AValue: String);
  end;

implementation

{ TModelConfig }

constructor TModelConfig.Create;
begin

end;

function TModelConfig.GetConfig(AConfig: String): String;
begin



end;

procedure TModelConfig.SetConfig(AConfig: String; AValue: String);
begin

end;

end.

