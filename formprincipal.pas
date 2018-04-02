unit FormPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  StdCtrls, ExtCtrls, fphttpclient, fpjson, jsonparser;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    TComboPokemons: TComboBox;
    TImgPoke: TImage;
    Label1: TLabel;
    Label2: TLabel;
    TmParser: TMemo;
    TmResposta: TMemo;
    TbRequest: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TbRequestClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Util;


{$R *.lfm}

//ao criar o formulario, preenche com 802 itens o combobox
procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  contador : Integer;
begin
  TComboPokemons.Clear;
  for contador:= 1 to 802 do  //802 nr maximo de pokemons no pokeapi.co
  begin
    TComboPokemons.Items.Add('Pokémon Nr. ' + IntToStr(contador));
  end;
  TComboPokemons.ItemIndex:=0; //deixa o primeiro item selecionado
end;

{ TfrmPrincipal }
//Referencias uteis:
//http://forum.lazarus.freepascal.org/index.php?topic=36035.0
//http://wiki.freepascal.org/fcl-json
//http://wiki.freepascal.org/Synapse#Simple_version


procedure TfrmPrincipal.TbRequestClick(Sender: TObject);
var
  Http: TFPHttpClient;
  Content, auxiliar,sprite, nome : string;
  Json : TJSONData;
  imageSaved: Boolean;
  pokemonSelected : Integer;
begin
  Http:=TFPHttpClient.Create(Nil);
  try
     pokemonSelected := TComboPokemons.ItemIndex + 1;
     Content:=Http.Get('https://pokeapi.co/api/v2/pokemon/'+ IntToStr(pokemonSelected) +'/');
     Json:=GetJSON(Content);
     try
        TmResposta.Clear;
        TmResposta.Text:=Content;
        nome := Json.FindPath('forms[0].name').AsString;
        TmParser.Append('Nome: '+nome);
        auxiliar:=Json.FindPath('forms[0].url').AsString;
        Http.Get(auxiliar);
        Json:=GetJSON(Content);
        sprite := Json.FindPath('sprites.front_default').AsString;
        TmParser.Append('Imagem: ' + sprite);
        imageSaved := downloadImg(sprite, nome+'.png');
        if imageSaved = True then begin  //conseguiu pegar a imagem via funcao downloadImg
         TImgPoke.Picture.LoadFromFile('assets/img/' + nome +'.png');
        end;
     finally
       Json.Free;
     end;
  finally
    Http.Free;
  end;
end;

end.

