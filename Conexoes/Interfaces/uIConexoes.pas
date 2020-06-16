unit uIConexoes;

interface

uses
  System.Classes, FireDAC.Comp.Client;

type
  iModelConexao = interface
    ['{14819F40-456A-4003-AB12-2A14CB87BA4E}']
    function GetConexao: TFDConnection;
    function AbrirConexao: iModelConexao;
    function FecharConexao: iModelConexao;
  end;

implementation

end.
