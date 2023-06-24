unit utema;

{$mode delphi}

interface

uses
  Classes, SysUtils, Graphics, ExtCtrls, BCButton, BCTypes,
  buttons, uhtmlutils, json.files, BCButtonFocus, utypes,
  BGRABitmapTypes;

type

  { TTema }

  TTema = class
    private
      FBackGround1: TColor;
      FBackGround2: TColor;
      FForeGround: TColor;
      FSecondary1: TColor;
      FSecondary2: TColor;
      FSecondary3: TColor;
      FSecondary4: TColor;
      FSecondary5: TColor;
      FSecondary6: TColor;
      FSecondary7: TColor;
      FJSON: TFPJson;
      FFileTheme: String;
      FHTMLUtils: THTMLUtils;
      procedure LoadTheme;
    public
      constructor Create;
      destructor Destroy; override;
      procedure SetTheme(AFileName: String = 'theme\default.json');
      procedure SetBcButtonStyle(Button: TBCButtonFocus);
      property BackGround1: TColor read FBackGround1;
      property BackGround2: TColor read FBackGround2;
      property ForeGround: TColor read FForeGround;
      property Secondary1: TColor read FSecondary1;
      property Secondary2: TColor read FSecondary2;
      property Secondary3: TColor read FSecondary3;
      property Secondary4: TColor read FSecondary4;
      property Secondary5: TColor read FSecondary5;
      property Secondary6: TColor read FSecondary6;
      property Secondary7: TColor read FSecondary7;
  end;

implementation

uses uimage;

{ TTema }

procedure TTema.LoadTheme;
begin

  if not DirectoryExists('theme') then
    CreateDir('theme');

  with FHTMLUtils do
  begin

    FBackGround1 := HTMLToColor('#272727');
    FBackGround2 := HTMLToColor('#2F0505');
    FForeGround := HTMLToColor('#85311B');
    FSecondary1 := HTMLToColor('#C1853B');
    FSecondary2 := HTMLToColor('#DB9327');
    FSecondary3 := HTMLToColor('#CC1B1B');
    FSecondary4 := HTMLToColor('#9E9E9E');
    FSecondary5 := HTMLToColor('#E2C52C');
    FSecondary6 := HTMLToColor('#0CA147');
    FSecondary7 := HTMLToColor('#F4F4F4');

    // Verifica qual é o arquivo do tema selecionado.
    FJSON.FileName := FFileTheme;

    if not FileExists(FFileTheme) then
    begin
      FJSON.WriteString('background1', ColorToHTML(FBackGround1));
      FJSON.WriteString('background2', ColorToHTML(FBackGround2));
      FJSON.WriteString('foreground', ColorToHTML(FForeGround));
      FJSON.WriteString('secondary1', ColorToHTML(FSecondary1));
      FJSON.WriteString('secondary2', ColorToHTML(FSecondary2));
      FJSON.WriteString('secondary3', ColorToHTML(FSecondary3));
      FJSON.WriteString('secondary4', ColorToHTML(FSecondary4));
      FJSON.WriteString('secondary5', ColorToHTML(FSecondary5));
      FJSON.WriteString('secondary6', ColorToHTML(FSecondary6));
      FJSON.WriteString('secondary7', ColorToHTML(FSecondary7));
    end;

    FBackGround1 := HTMLToColor(FJSON.ReadString('background1', ColorToHTML(FBackGround1)));
    FBackGround2 := HTMLToColor(FJSON.ReadString('background2', ColorToHTML(FBackGround2)));
    FForeGround := HTMLToColor(FJSON.ReadString('foreground', ColorToHTML(FForeGround)));
    FSecondary1 := HTMLToColor(FJSON.ReadString('secondary1', ColorToHTML(FSecondary1)));
    FSecondary2 := HTMLToColor(FJSON.ReadString('secondary2', ColorToHTML(FSecondary2)));
    FSecondary3 := HTMLToColor(FJSON.ReadString('secondary3', ColorToHTML(FSecondary3)));
    FSecondary4 := HTMLToColor(FJSON.ReadString('secondary4', ColorToHTML(FSecondary4)));
    FSecondary5 := HTMLToColor(FJSON.ReadString('secondary5', ColorToHTML(FSecondary5)));
    FSecondary6 := HTMLToColor(FJSON.ReadString('secondary6', ColorToHTML(FSecondary6)));
    FSecondary7 := HTMLToColor(FJSON.ReadString('secondary7', ColorToHTML(FSecondary7)));
  end;

end;

constructor TTema.Create;
begin
  FJSON := TFPJson.Create;
  FHTMLUtils := THTMLUtils.Create;
end;

destructor TTema.Destroy;
begin
  FreeAndNil(FHTMLUtils);
  FreeAndNil(FJSON);
  inherited Destroy;
end;

procedure TTema.SetTheme(AFileName: String);
begin

  FFileTheme := AFileName;
  LoadTheme;

end;

procedure TTema.SetBcButtonStyle(Button: TBCButtonFocus);
var
  AFontColor: TColor;
begin

  with Button do
  begin
    with StateNormal do
    begin
      with Background do
      begin
        Style := bbsColor;
        Color := FHTMLUtils.HTMLToColor('#85311B');
      end;
      with Border do
      begin
        Style := bboSolid;
        Color := Background.Color;
      end;
      with FontEx do
      begin
        Color := InvertColor(Background.Color);
        FontQuality := fqSystemClearType;
      end;
    end;

    with StateHover do
    begin
      with Background do
      begin
        Style := bbsColor;
        Color := FHTMLUtils.HTMLToColor('#85311B');
        ColorOpacity := 235;
      end;
      with Border do
      begin
        Style := bboSolid;
        Color := Background.Color;
      end;
      with FontEx do
      begin
        AFontColor := InvertColor(Background.Color);
        FontQuality := fqSystemClearType;
        Shadow := false;
      end;
    end;
    StateClicked.Assign(StateNormal);
  end;

end;

end.

