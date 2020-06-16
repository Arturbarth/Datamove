unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, FireDAC.Comp.Client,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDm, Vcl.StdCtrls, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  Vcl.ComCtrls, Vcl.ExtCtrls, uParametrosConexao, Data.DB, uConexoes,
  Vcl.Grids, Vcl.DBGrids;
type
  TfrmMain = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    pnl1: TPanel;
    pnl2: TPanel;
    btnMoverTabelas: TButton;
    btnTestarOrigem: TButton;
    btnTestarDestino: TButton;
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
  private
    FDm: TdmCon;
    FModelCon: TModelConexao;
    FDCon: TFDConnection;
    procedure TestarConexao(AoParm: IParametrosConexao);
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
    FModelCon := TModelConexao.Create(TCarregaConfiguracoes.new.GetConfiguracaoOrigem);
    FDCon := FModelCon.GetConexao;
    FDm.qryGridTabelas.Connection := FDCon;

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
    //threadComparar.FConsulta := meConsulta.Text;
    threadComparar.FParmFirebird := TCarregaConfiguracoes.new.GetConfiguracaoOrigem;
    threadComparar.FParOracle    := TCarregaConfiguracoes.new.GetConfiguracaoDestino;
    threadComparar.Start;
  finally
//    threadMov.Free;
  end;
end;

procedure TfrmMain.btnMoverTabelasClick(Sender: TObject);
var
  threadMov: TThreadMoveDados;
begin
//  FDm.MoverTabelasSistema;
  meLog.Clear;
  meErros.Clear;
  try
    threadMov := TThreadMoveDados.Create(true);
    threadMov.FmeLog := meLog;
    threadMov.FmeErros := meErros;
    threadMov.FpbStatus := pbStatus;
    threadMov.FConsulta := meConsulta.Text;
    threadMov.FParmFirebird := TCarregaConfiguracoes.new.GetConfiguracaoOrigem;
    threadMov.FParOracle    := TCarregaConfiguracoes.new.GetConfiguracaoDestino;
    threadMov.Start;
  finally
//    threadMov.Free;
  end;
end;

procedure TfrmMain.btnTestarDestinoClick(Sender: TObject);
begin
  try
    TestarConexao(TCarregaConfiguracoes.new.GetConfiguracaoDestino);
  except
    on e: Exception do
      begin
      ShowMessage('Erro ao conectar na destino: '  + e.message);
    end;
  end;
end;

procedure TfrmMain.btnTestarOrigemClick(Sender: TObject);
begin
  try
    TestarConexao(TCarregaConfiguracoes.new.GetConfiguracaoOrigem);
  except
    on e: Exception do
      begin
      ShowMessage('Erro ao conectar na origem: '  + e.message);
    end;
  end;
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
    ShowMessage('Conex�o Ok!!!');
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
