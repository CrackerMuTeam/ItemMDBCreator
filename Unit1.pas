unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, OleServer, ADOX_TLB, ADODB, DB, {Appex,}
  ComCtrls, XPMan;
type Tlinhamdb = record
  index:byte;
  classe:byte;
  nome: string;
  tipo: string;
  x:byte;
  y:byte;
  wearto: string;
  setnumber:byte;
  setitem:string;
  ExcOpt:string;
  end;

type Tnumberof = record
  lines:integer;
  camps:integer;
end;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Abriritemkor1: TMenuItem;
    Fechar1: TMenuItem;
    Memo1: TMemo;
    AbrirItemkornormal1: TMenuItem;
    AdicionarMDB1: TMenuItem;
    CriarMDB1: TMenuItem;
    OpesItemKor1: TMenuItem;
    Creditoss1: TMenuItem;
    Creditos1: TMenuItem;
    Sobreoprograma1: TMenuItem;
    Instrues1: TMenuItem;
    SaveDialog1: TSaveDialog;
    ADOCommand1: TADOCommand;
    OpenDialog1: TOpenDialog;
    LerMDB1: TMenuItem;
    XPManifest1: TXPManifest;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    CriarMDBAntigoSTMuEditor1: TMenuItem;
    CriarMDBNovoCZFEditor1: TMenuItem;
    CriarMDBPadraoCMTEditor1: TMenuItem;
    AdoxCatalog1: TAdoxCatalog;
    procedure Fechar1Click(Sender: TObject);
    procedure AbrirItemkornormal1Click(Sender: TObject);
    procedure Abriritemkor1Click(Sender: TObject);
    procedure leritem(s:string);
    procedure leritem2(s:string);
    procedure LerMDB1Click(Sender: TObject);
    procedure CriarMDBAntigoSTMuEditor1Click(Sender: TObject);
    procedure CriarMDBPadraoCMTEditor1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
//  test: tbuffbutton;
  linhamdb: array[0..512,0..1] of Tlinhamdb;
implementation

uses Unit2;

{$R *.dfm}

function numberof(s:string): tnumberof;
var
    f : textfile;
    ch: char;
    i : integer;  //colunas 15 bolas sorteadas
    j : integer;  // linhas qtd de jogos
    barra:byte;
    hab:boolean;
    entre:boolean;
    esp:boolean;
    maxi:integer;
begin
  assignfile(F,s);
  reset(F);
  i:=0 ; j:=0; maxi:=-1;
  s:='';
  barra:=0;
  hab:=true;
  entre:=false;
  esp:=true;
  while not eof(F) do
  begin
    read(F,ch);
    Case ch of
        #9  :   begin
                esp:=true;
                  if entre=true then
                  begin
                    esp:=false;
                  end
                end;
        #32  :  begin
                  esp:=true;
                  if entre=true then
                  begin
                    esp:=false;
                  end
                end;
         #10 :  begin
                  inc(J);
                  if i>maxi then
                    maxi:=i;
                  i:=0;
                  barra:=0;
                  esp:=true;
                  hab:=true;
                end;
         #13 :  begin
                end;
         '/' :  begin
                  if barra=1 then hab:=false;
                  if barra=0 then barra:=1;
                end;
         '"' :  begin
                  if hab=true then
                  begin
                    if entre=true then entre:=false
                    else begin
                      entre:=true;
                      esp:=false;
                      inc(i);
                    end;
                  end;
                end;
         #39 :  begin
                end;
         else   begin
                  if hab=true then
                  begin
                    if (entre=false) and (esp=true) then
                    begin
                      esp:=false;
                      inc(i)
                    end;
                  end;
                end;
    end;
  end;
  CloseFile(F);
  numberof.lines:=j;
  numberof.camps:=i;
end;


function LerTxt(s:string): array[0..4096,1..25] of string;
var
    f : textfile;
    ch: char;
    i : byte;  //colunas 15 bolas sorteadas
    j : word;  // linhas qtd de jogos
    linhanum : array [0..15] of word;
    linhanumend : array [0..16] of word;
    barra:byte;
    hab:boolean;
    entre:boolean;
    esp:boolean;
    ulinhanum:word;
begin
  assignfile(F,s);
  reset(F);
  i:=0 ; j:=0;
  s:='';
  barra:=0;
  hab:=true;
  entre:=false;
  esp:=true;
  ulinhanum:=0;
  while not eof(F) do
  begin
    try
      read(F,ch);
      Case ch of
        #9  :   begin
                  esp:=true;
                  if entre=true then
                  begin
                    LerTxt[j,i]:=LerTxt[j,i]+ch;
                    esp:=false;
                  end
                end;
        #32  :  begin
                  esp:=true;
                  if entre=true then
                  begin
                    LerTxt[j,i]:=LerTxt[j,i]+ch;
                    esp:=false;
                  end
                end;
         #10 :  begin
                  if (LerTxt[j,1]<>'') and (LerTxt[j,2]='') and (LerTxt[j,1]<>'end') then
                  begin
                    linhanum[strtoint(LerTxt[j,1])]:=j;
                    ulinhanum:=strtoint(LerTxt[j,1]);
                  end;
                  if LerTxt[j,1]<>'' then inc(J);
                  i:=0;
                  barra:=0;
                  esp:=true;
                  hab:=true;
                end;
         #13 :  begin
                end;
         '/' :  begin
                  if barra=1 then hab:=false;
                  if barra=0 then barra:=1;
                end;
         '"' :  begin
                  if hab=true then
                  begin
                    if entre=true then entre:=false
                    else begin
                      entre:=true;
                      esp:=false;
                      inc(i);
                    end;
                  end;
                end;
         #39 :  begin
                end;
         else   begin
                  if hab=true then
                  begin
                    if (entre=false) and (esp=true) then
                    begin
                      esp:=false;
                      inc(i)
                    end;
                    LerTxt[j,i]:=LerTxt[j,i]+ch;
                    if (LerTxt[j,1]='end') and (LerTxt[j,2]='')  then
                      linhanumend[ulinhanum]:=j;
                  end;
                end;
      end;
    except
      on EInOutError do
      begin
        LerTxt[0,1]:='ERROR';
        CloseFile(F);
        exit;
      end;
      else
        LerTxt[0,1]:='ERROR2';
        CloseFile(F);
        exit;
    end;
  end;
  CloseFile(F);
  if (LerTxt[0,1]<>'0') and (LerTxt[1,1]<>'0') and (LerTxt[2,1]<>'1') and (LerTxt[3,1]<>'2') then
  begin
    LerTxt[0,1]:='ERROR3';
    CloseFile(F);
  end
end;

procedure TForm1.Abriritemkor1Click(Sender: TObject);
var
i:integer;
begin
OpenDialog1.FileName:='';
OpenDialog1.Filter:='Item(kor).txt (*.txt)|*.txt';
If OpenDialog1.Execute then
begin
  if OpenDialog1.FileName<>'' then
    begin
      for i := 0 to 512 do  //reseta variaveis
        begin
          linhamdb[i,0].classe:=0;
          linhamdb[i,0].index:=0;
          linhamdb[i,0].nome:='';
          linhamdb[i,0].tipo:='';
          linhamdb[i,0].x:=0;
          linhamdb[i,0].y:=0;
          linhamdb[i,0].wearto:='';
          linhamdb[i,0].setnumber:=0;
          linhamdb[i,0].ExcOpt:='';
          linhamdb[i,1].nome:='';
          linhamdb[i,1].tipo:='';
          linhamdb[i,1].x:=0;
          linhamdb[i,1].y:=0;
          linhamdb[i,1].wearto:='';
          linhamdb[i,1].setitem:='';
          linhamdb[i,1].setnumber:=0;
          linhamdb[i,1].ExcOpt:='';
        end;
       memo1.lines.Clear;   //apaga memo Oo
      try
       criarmdb1.Enabled:=True;
       label1.caption:='Item(kor) carregado: '+opendialog1.FileName;
       leritem(OpenDialog1.FileName);  //le items da 97  e de outras
      except
       on EInOutError do begin
        criarmdb1.Enabled:=False;
        messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
        label1.caption:='Nenhum arquivo foi carregado!';
       end;
       else
         begin
          criarmdb1.Enabled:=False;
          label1.caption:='Nenhum arquivo foi carregado!';
         end;
      end;
    end;
 end;
end;

procedure TForm1.AbrirItemkornormal1Click(Sender: TObject);
var
i:integer;
linha: array[0..4096,1..25] of string;
begin
  OpenDialog1.FileName:='';
  OpenDialog1.Filter:='Item(kor).txt (*.txt)|*.txt';
  If OpenDialog1.Execute then
  begin
    if OpenDialog1.FileName<>'' then
    begin
      for i := 0 to 512 do  //reseta variaveis
      begin
        linhamdb[i,0].classe:=0;
        linhamdb[i,0].index:=0;
        linhamdb[i,0].nome:='';
        linhamdb[i,0].tipo:='';
        linhamdb[i,0].x:=0;
        linhamdb[i,0].y:=0;
        linhamdb[i,0].wearto:='';
        linhamdb[i,0].setnumber:=0;
        linhamdb[i,0].ExcOpt:='';
        linhamdb[i,1].nome:='';
        linhamdb[i,1].tipo:='';
        linhamdb[i,1].x:=0;
        linhamdb[i,1].y:=0;
        linhamdb[i,1].wearto:='';
        linhamdb[i,1].setitem:='';
        linhamdb[i,1].setnumber:=0;
        linhamdb[i,1].ExcOpt:='';
      end;
      memo1.lines.Clear;   //apaga memo Oo
      try //Tentar Comandos:
        CriarMDBAntigoSTMuEditor1.Enabled:=true;
        CriarMDBpadraocmtEditor1.Enabled:=true;
        criarmdb1.Enabled:=True; //Libera o Botao de Crar MDB primero
        label1.caption:='Item(kor) carregado: '+opendialog1.FileName;
        linha:=lertxt(OpenDialog1.FileName);
        if linha[0,1]='ERROR' then
        begin
          criarmdb1.Enabled:=False;
          label1.caption:='Nenhum arquivo foi carregado!';
          messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
        end;
        if linha[0,1]='ERROR2' then
        begin
          criarmdb1.Enabled:=False;
          label1.caption:='Nenhum arquivo foi carregado!';
        end;
        if linha[0,1]='ERROR3' then
        begin
          label1.Caption:='Nenhum arquivo foi carregado!';
          messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
        end;
        leritem2(OpenDialog1.FileName);  //le items da 97  e de outras, Executa a Procedure
      except  //caso nos procedimentos do Try de erro ele faz isso, e qnd ta no modo de compilar ele mostra numa mensagem o Tipo de erro, no nosso caso foi I/O EInOutFile 104
        on EInOutError do begin  //ai eu botei On EInOutError.... Do Begin
          criarmdb1.Enabled:=False; //desativa o botao
          messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK); // aparece mensagem personalizada
          label1.caption:='Nenhum arquivo foi carregado!';
        end;
        else // o Else eh pra se qualquer otro erro acontecer diferente do la de cima ele naum faz nada pq se naum aparece 2 msg se eu bota pra aparece msg no Else, pq eh mais de um erro q da
        begin
          criarmdb1.Enabled:=False;
          label1.caption:='Nenhum arquivo foi carregado!';
        end;
      end;
    end;
  end;
end;




procedure tform1.leritem2(s:string);
var
    f : textfile;
    ch: char;
    i : byte;  //colunas 15 bolas sorteadas
    j : word;  // linhas qtd de jogos
    linha : array[0..1000,1..25] of string;
    linhanum : array [0..15] of word;
    linhanumend : array [0..16] of word;
    barra:byte;
    hab:boolean;
    entre:boolean;
    esp:boolean;
    id:word;
    idx:integer;
    ulinhanum:word;
    unique:byte;

begin
  assignfile(F,s);
  reset(F);
  i:=0 ; j:=0;
  s:='';
  barra:=0;
  hab:=true;
  entre:=false;
  esp:=true;
  ulinhanum:=0;
  while not eof(F) do
    begin
     try
     read(F,ch);
      Case ch of
        #9  :   begin
                  esp:=true;
                  if entre=true then
                    begin
                      linha[j,i]:=linha[j,i]+ch;
                      esp:=false;
                    end
                end;
        #32  :  begin
                  esp:=true;
                  if entre=true then
                    begin
                      linha[j,i]:=linha[j,i]+ch;
                      esp:=false;
                    end
                end;
        #10 :  begin
                 if (linha[j,1]<>'') and (linha[j,2]='') and (linha[j,1]<>'end') then
                   begin
                     linhanum[strtoint(linha[j,1])]:=j;
                     ulinhanum:=strtoint(linha[j,1]);
                   end;

                 if linha[j,1]<>'' then inc(J);
                 i:=0;
                 barra:=0;
                 esp:=true;
                 hab:=true;
               end;
        #13 :  begin

               end;
        '/' :  begin

                  if barra=1 then hab:=false;
                 if barra=0 then barra:=1;



               end;
        '"' :  begin
                 if hab=true then
                   begin
                     if entre=true then entre:=false
                     else begin
                       entre:=true;
                       esp:=false;
                       inc(i);
                     end;
                   end;
               end;
        #39 :  begin

               end;
        else   begin
                 if hab=true then
                 begin
                   if entre=false then
                     begin
                      if esp=true then
                        begin
                          esp:=false;
                          inc(i)
                        end;
                     end;
                   linha[j,i]:=linha[j,i]+ch;
                   if (linha[j,1]='end') and (linha[j,2]='')  then
                     linhanumend[ulinhanum]:=j;
                 end;
               end;
      end;
    except
     on EInOutError do begin
      criarmdb1.Enabled:=False;
      label1.caption:='Nenhum arquivo foi carregado!';
      messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
     end;
     else
      criarmdb1.Enabled:=False;
      label1.caption:='Nenhum arquivo foi carregado!';
      //messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
  end;
  end;
  CloseFile(F);
  if (linha[0,1]<>'0') and (linha[1,1]<>'0') and (linha[2,1]<>'1') and (linha[3,1]<>'2') then
  begin
   label1.Caption:='Nenhum arquivo foi carregado!';
   messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
  end
  else begin
  i:=0;
  for j:=0 to 1000 do   //  pra cada Linha ateh 1000
    if linha[j,2]<>'' then inc(i);
  progressbar1.Max:=i;
  for j := 0 to 1000 do
    if (linha[j,2]<>'') then
    begin
      i:=0;
      while i< 17 do
      begin
        if (linhanum[i]<=j) and (linhanumend[i]>j)   then
        begin
          if strtoint(linha[j,1])>31 then
          begin
            unique:=1;
            id:=i*32+strtoint(linha[j,1])-32;
          end;
          if strtoint(linha[j,1])<=31 then
          begin
            unique:=0;
            id:=i*32+strtoint(linha[j,1]);
          end;
          linhamdb[id,unique].index:=strtoint(linha[j,1]);
          linhamdb[id,unique].classe:=i;
          linhamdb[id,unique].nome:=linha[j,7];
          if i=0 then
          begin
            linhamdb[id,unique].tipo:='Swords';
            linhamdb[id,unique].ExcOpt:='we';
            if linha[j,2]='2' then linhamdb[id,unique].wearto:='TR';
            if linha[j,2]='1' then linhamdb[id,unique].wearto:='OB';
          end;
          if i=1 then
          begin
            linhamdb[id,unique].tipo:='Axes';
            linhamdb[id,unique].ExcOpt:='we';
            if linha[j,2]='2' then linhamdb[id,unique].wearto:='TR';
            if linha[j,2]='1' then linhamdb[id,unique].wearto:='OB';
          end;
          if i=2 then
          begin
            linhamdb[id,unique].tipo:='Maces';
            linhamdb[id,unique].ExcOpt:='we';
            if linha[j,2]='2' then linhamdb[id,unique].wearto:='TR';
            if linha[j,2]='1' then linhamdb[id,unique].wearto:='OB';
          end;
          if i=3 then
          begin
            linhamdb[id,unique].tipo:='Spears';
            linhamdb[id,unique].ExcOpt:='we';
            linhamdb[id,unique].wearto:='TR';
          end;
          if (i=4) then
          begin
            if strtoint(linha[j,1])<=7 then
            begin
              linhamdb[id,unique].tipo:='Bows';
              linhamdb[id,unique].wearto:='OR';
            end;
            if (strtoint(linha[j,1])=17) or (strtoint(linha[j,1])=20) then
            begin
              linhamdb[id,unique].tipo:='Bows';
              linhamdb[id,unique].wearto:='OR';
            end;
            if (strtoint(linha[j,1])>=8) or (strtoint(linha[j,1])<=16) then
            begin
              linhamdb[id,unique].tipo:='Crossbows';
              linhamdb[id,unique].wearto:='OL';
            end;
            if (strtoint(linha[j,1])=18) or (strtoint(linha[j,1])=19) then
            begin
              linhamdb[id,unique].tipo:='Crossbows';
              linhamdb[id,unique].wearto:='OL';
            end;
            if (strtoint(linha[j,1])>=21)  then
            begin
              linhamdb[id,unique].tipo:='Bows';
              linhamdb[id,unique].wearto:='OR';
            end;
            linhamdb[id,unique].ExcOpt:='we';
          end;
          if i=5 then
          begin
            linhamdb[id,unique].tipo:='Staffs';
            linhamdb[id,unique].ExcOpt:='we';
            if linha[j,2]='2' then linhamdb[id,unique].wearto:='TR';
            if linha[j,2]='1' then linhamdb[id,unique].wearto:='OB';
          end;
          if i=6 then
          begin
            linhamdb[id,unique].tipo:='Shields';
            linhamdb[id,unique].ExcOpt:='ar';
            linhamdb[id,unique].wearto:='OL';
          end;
          if i=7 then
          begin
            linhamdb[id,unique].tipo:='Helms';
            linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
            linhamdb[id,unique].ExcOpt:='ar';
            linhamdb[id,unique].wearto:='helm';
          end;
          if i=8 then
          begin
            linhamdb[id,unique].tipo:='Armors';
            linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
            linhamdb[id,unique].ExcOpt:='ar';
            linhamdb[id,unique].wearto:='armor';
          end;
          if i=9 then
          begin
            linhamdb[id,unique].tipo:='Pants';
            linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
            linhamdb[id,unique].ExcOpt:='ar';
            linhamdb[id,unique].wearto:='pants';
          end;
          if i=10 then
          begin
            linhamdb[id,unique].tipo:='Gloves';
            linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
            linhamdb[id,unique].ExcOpt:='ar';
            linhamdb[id,unique].wearto:='gloves';
          end;
          if i=11 then
          begin
            linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
            linhamdb[id,unique].tipo:='Boots';
            linhamdb[id,unique].ExcOpt:='ar';
            linhamdb[id,unique].wearto:='boots';
          end;
          if (i=12) then
          begin
            if strtoint(linha[j,1])<=6 then
            begin
              linhamdb[id,unique].tipo:='Wings';
              linhamdb[id,unique].ExcOpt:='wi';
              linhamdb[id,unique].wearto:='wings';
            end
              else begin
                if (linha[j,1]='15') then linhamdb[id,unique].tipo:='Jewels'
                  else if ((strtoint(linha[j,1])>=7) and (strtoint(linha[j,1])<=14)) or ((strtoint(linha[j,1])>=16) and (strtoint(linha[j,1])<=19)) then linhamdb[id,unique].tipo:='Orbs'
                    else if ((strtoint(linha[j,1])>=21) and (strtoint(linha[j,1])<=24)) then linhamdb[id,unique].tipo:='DL Scrolls'
                      else linhamdb[id,unique].tipo:='Items';
                linhamdb[id,unique].ExcOpt:='any';
                linhamdb[id,unique].wearto:='cw';
              end;
          end;
          if (i=13) then
          begin
            if strtoint(linha[j,1])<=4 then
            begin
              linhamdb[id,unique].tipo:='Guardians';
              linhamdb[id,unique].ExcOpt:='any';
              linhamdb[id,unique].wearto:='guardian';
            end;
            if strtoint(linha[j,1])=5 then
            begin
              linhamdb[id,unique].tipo:='Shields';
              linhamdb[id,unique].ExcOpt:='any';
              linhamdb[id,unique].wearto:='OL';
            end;
            if (strtoint(linha[j,1])=7) or (strtoint(linha[j,1])=29) or ((strtoint(linha[j,1])>=14) and (strtoint(linha[j,1])<=19)) or (strtoint(linha[j,1])>=31) then
            begin
              linhamdb[id,unique].tipo:='Items';
              linhamdb[id,unique].ExcOpt:='any';
              linhamdb[id,unique].wearto:='cw';
            end;
            if ((strtoint(linha[j,1])>=8) and (strtoint(linha[j,1])<=11)) or ((strtoint(linha[j,1])>=20) and (strtoint(linha[j,1])<=24))  then
            begin
              linhamdb[id,unique].tipo:='Rings';
              linhamdb[id,unique].ExcOpt:='ar';
              linhamdb[id,unique].wearto:='rings';
            end;
            if (strtoint(linha[j,1])=13) or (strtoint(linha[j,1])=12) or ((strtoint(linha[j,1])>=25) and (strtoint(linha[j,1])<=28)) then
            begin
              linhamdb[id,unique].tipo:='Pendants';
              linhamdb[id,unique].ExcOpt:='we';
              linhamdb[id,unique].wearto:='pendant';
            end;
            if strtoint(linha[j,1])=30 then
            begin
              linhamdb[id,unique].tipo:='Wings';
              linhamdb[id,unique].ExcOpt:='wi';
              linhamdb[id,unique].wearto:='wings';
            end;
          end;
          if i=14 then
          begin
            if strtoint(linha[j,1])<=9 then linhamdb[id,unique].tipo:='Potions'
              else if (linha[j,1]='13') or (linha[j,1]='14') or (linha[j,1]='16') or (linha[j,1]='22') or (linha[j,1]='31') then linhamdb[id,unique].tipo:='Jewels'
                else linhamdb[id,unique].tipo:='Items';
            linhamdb[id,unique].ExcOpt:='any';
            linhamdb[id,unique].wearto:='cw';
          end;
          if i=15 then
          begin
            linhamdb[id,unique].tipo:='Scrolls';
            linhamdb[id,unique].ExcOpt:='any';
            linhamdb[id,unique].wearto:='cw';
          end;
          linhamdb[id,unique].x:=strtoint(linha[j,2]);
          linhamdb[id,unique].y:=strtoint(linha[j,3]);
          linhamdb[id,unique].setitem:='any';
          progressbar1.Position:=progressbar1.Position+1;
          memo1.Lines.add('['+inttostr(linhamdb[id,unique].classe)+','+inttostr(linhamdb[id,unique].index)+','+inttostr(unique)+']'+linhamdb[id,unique].nome+' ('+linhamdb[id,unique].tipo+') ('+inttostr(linhamdb[id,unique].x)+','+inttostr(linhamdb[id,unique].y)+') ('+linhamdb[id,unique].wearto+')');
          i:=17;
        end;
        inc(i);
      end;
    end;
    progressbar1.Position:=0;
  end;
end;

procedure tform1.leritem(s:string);
var
    f : textfile;
    ch: char;
    i : byte;  //colunas 15 bolas sorteadas
    j : word;  // linhas qtd de jogos
    linha : array[0..1000,1..25] of string;
    linhanum : array [0..15] of word;
    linhanumend : array [0..16] of word;
    barra:byte;
    hab:boolean;
    entre:boolean;
    esp:boolean;         
    id:word;
    idx:integer;
    ulinhanum:word;
    unique:byte;

begin
  assignfile(F,s);
  reset(F);
  i:=0 ; j:=0;
  s:='';
  barra:=0;
  hab:=true;
  entre:=false;
  esp:=true;
  ulinhanum:=0;
  while not eof(F) do
   begin
    try
      read(F,ch);
      Case ch of
        #9  :   begin
                  esp:=true;
                  if entre=true then
                    begin
                      linha[j,i]:=linha[j,i]+ch;
                      esp:=false;
                    end
                end;
        #32  :  begin
                  esp:=true;
                  if entre=true then
                    begin
                      linha[j,i]:=linha[j,i]+ch;
                      esp:=false;
                    end
                end;
        #10 :  begin
                 if (linha[j,1]<>'') and (linha[j,2]='') and (linha[j,1]<>'end') then
                   begin
                     linhanum[strtoint(linha[j,1])]:=j;
                     ulinhanum:=strtoint(linha[j,1]);
                   end;

                 if linha[j,1]<>'' then inc(J);
                 i:=0;
                 barra:=0;
                 esp:=true;
                 hab:=true;
               end;
        #13 :  begin

               end;
        '/' :  begin

                  if barra=1 then hab:=false;
                 if barra=0 then barra:=1;



               end;
        '"' :  begin
                 if hab=true then
                   begin
                     if entre=true then entre:=false
                     else begin
                       entre:=true;
                       esp:=false;
                       inc(i);
                     end;
                   end;
               end;
        #39 :  begin

               end;
        else   begin
                 if hab=true then
                 begin
                   if entre=false then
                     begin
                      if esp=true then
                        begin
                          esp:=false;
                          inc(i)
                        end;
                     end;
                   linha[j,i]:=linha[j,i]+ch;
                   if (linha[j,1]='end') and (linha[j,2]='')  then
                     linhanumend[ulinhanum]:=j;
                 end;
               end;
        end;
     except
     on EInOutError do begin
      criarmdb1.Enabled:=False;
      label1.caption:='Nenhum arquivo foi carregado!';
      messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
     end;
     else
      criarmdb1.Enabled:=False;
      label1.caption:='Nenhum arquivo foi carregado!';
      //messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
   end;
   end;
  CloseFile(F);

  if (linha[0,1]<>'0') and (linha[1,1]<>'0') and (linha[2,1]<>'1') and (linha[3,1]<>'2') then
  begin
   label1.Caption:='Nenhum arquivo foi carregado!';
   messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
  end
  else begin
  i:=0;
  for j:=0 to 1000 do   //  pra cada Linha ateh 1000
    if linha[j,2]<>'' then inc(i);
  progressbar1.Max:=i;
  for j := 0 to 1000 do
    if (linha[j,2]<>'') then
      begin
        i:=0;
        while i< 17 do
          begin
            if (linhanum[i]<=j) and (linhanumend[i]>j)   then
              begin
                if strtoint(linha[j,1])>31 then
                begin
                  unique:=1;
                  id:=i*32+strtoint(linha[j,1])-32;
                end;
                if strtoint(linha[j,1])<=31 then
                begin
                  unique:=0;
                  id:=i*32+strtoint(linha[j,1]);
                end;
                linhamdb[id,unique].index:=strtoint(linha[j,1]);
                linhamdb[id,unique].classe:=i;
                linhamdb[id,unique].nome:=linha[j,9];
                if i=0 then
                  begin
                    linhamdb[id,unique].tipo:='Swords';
                    linhamdb[id,unique].ExcOpt:='we';
                    if linha[j,4]='2' then linhamdb[id,unique].wearto:='TR';
                    if linha[j,4]='1' then linhamdb[id,unique].wearto:='OB';
                  end;
                if i=1 then
                  begin
                    linhamdb[id,unique].tipo:='Axes';
                    linhamdb[id,unique].ExcOpt:='we';
                    if linha[j,4]='2' then linhamdb[id,unique].wearto:='TR';
                    if linha[j,4]='1' then linhamdb[id,unique].wearto:='OB';
                  end;
                if i=2 then
                  begin
                    linhamdb[id,unique].tipo:='Maces';
                    linhamdb[id,unique].ExcOpt:='we';
                    if linha[j,4]='2' then linhamdb[id,unique].wearto:='TR';
                    if linha[j,4]='1' then linhamdb[id,unique].wearto:='OB';
                  end;
                if i=3 then
                  begin
                    linhamdb[id,unique].tipo:='Spears';
                    linhamdb[id,unique].ExcOpt:='we';
                    linhamdb[id,unique].wearto:='TR';
                  end;
                if (i=4) then
                  begin
                    if (linha[j,2]='1') then
                      begin
                        linhamdb[id,unique].tipo:='Bows';
                        linhamdb[id,unique].wearto:='OR';
                      end
                        else
                          begin
                            linhamdb[id,unique].tipo:='Crossbows';
                            linhamdb[id,unique].wearto:='OL';
                          end;
                    linhamdb[id,unique].ExcOpt:='we';
                  end;
                if i=5 then
                  begin
                    linhamdb[id,unique].tipo:='Staffs';
                    linhamdb[id,unique].ExcOpt:='we';
                    if linha[j,4]='2' then linhamdb[id,unique].wearto:='TR';
                    if linha[j,4]='1' then linhamdb[id,unique].wearto:='OB';
                  end;
                if i=6 then
                  begin
                    linhamdb[id,unique].tipo:='Shields';
                    linhamdb[id,unique].ExcOpt:='ar';
                    linhamdb[id,unique].wearto:='OL';
                  end;
                if i=7 then
                  begin
                   linhamdb[id,unique].tipo:='Helms';
                   linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
                   linhamdb[id,unique].ExcOpt:='ar';
                   linhamdb[id,unique].wearto:='helm';
                  end;
                if i=8 then
                  begin
                    linhamdb[id,unique].tipo:='Armors';
                    linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
                    linhamdb[id,unique].ExcOpt:='ar';
                    linhamdb[id,unique].wearto:='armor';
                  end;
                if i=9 then
                  begin
                    linhamdb[id,unique].tipo:='Pants';
                    linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
                    linhamdb[id,unique].ExcOpt:='ar';
                    linhamdb[id,unique].wearto:='pants';
                  end;
                if i=10 then
                  begin
                    linhamdb[id,unique].tipo:='Gloves';
                    linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
                    linhamdb[id,unique].ExcOpt:='ar';
                    linhamdb[id,unique].wearto:='gloves';
                  end;
                if i=11 then
                  begin
                    linhamdb[id,unique].setnumber:=strtoint(linha[j,1]);
                    linhamdb[id,unique].tipo:='Boots';
                    linhamdb[id,unique].ExcOpt:='ar';
                    linhamdb[id,unique].wearto:='boots';
                  end;
                if (i=12) then
                  begin
                    if (linha[j,2]='7') then
                      begin
                        linhamdb[id,unique].tipo:='Wings';
                        linhamdb[id,unique].ExcOpt:='wi';
                        linhamdb[id,unique].wearto:='wings';
                      end
                        else
                          begin
                            if (linha[j,1]='15') then linhamdb[id,unique].tipo:='Jewels'
                              else if ((strtoint(linha[j,1])>=7) and (strtoint(linha[j,1])<=14)) or ((strtoint(linha[j,1])>=16) and (strtoint(linha[j,1])<=19)) then linhamdb[id,unique].tipo:='Orbs'
                                else if ((strtoint(linha[j,1])>=21) and (strtoint(linha[j,1])<=24)) then linhamdb[id,unique].tipo:='DL Scrolls'
                                  else linhamdb[id,unique].tipo:='Items';
                            linhamdb[id,unique].ExcOpt:='any';
                            linhamdb[id,unique].wearto:='cw';
                          end;
                  end;
                if (i=13) then
                  begin
                    case strtoint(linha[j,2]) of
                      8    : begin
                               linhamdb[id,unique].tipo:='Guardians';
                               linhamdb[id,unique].ExcOpt:='any';
                               linhamdb[id,unique].wearto:='guardian';
                             end;
                      1    : begin
                               linhamdb[id,unique].tipo:='Shields';
                               linhamdb[id,unique].ExcOpt:='any';
                               linhamdb[id,unique].wearto:='OL';
                             end;
                      10   : begin
                               linhamdb[id,unique].tipo:='Rings';
                               linhamdb[id,unique].ExcOpt:='ar';
                               linhamdb[id,unique].wearto:='rings';
                             end;
                      9    : begin
                               linhamdb[id,unique].tipo:='Pendants';
                               linhamdb[id,unique].ExcOpt:='we';
                               linhamdb[id,unique].wearto:='pendant';
                             end;
                      7    : begin
                               linhamdb[id,unique].tipo:='Wings';
                               linhamdb[id,unique].ExcOpt:='wi';
                               linhamdb[id,unique].wearto:='wings';
                             end;
                      else   begin
                               linhamdb[id,unique].tipo:='Items';
                               linhamdb[id,unique].ExcOpt:='any';
                               linhamdb[id,unique].wearto:='cw';
                             end;

                    end;
                  end;
                if i=14 then
                  begin
                    if strtoint(linha[j,1])<=9 then linhamdb[id,unique].tipo:='Potions'
                      else if (linha[j,1]='13') or (linha[j,1]='14') or (linha[j,1]='16') or (linha[j,1]='22') or (linha[j,1]='31') then linhamdb[id,unique].tipo:='Jewels'
                        else linhamdb[id,unique].tipo:='Items';
                    linhamdb[id,unique].ExcOpt:='any';
                    linhamdb[id,unique].wearto:='cw';
                  end;
                if i=15 then
                  begin
                    linhamdb[id,unique].tipo:='Scrolls';
                    linhamdb[id,unique].ExcOpt:='any';
                    linhamdb[id,unique].wearto:='cw';
                  end;
                linhamdb[id,unique].x:=strtoint(linha[j,4]);
                linhamdb[id,unique].y:=strtoint(linha[j,5]);
                progressbar1.Position:=progressbar1.Position+1;
                memo1.Lines.add('['+inttostr(linhamdb[id,unique].classe)+','+inttostr(linhamdb[id,unique].index)+','+inttostr(unique)+']'+linhamdb[id,unique].nome+' ('+linhamdb[id,unique].tipo+') ('+inttostr(linhamdb[id,unique].x)+','+inttostr(linhamdb[id,unique].y)+') ('+linhamdb[id,unique].wearto+')');
                 i:=17;
              end;
            inc(i);
          end;

      end;
      progressbar1.Position:=0;
   end;
   //except
   //messageBox(handle, 'Arquivo não compatível, por favor selecione um Item(kor).txt', 'ATENÇÃO',mb_IconInformation + mb_OK);
   //end;
end;

procedure TForm1.CriarMDBAntigoSTMuEditor1Click(Sender: TObject);
var i,j,id:integer;
unique:byte;
begin
  SaveDialog1.FileName:='MuItem.mdb';
  SaveDialog1.Filter:='MuItem.mdb (*.mdb)|*.mdb';
  If SaveDialog1.Execute then
  Begin
  DeleteFile(Pchar(SaveDialog1.FileName));
  ADOXCatalog1.Create1('Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+SaveDialog1.FileName+';Jet OLEDB:Engine Type=5');
  ADOCommand1.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+SaveDialog1.FileName+';Mode=ReadWrite;Persist Security Info=False';

  ADOCommand1.CommandText:='CREATE TABLE muitem(' +
                            '[ID] TEXT (2), '+
                            '[UNIQUE] INT, '+
                            '[NAME] TEXT (30), '+
                            '[Type] TEXT (10), '+
                            '[X] INT, '+
                            '[Y] INT, '+
                            '[wearto] TEXT (9), '+
                            '[setnumber] INT, '+
                            '[ExcOptionType] TEXT (10), '+
                            '[UNIQUE2] INT, '+
                            '[SetItem] TEXT (10)'+')';
ADOCommand1.execute;
   j:=0;
   for i:=0 to 512 do begin
     if linhamdb[i,0].nome<>'' then inc(j);
     if linhamdb[i,1].nome<>'' then inc(j);
   end;
   Label1.Caption:='Criando MDB: '+SaveDialog1.FileName;
   progressbar1.Max:=j;
   for i:=0 to 512 do begin
    if linhamdb[i,0].nome<>'' then begin
        id:=linhamdb[i,0].classe*32+linhamdb[i,0].index;
        unique:=0;
        if linhamdb[i,0].index>=256 then
        begin
          id:=id-256;
          unique:=8;
        end;
        ADOCommand1.CommandText:='INSERT INTO muitem([ID],[UNIQUE],[NAME],[TYPE],[X],[Y],[wearto],[setnumber],[ExcOptionType],[UNIQUE2],[SetItem])'+
                                                   'values'+
                                                  '('''+inttostr(id)+''','''+inttostr(unique)+''','''+linhamdb[i,0].nome+''','''+linhamdb[i,0].tipo+''','''+inttostr(linhamdb[i,0].x)+''','''+inttostr(linhamdb[i,0].y)+''','''+linhamdb[i,0].wearto+''','''+inttostr(linhamdb[i,0].setnumber)+''','''+linhamdb[i,0].ExcOpt+''',0,'''+linhamdb[i,0].setitem+''')';
        ADOCommand1.execute;
        progressbar1.position:=progressbar1.position+1;
        form1.Update;
    end;
    if linhamdb[i,1].nome<>'' then begin
        id:=linhamdb[i,1].classe*32+linhamdb[i,0].index-32;
        unique:=0;
        if linhamdb[i,1].index>=256 then
        begin
          id:=id-256;
          unique:=8;
        end;
        ADOCommand1.CommandText:='INSERT INTO muitem ([ID],[UNIQUE],[NAME],[TYPE],[X],[Y],[wearto],[setnumber],[ExcOptionType],[UNIQUE2]) values ('''+inttostr(id)+''','''+inttostr(unique)+''','''+linhamdb[i,1].nome+''','''+linhamdb[i,1].tipo+''','''+inttostr(linhamdb[i,1].x)+''','''+inttostr(linhamdb[i,1].y)+''','''+linhamdb[i,1].wearto+''','''+inttostr(linhamdb[i,1].setnumber)+''','''+linhamdb[i,1].ExcOpt+''',1,'''+linhamdb[i,1].setitem+''')';
        ADOCommand1.execute;
        progressbar1.position:=progressbar1.position+1;
        form1.Update;
    end;
   end;
   progressbar1.position:=0;
   Label1.Caption:='MDB Criado: '+SaveDialog1.FileName;
  end;
end;

procedure TForm1.CriarMDBPadraoCMTEditor1Click(Sender: TObject);
var i,j,id:integer;
unique:byte;
begin
  SaveDialog1.FileName:='MuItem.mdb';
  SaveDialog1.Filter:='MuItem.mdb (*.mdb)|*.mdb';
  If SaveDialog1.Execute then
  Begin
  DeleteFile(Pchar(SaveDialog1.FileName));
  ADOXCatalog1.Create1('Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+SaveDialog1.FileName+';Jet OLEDB:Engine Type=5');
  ADOCommand1.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+SaveDialog1.FileName+';Mode=ReadWrite;Persist Security Info=False';

  ADOCommand1.CommandText:='CREATE TABLE muitem(' +
                            '[CLASS] TEXT (2), '+
                            '[ID] INT, '+
                            '[NAME] TEXT (30), '+
                            '[Type] TEXT (10), '+
                            '[X] INT, '+
                            '[Y] INT, '+
                            '[wearto] TEXT (9), '+
                            '[setnumber] INT, '+
                            '[ExcOptionType] TEXT (10), '+
                            '[SetItem] TEXT (10)'+')';
ADOCommand1.execute;
   j:=0;
   for i:=0 to 512 do begin
     if linhamdb[i,0].nome<>'' then inc(j);
     if linhamdb[i,1].nome<>'' then inc(j);
   end;
   Label1.Caption:='Criando MDB: '+SaveDialog1.FileName;
   progressbar1.Max:=j;
   for i:=0 to 512 do begin
    if linhamdb[i,0].nome<>'' then begin
        ADOCommand1.CommandText:='INSERT INTO muitem([CLASS],[ID],[NAME],[TYPE],[X],[Y],[wearto],[setnumber],[ExcOptionType],[SetItem])'+
                                                   'values'+
                                                   '('''+inttostr(linhamdb[i,0].index)+''','''+inttostr(linhamdb[i,0].classe)+''','''+linhamdb[i,0].nome+''','''+linhamdb[i,0].tipo+''','''+inttostr(linhamdb[i,0].x)+''','''+inttostr(linhamdb[i,0].y)+''','''+linhamdb[i,0].wearto+''','''+inttostr(linhamdb[i,0].setnumber)+''','''+linhamdb[i,0].ExcOpt+''','''+linhamdb[i,0].setitem+''')';
        ADOCommand1.execute;
        progressbar1.position:=progressbar1.position+1;
        form1.Update;
    end;
    if linhamdb[i,1].nome<>'' then begin
        ADOCommand1.CommandText:='INSERT INTO muitem ([CLASS],[ID],[NAME],[TYPE],[X],[Y],[wearto],[setnumber],[ExcOptionType],[SetItem]) values ('''+inttostr(linhamdb[i,1].index)+''','''+inttostr(linhamdb[i,1].classe)+''','''+linhamdb[i,1].nome+''','''+linhamdb[i,1].tipo+''','''+inttostr(linhamdb[i,1].x)+''','''+inttostr(linhamdb[i,1].y)+''','''+linhamdb[i,1].wearto+''','''+inttostr(linhamdb[i,1].setnumber)+''','''+linhamdb[i,1].ExcOpt+''','''+linhamdb[i,1].setitem+''')';
        ADOCommand1.execute;
        progressbar1.position:=progressbar1.position+1;
        form1.Update;
    end;
   end;
   progressbar1.position:=0;
   Label1.Caption:='MDB Criado: '+SaveDialog1.FileName;
  end;
end;

procedure TForm1.Fechar1Click(Sender: TObject);
begin
application.Terminate;

end;

procedure TForm1.LerMDB1Click(Sender: TObject);
begin
OpenDialog1.FileName:='';
OpenDialog1.Filter:='MuItem.mdb (*.mdb)|*.mdb';
If OpenDialog1.Execute then
Form2.Show;
end;

end.
