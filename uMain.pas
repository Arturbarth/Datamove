{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}


unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDm, Vcl.StdCtrls, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  Vcl.ComCtrls, Vcl.ExtCtrls, uParametrosConexao, Data.DB, uConexoes,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Phys.OracleDef, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.Oracle, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.Comp.Client, FireDAC.Comp.Script,
  FireDAC.UI.Intf, FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TfrmMain = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    pnl1: TPanel;
    pnl2: TPanel;
    btnMoverTabelas: TButton;
    meConsulta: TMemo;
    Label1: TLabel;
    pnl3: TPanel;
    pgLog: TPageControl;
    bsLog: TTabSheet;
    meLog: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    meErros: TMemo;
    btnCarregarTabelas: TButton;
    Panel1: TPanel;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    gridTabelas: TDBGrid;
    cxGroupBox1: TGroupBox;
    pbStatus: TProgressBar;
    btnCompararTabelas: TButton;
    OracleDriver: TFDPhysOracleDriverLink;
    FDConnection2: TFDConnection;
    Button1: TButton;
    Button2: TButton;
    btnInserirTabelas: TButton;
    Button4: TButton;
    FDScript1: TFDScript;
    FDScript2: TFDScript;
    FDQuery1: TFDQuery;
    FDConnection1_1: TFDConnection;
    FDConnection1: TFDConnection;
    procedure btnMoverTabelasClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure btnTestarOrigemClick(Sender: TObject);
    procedure btnTestarDestinoClick(Sender: TObject);
    procedure btnCarregarTabelasClick(Sender: TObject);
    procedure btnCompararTabelasClick(Sender: TObject);
    procedure btnTesteClick(Sender: TObject);
    procedure btnInserirTabelasClick(Sender: TObject);
  private
    FDm: TdmCon;
    FModelCon: TModelConexao;
    FDCon: TFDConnection;
    procedure TestarConexao(AoParm: IParametrosConexao);
    procedure InserirMigraTabelas;
    procedure CriarMigraTabelas;
    function VerificarSeExisteTabela: Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses uThreadMoveDados, uCarregaConfiguracoes, uThreadCompararTabelas,
  IBX.IBExtract;
{$R *.dfm}

procedure TfrmMain.btnCarregarTabelasClick(Sender: TObject);
//var
//  FModelCon: TModelConexao;
//  FDCon: TFDConnection;
begin
  try
    //FModelCon := TModelConexao.Create(TCarregaConfiguracoes.new.GetConfiguracaoOrigem);
    //FDCon := FModelCon.GetConexao;
    FDm.qryGridTabelas.Connection := FDConnection1;

    FDm.qryGridTabelas.SQL.Text := meConsulta.Text;
    //gridTabelas.DataController.DataSource := FDm.dsGridTabelas;
    FDm.qryGridTabelas.Open;

  //  gridTabelas.ClearItems;
    gridTabelas.DataSource := FDm.dsGridTabelas;
  //  gridTabelas.DataController.CreateAllItems();
  finally
    //FModelCon.Free;
  end;
end;

procedure TfrmMain.btnCompararTabelasClick(Sender: TObject);
var
  threadComparar: TThreadCompararTabelas;
begin
//  FDm.MoverTabelasSistema;
  meLog.Clear;
  meErros.Clear;
  try
    threadComparar := TThreadCompararTabelas.Create(true);
    threadComparar.FmeLog := meLog;
    threadComparar.FmeErros := meErros;
    threadComparar.FpbStatus := pbStatus;

    threadComparar.FDConFireBird := FDConnection1;
    threadComparar.FDConOracle   := FDConnection2;
    //threadComparar.FConsulta := meConsulta.Text;
    threadComparar.FParmFirebird := TCarregaConfiguracoes.new.GetConfiguracaoOrigem;
    threadComparar.FParOracle    := TCarregaConfiguracoes.new.GetConfiguracaoDestino;
    threadComparar.Start;
  finally
//    threadMov.Free;
  end;
end;

procedure TfrmMain.btnInserirTabelasClick(Sender: TObject);
begin
  CriarMigraTabelas;
  //InserirMigraTabelas;
end;

procedure TfrmMain.CriarMigraTabelas;
begin
  if not VerificarSeExisteTabela then
  begin
    FDScript1.ValidateAll;
    FDScript1.ExecuteAll;
  end;
end;

function TFrmMain.VerificarSeExisteTabela: Boolean;
var
  oFdMigraTabelas: TFDQuery;
begin
  Result := True;
  try
    oFdMigraTabelas := TFDQuery.Create(Nil);
    oFdMigraTabelas.Connection := FDConnection1;
    oFdMigraTabelas.SQL.Add('SELECT * FROM MIGRATABELAS');
    oFdMigraTabelas.Open();
  except
    Result := False;
  end;
end;

procedure TfrmMain.InserirMigraTabelas;
begin
  if VerificarSeExisteTabela then
    begin
    FDQuery1.ExecSQL;
  end;
end;

procedure TfrmMain.btnMoverTabelasClick(Sender: TObject);
var
  threadMov: TThreadMoveDados;
begin
//  FDm.MoverTabelasSistema;
  meLog.Clear;
  meErros.Clear;

  meLog.Lines.Add('Iniciar');
  try
    threadMov := TThreadMoveDados.Create;
    threadMov.FmeLog := meLog;
    threadMov.FmeErros := meErros;
    threadMov.FpbStatus := pbStatus;
    threadMov.FConsulta := meConsulta.Text;

    threadMov.FDConFireBird := FDConnection1;
    threadMov.FDConOracle   := FDConnection2;

    threadMov.FParmFirebird := TCarregaConfiguracoes.new.GetConfiguracaoOrigem;
    threadMov.FParOracle    := TCarregaConfiguracoes.new.GetConfiguracaoDestino;
    threadMov.MoverTabelasSistema;

  finally
//    threadMov.Free;
  end;
end;

procedure TfrmMain.btnTestarDestinoClick(Sender: TObject);
begin
  FDConnection2.Connected := True;
  ShowMessage('Conexão OK!');
end;

procedure TfrmMain.btnTestarOrigemClick(Sender: TObject);
begin
  FDConnection1.Connected := True;
  ShowMessage('Conexão OK!');
end;

procedure TfrmMain.btnTesteClick(Sender: TObject);
begin
  FDm.IBDatabase1.Connected := True;
  FDm.IBExtract1.ExtractObject(eoTable, 'CONTAMOV', [etTable] );
  meLog.Lines.Add(FDm.IBExtract1.Items.Text);
end;

procedure TfrmMain.TestarConexao(AoParm: IParametrosConexao);
var
  FModelCon: TModelConexao;
  FDCon: TFDConnection;
begin
  try
    FModelCon := TModelConexao.Create(AoParm);
    FDCon := FModelCon.GetConexao;
    FDCon.Connected := true;
    ShowMessage('Conexão Ok!!!');
  finally
    FModelCon.Free;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FDm := TdmCon.Create(nil);
  FDm.FmeLog := meLog;
  FDm.FmeErros := meErros;
end;

procedure TfrmMain.button1Click(Sender: TObject);
var
  dtini, dtfim, total: TDateTime;
begin
  dtini := Now;
  FDm.MoverDadosTabela('PUSUARIO');
  dtfim := Now;
  total := dtfim-dtini;
  ShowMessage('Tempo Total: ' + FormatDateTime('hh:mm:sssss', total));
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  FDm.MoverTabelasSistemaParalelo;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDm.Free;
  if(Assigned(FModelCon))then
    FModelCon.Free;
end;

end.

{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle. Esse não é um projeto desenvolvido pela VIASOFT.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}

