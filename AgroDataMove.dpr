program AgroDataMove;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  uDm in 'uDm.pas' {dmCon: TDataModule},
  uMoveDados in 'Units\uMoveDados.pas',
  uLog in 'Units\uLog.pas' {,
  uEnum in 'uEnum.pas',
  uParametrosConexao in 'Conexoes\IMPL\uParametrosConexao.pas',
  uConexoes in 'Conexoes\IMPL\uConexoes.pas',
  uIConexoes in 'Conexoes\Interfaces\uIConexoes.pas',
  uIParametrosConexoes in 'Conexoes\Interfaces\uIParametrosConexoes.pas';},
  uEnum in 'Units\uEnum.pas',
  uParametrosConexao in 'Conexoes\IMPL\uParametrosConexao.pas',
  uConexoes in 'Conexoes\IMPL\uConexoes.pas',
  uThreadMoveDados in 'Units\uThreadMoveDados.pas',
  uCarregaConfiguracoes in 'Units\uCarregaConfiguracoes.pas',
  uThreadMoveTabela in 'Units\uThreadMoveTabela.pas',
  uThreadCompararTabelas in 'Units\uThreadCompararTabelas.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
