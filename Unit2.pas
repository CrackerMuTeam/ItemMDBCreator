unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, DB, ADODB, DBCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    DataSource1: TDataSource;
    ADOTable1: TADOTable;
    DBGrid1: TDBGrid;
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
  StatusBar1.SimpleText:=Form1.OpenDialog1.FileName;
  adotable1.Close;
  adotable1.ConnectionString:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+Form1.OpenDialog1.FileName+';Mode=ReadWrite;Persist Security Info=False';
  adotable1.TableName:='muitem';
  adotable1.Open;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
adotable1.Close;
end;

end.
