unit usv;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Layouts, FMX.Memo,
  sgcWebSocket_Classes, sgcWebSocket_Server, sgcWebSocket, FMX.Edit,
  Web.HTTPApp, Web.HTTPProd, IdContext, IdCustomHTTPServer,
  sgcWebSocket_Classes_Indy, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.ScrollBox, sgcBase_Classes, sgcSocket_Classes, sgcTCP_Classes;

type
  TfrmServer_FMX = class(TForm)
    WSServer: TsgcWebSocketHTTPServer;
    memoLog: TMemo;
    btnStart: TButton;
    btnStop: TButton;
    pageChat: TPageProducer;
    txtHost: TEdit;
    Label1: TLabel;
    btnChrome: TButton;
    btnFirefox: TButton;
    btnSafari: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure pageChatHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WSServerConnect(Connection: TsgcWSConnection);
    procedure WSServerDisconnect(Connection: TsgcWSConnection; Code: Integer);
    procedure WSServerError(Connection: TsgcWSConnection; const Error: string);
    procedure WSServerMessage(Connection: TsgcWSConnection; const Text: string);
    procedure WSServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure btnChromeClick(Sender: TObject);
    procedure btnFirefoxClick(Sender: TObject);
    procedure btnSafariClick(Sender: TObject);
  private
    procedure DoOpenBrowser(const aBrowserName: string);
  public
    { Public declarations }
  end;

var
  frmServer_FMX: TfrmServer_FMX;

implementation

{$IFNDEF MACOS}
uses
  ShellAPI;
{$ENDIF}

{$R *.fmx}

procedure TfrmServer_FMX.btnChromeClick(Sender: TObject);
begin
  DoOpenBrowser('chrome');
end;

procedure TfrmServer_FMX.btnFirefoxClick(Sender: TObject);
begin
  DoOpenBrowser('firefox');
end;

procedure TfrmServer_FMX.btnSafariClick(Sender: TObject);
begin
  DoOpenBrowser('safari');
end;

procedure TfrmServer_FMX.btnStartClick(Sender: TObject);
begin
  WSServer.Active := True;
end;

procedure TfrmServer_FMX.DoOpenBrowser(const aBrowserName: string);
begin
{$IFNDEF MACOS}
  ShellExecute(0, 'open', PWideChar(aBrowserName),
    PWideChar('http://' + txtHost.Text + ':' + IntToStr(WSServer.Port)), '', 0);
{$ENDIF}
end;

procedure TfrmServer_FMX.btnStopClick(Sender: TObject);
begin
  WSServer.Active := False;
end;

procedure TfrmServer_FMX.pageChatHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if TagString = 'port' then
    ReplaceText := IntToStr(WSServer.Port)
  else if TagString = 'host' then
    ReplaceText := txtHost.Text;
end;

procedure TfrmServer_FMX.WSServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  AResponseInfo.ContentText := pageChat.Content;
end;

procedure TfrmServer_FMX.WSServerConnect(Connection: TsgcWSConnection);
begin
  memoLog.Lines.Add('Connected: ' + Connection.IP);
end;

procedure TfrmServer_FMX.WSServerDisconnect(Connection: TsgcWSConnection;
  Code: Integer);
begin
  memoLog.Lines.Add('Disconnected: ' + Connection.IP);
end;

procedure TfrmServer_FMX.WSServerError(Connection: TsgcWSConnection;
  const Error: string);
begin
  memoLog.Lines.Add('Error: ' + Error);
end;

procedure TfrmServer_FMX.WSServerMessage(Connection: TsgcWSConnection;
  const Text: string);
begin
  memoLog.Lines.Add('Message: ' + Text);
  WSServer.Broadcast(Text);
end;

end.
