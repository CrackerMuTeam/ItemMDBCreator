unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TForm4 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Image2: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  i:byte;
implementation

{$R *.dfm}


procedure TForm4.Button1Click(Sender: TObject);
begin
 if i>1 then
   begin
    image1.Picture:=image3.Picture;
    i:=i-1;
    label1.caption:='Pagina Atual: '+inttostr(i);
   end;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
 if i<2 then
   begin
    image1.Picture:=image2.Picture;
    i:=i+1;
    label1.caption:='Pagina Atual: '+inttostr(i);
   end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  i:=1;
  label1.caption:='Pagina Atual: '+inttostr(i);
  image1.Picture:=image3.Picture;
end;

end.
