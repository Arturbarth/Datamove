{
  Datamove - Conversor de Banco de Dados Firebird para Oracle
  licensed under a APACHE 2.0

  Projeto Particular desenvolvido por Artur Barth e Gilvano Piontkoski para realizar conversão de banco de dados
  firebird para Oracle. Esse não é um projeto desenvolvido pela VIASOFT.

  Toda e qualquer alteração deve ser submetida à
  https://github.com/Arturbarth/Datamove
}


unit uLog;

interface

uses Winapi.Windows, Winapi.Messages, IniFiles, Forms,
     System.Classes;

type

  ILog = interface
  ['{F2BE6249-89F5-41AB-812E-AD06E504BC09}']
    procedure Logar(cTxt: string);
  end;


  TLog = class(TInterfacedObject, ILog)
  private
  public
    class function New: ILog;
    procedure Logar(cTxt: string);
  end;

implementation

uses
  System.SysUtils, System.ioutils, System.StrUtils;

{ TLog }

procedure TLog.Logar(cTxt: string);
var
  ExePath, LogFileName: string;
  Log: TStreamWriter;
begin
  try
    ExePath := TPath.GetDirectoryName(GetModuleName(HInstance));
    LogFileName := FormatDateTime('yyyymmdd', Now)+'_'+ ReplaceStr(ExtractFileName(Forms.Application.ExeName), '.exe', '.log');
    LogFileName := TPath.Combine(ExePath, LogFileName);

    Log := TStreamWriter.Create(LogFileName, true);//TFileStream.Create(LogFileName, fmCreate or fmShareDenyWrite));
    Log.AutoFlush := True;
    try

      Log.WriteLine(FormatDateTime('yyyy-mm-dd hh:mm:ss', Now) + ' ' + cTxt);

    finally
      Log.Free;
    end;
  except
    on E: Exception do
    begin
      TFile.WriteAllText(TPath.Combine(ExePath, 'CRASH_LOG.TXT'), E.ClassName + ' ' + E.Message);
    end
  end;
end;

class function TLog.New: ILog;
begin
  Result := TLog.Create;
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

