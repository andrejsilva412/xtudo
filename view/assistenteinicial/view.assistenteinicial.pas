unit view.assistenteinicial;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, EditBtn, MaskEdit, uframetitulo, view.buttons, controller.sistema;

type

  { TPageControl }

  TPageControl = class(ComCtrls.TPageControl)
    public
      procedure AdjustClientRect(var ARect: TRect); override;
  end;


type

  { TfrmAssistenteInicial }

  TfrmAssistenteInicial = class(TfrmBasButtons)
    btnServidorTeste: TButton;
    btnCliTeste: TButton;
    edBdPassword: TEdit;
    edCliPassword: TEdit;
    edBdUserName: TEdit;
    edCliUserName: TEdit;
    edCliServidor: TMaskEdit;
    edtBancoDeDados: TFileNameEdit;
    frameTitulo1: TframeTitulo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblServidorTesteConexao: TLabel;
    lblClienteTesteConexao1: TLabel;
    PageControl1: TPageControl;
    RadioGroup1: TRadioGroup;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure acGenerico1Execute(Sender: TObject);
    procedure acGenerico2Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Sistema: TSistema;
  protected
    procedure Clear; override;
  public

  end;

const
  C_AVANCAR = 'Avançar';
  C_CONCLUIR = 'Concluir';

var
  frmAssistenteInicial: TfrmAssistenteInicial;

implementation

{$R *.lfm}

{ TPageControl }

procedure TPageControl.AdjustClientRect(var ARect: TRect);
begin
  inherited AdjustClientRect(ARect);
  ARect.Top := ARect.Top -4;
  ARect.Left := ARect.Left -4;
  ARect.Bottom := ARect.Bottom +4;
  ARect.Right := ARect.Right +4;
end;

{ TfrmAssistenteInicial }

procedure TfrmAssistenteInicial.FormCreate(Sender: TObject);
begin

  Sistema := TSistema.Create;
  inherited;
  PageControl1.ShowTabs := false;

  acGenerico1.Caption := 'Avançar';
  acGenerico1.Visible := true;
  acGenerico1.Enabled := true;

  acGenerico2.Caption := 'Voltar';
  acGenerico2.Visible := true;
  acGenerico2.Enabled := false;

end;

procedure TfrmAssistenteInicial.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Sistema);
end;

procedure TfrmAssistenteInicial.Clear;
begin

  inherited Clear;
  edtBancoDeDados.Clear;
  lblServidorTesteConexao.Caption := '';
  lblClienteTesteConexao1.Caption := '';
  edBdUserName.Caption := 'SYSDBA';
  edBdPassword.Caption := 'masterkey';
  edCliUserName.Caption := 'SYSDBA';
  edCliPassword.Caption := 'masterkey';

  edtBancoDeDados.Text := Sistema.Config.Database.FileName;

end;

procedure TfrmAssistenteInicial.acGenerico2Execute(Sender: TObject);
begin

   PageControl1.ActivePageIndex := 0;
   acGenerico2.Enabled := PageControl1.TabIndex > 0;
   acGenerico1.Caption := C_AVANCAR;

end;

procedure TfrmAssistenteInicial.acGenerico1Execute(Sender: TObject);
begin
  if acGenerico1.Caption = C_CONCLUIR then
  begin

  end else begin
    case RadioGroup1.ItemIndex of
      0: PageControl1.ActivePageIndex := 1;
      1: PageControl1.ActivePageIndex := 2;
    end;
    acGenerico2.Enabled := PageControl1.TabIndex > 0;
    if PageControl1.TabIndex = (PageControl1.PageCount -1) then
    begin
      acGenerico1.Caption := C_CONCLUIR;
    end else begin
      acGenerico1.Caption := C_AVANCAR;
    end;
  end;
end;

end.

