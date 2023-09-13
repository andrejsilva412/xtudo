unit view.main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, ActnList, Menus, BCPanel, BCButtonFocus, BCButton,
  BGRASpeedButton, BCTypes, TDIClass, view.basico;

type
  { TPageControl }
  TPageControl = class(ComCtrls.TPageControl)
    public
      procedure AdjustClientRect(var ARect: TRect); override;
  end;

type

  { TTDINoteBook }

  TTDINoteBook = class(TDIClass.TTDINoteBook)
    public
      procedure AdjustClientRect(var ARect: TRect); override;
  end;

type

  { TfrmMain }

  TfrmMain = class(TfrmBasico)
    acCaixa: TAction;
    acFinalizar: TAction;
    acUsuario: TAction;
    ActionList1: TActionList;
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
    Label7: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnBtnCaixa: TPanel;
    pnMenu: TPanel;
    Panel4: TPanel;
    pnCenter: TPanel;
    pnBottom: TPanel;
    pnTop: TPanel;
    pcMain: TPageControl;
    mnuConfig: TPopupMenu;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    tbMain: TTabSheet;
    tbLogin: TTabSheet;
    TDINoteBook1: TTDINoteBook;
    procedure acCaixaExecute(Sender: TObject);
    procedure acFinalizarExecute(Sender: TObject);
    procedure acUsuarioExecute(Sender: TObject);
    procedure BCButtonFocus1Click(Sender: TObject);
    procedure BCButtonFocus2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JSONPropStorage1RestoreProperties(Sender: TObject);
    procedure JSONPropStorage1SaveProperties(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    FExpandirMenu: Boolean;
    procedure SetExpandirMenu(AValue: Boolean);
    procedure InitLogin;
    procedure OnLoginStatus(const Status: String);
    property ExpandirMenu: Boolean read FExpandirMenu write SetExpandirMenu;
  protected
    procedure SetStyle; override;
  public

  end;

var
  frmMain: TfrmMain;

implementation

uses uconst, controller.sistema;

{$R *.lfm}

{ TTDINoteBook }

procedure TTDINoteBook.AdjustClientRect(var ARect: TRect);
begin
  inherited AdjustClientRect(ARect);
  ARect.Top := ARect.Top -4;
  ARect.Left := ARect.Left -4;
  ARect.Bottom := ARect.Bottom +4;
  ARect.Right := ARect.Right +4;
end;

{ TPageControl }

procedure TPageControl.AdjustClientRect(var ARect: TRect);
begin
  inherited AdjustClientRect(ARect);
  ARect.Top := ARect.Top -2;
  ARect.Left := ARect.Left -6;
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
  if Visible then
    SetFocus(Edit1);
end;

procedure TfrmMain.JSONPropStorage1RestoreProperties(Sender: TObject);
begin
  ExpandirMenu := StrToBool(JSONPropStorage1.StoredValue['mainpnmenu_expandir']);
end;

procedure TfrmMain.JSONPropStorage1SaveProperties(Sender: TObject);
begin
  JSONPropStorage1.StoredValue['mainpnmenu_expandir'] :=
    BoolToStr(ExpandirMenu);
end;

procedure TfrmMain.Panel1Resize(Sender: TObject);
begin
  Panel1.Width := tbLogin.Width div 2;
end;

procedure TfrmMain.SpeedButton2Click(Sender: TObject);
begin
  mnuConfig.PopUp;
end;

procedure TfrmMain.SpeedButton4Click(Sender: TObject);
begin
  ExpandirMenu := not ExpandirMenu;
end;

procedure TfrmMain.SetExpandirMenu(AValue: Boolean);
begin
  FExpandirMenu := AValue;
  if AValue then
  begin
    pnMenu.Width := 168;
    SpeedButton5.ShowCaption := true;
  end else begin
    pnMenu.Width := 72;
    SpeedButton5.ShowCaption := false;
  end;
  JSONPropStorage1.Save;
end;

procedure TfrmMain.InitLogin;
begin
  Label2.Caption := 'Ao sistema ' + C_APP_TITLE;
  Edit2.PasswordChar := '*';
  Label7.Caption := '';
end;

procedure TfrmMain.OnLoginStatus(const Status: String);
begin
  Label7.Caption := Status;
end;

procedure TfrmMain.SetStyle;
var
  AColor: TColor;
begin

  InitPanel(Panel1);
  InitPanel(Panel2);
  InitPanel(Panel3);
  InitPanel(Panel4);
  InitPanel(pnBtnCaixa);
  InitPanel(pnTop);
  InitPanel(pnCenter);
  InitPanel(pnBottom);
  InitPanel(pnMenu);

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
  Panel3.Color := Sistema.Config.Theme.Secondary3;
  pnTop.Color := Sistema.Config.Theme.Secondary7;
  pnMenu.Color := Sistema.Config.Theme.BackGround1;
  pnCenter.Color := clWhite;
  SpeedButton1.Flat := true;
  SpeedButton2.Flat := true;
  SpeedButton3.Flat := true;
  SpeedButton4.Flat := true;
  SpeedButton5.Flat := true;
  AColor := Sistema.Config.Theme.Secondary4;
  Sistema.Image.SVG(SpeedButton1, C_SVG_POWER, AColor);
  Sistema.Image.SVG(SpeedButton2, C_SVG_CONFIG, AColor);
  Sistema.Image.SVG(SpeedButton3, C_SVG_NOTIFICATION, AColor);
  Sistema.Image.SVG(SpeedButton4, C_SVG_MENU, clWhite);

  pnBtnCaixa.Color := AColor;
  Sistema.Image.SVG(SpeedButton5.Glyph, c_SVG_POINT_OF_SALE,
    48, 48, clWhite);
  SpeedButton5.Font.Color := clWhite;

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
    pnBottom.Visible := false;
    Menu := nil;
    TDINoteBook1.ShowTabs := false;

    pnBtnCaixa.Visible := false;
    SpeedButton3.Visible := false;

  finally
    FreeAndNil(LSistema);
  end;
end;

procedure TfrmMain.BCButtonFocus2Click(Sender: TObject);
begin
  Sistema.Finaliza;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  acFinalizar.Execute;
  inherited;
end;

procedure TfrmMain.BCButtonFocus1Click(Sender: TObject);
begin

  Sistema.Administrativo.User.Username := Edit1.Text;
  Sistema.Administrativo.User.Password := Edit2.Text;
  Sistema.Administrativo.User.OnStatus  := @OnLoginStatus;
  if Sistema.Administrativo.User.Login then
  begin
    JSONPropStorage1.JSONFileName := Sistema.Administrativo.User.ConfigFile;
    JSONPropStorage1.Active := true;
    tbMain.Show;
  end;

end;

procedure TfrmMain.acCaixaExecute(Sender: TObject);
begin
  ShowMessage('teste');
end;

procedure TfrmMain.acFinalizarExecute(Sender: TObject);
begin
  Sistema.Finaliza;
end;

procedure TfrmMain.acUsuarioExecute(Sender: TObject);
begin
  Sistema.Forms.Usuario;
end;

procedure TfrmMain.FormPaint(Sender: TObject);
begin
  //inherited;
end;

end.

