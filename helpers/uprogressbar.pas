unit uprogressbar;

{$mode objfpc}{$H+}

interface

uses {$ifdef windows} Windows, {$endif} Controls, win7taskbar,
    Classes, LResources, ComCtrls;

type

  { TCustomProgressBar }

  TCustomProgressBar = class(ComCtrls.TCustomProgressBar)
  private
    FPosition: Integer;
    {$ifdef windows}
    FProgressBarState: TTaskBarProgressState;
    {$else}
    FProgressBarState: TProgressBarStyle;
    {$endif}
    FShowInTaskbar: Boolean;
    procedure SetPosition(AValue: Integer);
    procedure SetProgressBarState(AValue: {$ifdef windows} TTaskBarProgressState {$else} TProgressBarStyle {$endif});
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ProgressBarState: {$ifdef windows} TTaskBarProgressState
         {$else} TProgressBarStyle {$endif} read FProgressBarState write SetProgressBarState;
    property ShowInTaskBar: Boolean read FShowInTaskBar write FShowInTaskBar;
    property Position: Integer read FPosition write SetPosition;
  end;


  { TProgressBar }

  TProgressBar = class(TCustomProgressBar)
  published
    property Align;
    property Anchors;
    property BorderSpacing;
    property BorderWidth;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Hint;
    property Max;
    property Min;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
    property Orientation;
    property ParentShowHint;
    property PopupMenu;
    property Position;
    property ShowHint;
    property Smooth;
    property Style;
    property Step;
    property ProgressBarState;
    property ShowInTaskbar;
    property TabOrder;
    property TabStop;
    property Visible;
    property BarShowText;
  end;

implementation

{ TCustomProgressBar }

procedure TCustomProgressBar.SetPosition(AValue: Integer);
begin
  if FPosition = AValue then Exit;
  FPosition := AValue;
  TCustomProgressBar(Self).Position := FPosition;
  if ShowInTaskBar then
  begin
    {$ifdef windows}
    SetTaskbarProgressValue(FPosition, Max);
    {$endif}
  end;
end;

procedure TCustomProgressBar.SetProgressBarState(AValue:
 {$ifdef windows} TTaskBarProgressState {$else} TProgressBarStyle {$endif}
  );
begin

  if FProgressBarState = AValue then exit;
  FProgressBarState := AValue;

  {$ifdef windows}
  SetTaskbarProgressState(AValue);
  {$endif}

end;

constructor TCustomProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  {$ifdef windows}
  InitializeTaskbarAPI;
  ProgressBarState := tbpsNormal;
  ShowInTaskBar := true;
  {$else}
  ProgressBarState := pbstNormal;
  ShowInTaskBar := false;
  {$endif}
end;

destructor TCustomProgressBar.Destroy;
begin
  inherited Destroy;
end;

end.

