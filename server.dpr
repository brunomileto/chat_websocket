program server;

uses
  System.StartUpCopy,
  FMX.Forms,
  uServer in 'uServer.pas' {FrmServer};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmServer, FrmServer);
  Application.Run;
end.
