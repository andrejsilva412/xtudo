unit view.main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, BCPanel, BCButtonFocus, view.basico;

type
  { TPageControl }
  TPageControl = class(ComCtrls.TPageControl)
    public
      procedure AdjustClientRect(var ARect: TRect); override;
  end;

type

  { TfrmMain }

  TfrmMain = class(TfrmBasico)
    BCButtonFocus1: TBCButtonFocus;
    BCButtonFocus2: TBCButtonFocus;
    BCPanel1: TBCPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    pcMain: TPageControl;
    tbMain: TTabSheet;
    tbLogin: TTabSheet;
    procedure BCButtonFocus2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
  private
    procedure InitPanel(APanel: TPanel);
    procedure InitLogin;
  protected
    procedure SetStyle; override;
  public

  end;

var
  frmMain: TfrmMain;

implementation

uses uconst, controller.sistema;

{$R *.lfm}

{ TPageControl }

procedure TPageControl.AdjustClientRect(var ARect: TRect);
begin
  inherited AdjustClientRect(ARect);
  ARect.Top := ARect.Top -1;
  ARect.Left := ARect.Left -4;
  ARect.Bottom := ARect.Bottom +4;
  ARect.Right := ARect.Right +4;
end;

{ TfrmMain }

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if Sistema.ShowWizard then
  begin
    Hide;
    Sistema.Forms.ShowWizard;
  end;
  WindowState := wsMaximized;
  SetFocus(Edit1);
end;

procedure TfrmMain.Panel1Resize(Sender: TObject);
begin
  Panel1.Width := tbLogin.Width div 2;
end;

procedure TfrmMain.InitPanel(APanel: TPanel);
begin
  APanel.Caption := '';
  APanel.ParentColor := false;
  APanel.BevelOuter := bvNone;
  APanel.BevelInner := bvNone;
end;

procedure TfrmMain.InitLogin;
begin
  Label2.Caption := 'Ao sistema ' + C_APP_TITLE;
  Edit2.PasswordChar := '*';
end;

procedure TfrmMain.SetStyle;
begin

  InitPanel(Panel1);
  InitPanel(Panel2);
  Panel1.Color := Sistema.Config.Theme.BackGround2;
  Label1.Font.Color := InvertColor(Panel1.Color);
  Label2.Font.Color := Label1.Font.Color;
  Panel2.Color := Sistema.Config.Theme.Secondary1;
  BCPanel1.Caption := '';
  BCPanel1.BevelInner := bvNone;
  BCPanel1.BevelOuter := bvNone;
  BCPanel1.Background.Color := Sistema.Config.Theme.Secondary5;
  Label3.Font.Color := clWhite;
  Label4.Font.Color := clWhite;
  Label5.Font.Color := clWhite;
  Sistema.Config.Theme.SetBcButtonStyle(BCButtonFocus1);
  Sistema.Config.Theme.SetBcButtonStyle(BCButtonFocus2);

end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  LSistema: TSistema;
begin

  LSistema := TSistema.Create;
  try
    LSistema.Config.CreateGlobalConfigFolder;
    LSistema.Config.Database.CreateConfigTable;
    inherited;
    pcMain.ActivePage := tbLogin;
    pcMain.ShowTabs := false;
    PaintBorder := false;
    InitLogin;
  finally
    FreeAndNil(LSistema);
  end;
end;

procedure TfrmMain.BCButtonFocus2Click(Sender: TObject);
begin
  Sistema.Finaliza;
end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  //inherited;
end;

end.

