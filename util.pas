unit Util;

{$mode objfpc}{$H+}

interface
function downloadImg(URL, TargetFile: string): Boolean;

implementation

uses
  httpsend, Dialogs, sysutils, ssl_openssl;

function downloadImg(URL, TargetFile: string): Boolean;
var
  HTTPGetResult: Boolean;
  HTTPSender: THTTPSend;
begin
  Result := False;
  HTTPSender := THTTPSend.Create;
  try

    HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
    //se HTTP status code responde for aceitavel, podemos tentar baixar a imagem
    //e salvar em um arquivo
    if (HTTPSender.ResultCode >= 100) and (HTTPSender.ResultCode<=299) then begin
      HTTPSender.Document.SaveToFile('assets/img/' + TargetFile);
      Result := True;
    end
    else begin
      ShowMessage(IntToStr(HTTPSender.ResultCode));
    end;
  finally
    HTTPSender.Free;
  end;
end;

end.

