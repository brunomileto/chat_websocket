unit uServer;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Web.HTTPApp,
  Web.HTTPProd, sgcBase_Classes, sgcSocket_Classes, sgcTCP_Classes,
  sgcWebSocket_Classes, sgcWebSocket_Server, sgcWebSocket,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, System.SysUtils,
  FMX.Layouts, FMX.Edit, IdContext, IdCustomHTTPServer, sgcWebSocket_Classes_Indy;

type
  TFrmServer = class(TForm)
    sgcWsHTTPServer: TsgcWebSocketHTTPServer;
    mmLog: TMemo;
    pgChats: TPageProducer;
    btnChrome: TButton;
    procedure btnChromeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pgChatsHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure sgcWsHTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure sgcWsHTTPServerConnect(Connection: TsgcWSConnection);
    procedure sgcWsHTTPServerDisconnect(Connection: TsgcWSConnection;
      Code: Integer);
    procedure sgcWsHTTPServerError(Connection: TsgcWSConnection;
      const Error: string);
    procedure sgcWsHTTPServerMessage(Connection: TsgcWSConnection;
      const Text: string);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmServer: TFrmServer;

implementation

{$IFNDEF MACOS}
uses
  ShellAPI;
{$ENDIF}

{$R *.fmx}


procedure TFrmServer.FormShow(Sender: TObject);
begin
  sgcWsHTTPServer.Active := True;
end;

procedure TFrmServer.btnChromeClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PWideChar('chrome'),
    PWideChar('http://127.0.0.1:' + IntToStr(sgcWsHTTPServer.Port)), '', 0);
end;

procedure TFrmServer.pgChatsHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if TagString = 'port' then
    ReplaceText := IntToStr(sgcWsHTTPServer.Port)
  else
    ReplaceText := '127.0.0.1';
end;

procedure TFrmServer.sgcWsHTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := pgChats.Content;
end;

procedure TFrmServer.sgcWsHTTPServerConnect(Connection: TsgcWSConnection);
begin
  mmLog.Lines.Add('Connected: ' + Connection.IP);
end;

procedure TFrmServer.sgcWsHTTPServerDisconnect(Connection: TsgcWSConnection;
  Code: Integer);
begin
  mmLog.Lines.Add('Disconnected: ' + Connection.IP);
end;

procedure TFrmServer.sgcWsHTTPServerError(Connection: TsgcWSConnection;
  const Error: string);
begin
  mmLog.Lines.Add('Error: ' + Error);
end;

procedure TFrmServer.sgcWsHTTPServerMessage(Connection: TsgcWSConnection;
  const Text: string);
begin
  mmLog.Lines.Add('Message: ' + Text);
  sgcWsHTTPServer.Broadcast(Text);
end;

procedure TFrmServer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  sgcWsHTTPServer.Active := False;
  Sleep(5000);
end;

end.
