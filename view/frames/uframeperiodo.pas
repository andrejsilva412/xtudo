unit uframeperiodo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, DateUtils, DateTimePicker;

type

  { TFrameDataInicialFinal }

  TFrameDataInicialFinal = class(TFrame)
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
  private
    procedure IniciaData;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

implementation

{$R *.lfm}

{ TFrameDataInicialFinal }

procedure TFrameDataInicialFinal.IniciaData;
begin
  DateTimePicker1.Date := StartOfAMonth(YearOf(Date), MonthOf(Date));
  DateTimePicker2.Date := Date;
end;

constructor TFrameDataInicialFinal.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  IniciaData;
end;

end.

