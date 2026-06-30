unit Unit1;

//{$mode objfpc}{$H+}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  ComCtrls, TASources, TAGraph, math, TASeries, TATools, TADataTools, types,
  TACustomSeries, TAChartUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    ChartForceManual: TChart;
    ChartForceManualAreaSeries1: TAreaSeries;
    ChartForceManualConstantLine1: TConstantLine;
    ChartForceManualConstantLine2: TConstantLine;
    ChartForceManualLineSeries7: TLineSeries;
    ChartForceManualLineSeries6: TLineSeries;
    ChartForceManualLineSeries5: TLineSeries;
    CheckBox1: TCheckBox;
    ctCrosshair: TDataPointCrosshairTool;
    ctDist: TChartToolset;
    Drag: TDataPointDistanceTool;
    Ctrl_Drag: TDataPointDistanceTool;
    ctDistPanMouseWheelTool1: TPanMouseWheelTool;
    ListChartSource5: TListChartSource;
    ListChartSource6: TListChartSource;
    ListChartSource7: TListChartSource;
    mDistanceText: TMemo;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure ChartForceManualBeforeDrawBackground(ASender: TChart;
      ACanvas: TCanvas; const ARect: TRect; var ADoDefaultDrawing: Boolean);
    procedure ChartForceManualBeforeDrawBackWall(ASender: TChart;
      ACanvas: TCanvas; const ARect: TRect; var ADoDefaultDrawing: Boolean);
    procedure ChartForceManualMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox1EditingDone(Sender: TObject);
    procedure ctCrosshairAfterMouseMove(ATool: TChartTool; APoint: TPoint);
    procedure ctCrosshairDraw(ASender: TDataPointDrawTool);
    procedure DragAfterMouseMove(ATool: TChartTool; APoint: TPoint);
    procedure DragBeforeKeyDown(ATool: TChartTool; APoint: TPoint);
    procedure DragBeforeKeyUp(ATool: TChartTool; APoint: TPoint);
    procedure DragBeforeMouseMove(ATool: TChartTool; APoint: TPoint);
    procedure DragMeasure(ASender: TDataPointDistanceTool);
    procedure Ctrl_DragMeasure(ASender: TDataPointDistanceTool);
    procedure FormCreate(Sender: TObject);
    procedure mDistanceTextChange(Sender: TObject);
    procedure mDistanceTextEditingDone(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
uses
FPVectorial, TADrawerFPVectorial, TADrawUtils, TADrawerCanvas;

procedure SaveAs(AChart: TChart; AFormat: TvVectorialFormat);
const
  ext: array [TvVectorialFormat] of String = (
    '',  // vfUnknown
    'pdf', 'svg', 'svgz', 'cdr', 'wmf', 'odg',
    'dxf',
    'laf', 'laz',
    'ps', 'eps',
    'gcode5', 'gcode6',
    'mathml',
    'odt', 'docx', 'html',
    'raw');
var
  d: TvVectorialDocument;
  v: IChartDrawer;
  fn: String;
begin
  d := TvVectorialDocument.Create;
  try
    d.Width := AChart.Width;
    d.Height := AChart.Height;
    d.AddPage;
    v := TFPVectorialDrawer.Create(d.GetCurrentPageAsVectorial);
    with AChart do
      Draw(v, Rect(0, 0, Width, Height));
    fn := 'test.' + ext[AFormat];
    d.WriteToFile(fn, AFormat);
    ShowMessage(Format('Chart saved as "%s"', [fn]));
  finally
    d.Free;
  end;
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  i : integer;
  j : integer;
  A  : Array[0..10] of double;
  s:string;
  MaxLoop: integer;
  x:double;
  answer:double;

  Distance0:double;
  Distance1:double;
  p:double;
  pLoop:integer;

  xx  : Array[0..101] of double;
  yy  : Array[0..101] of double;
  trapezium  : Array[0..100] of double;
  MaxRecordTime:integer;
  Txt:String;
  //s_Series: TBasicChartSeries;

begin
  For i := 0 to 10 do
  begin
    A[i]:=(i*1.0)+1.0;
  end;

  For i := 0 to 101 do
  begin
    xx[i]:=0.0;
    yy[i]:=0.0;
  end;

  For i := 0 to 100 do
  begin
    trapezium[i]:=0.0;
  end;


  s:='';
  Memo1.Clear;
  MaxLoop:=2;
  x:=1.0;
  answer:=0.0;

  For i := 0 to MaxLoop do
  begin
    if i = 0 then
      begin
        s:= s+'f(x) = ('+FormatFloat('0.0',A[i])+')+';
      end;
    if i = MaxLoop then
      begin
        s:= s+'('+FormatFloat('0.0',A[i])+'*x^'+IntToStr(i)+')';
      end;
    if (i > 0) and (i < MaxLoop) then
      begin
        s:= s+'('+FormatFloat('0.0',A[i])+'*x^'+IntToStr(i)+')+';
      end;
  end;
  Memo1.Append(s);

  For i := 0 to MaxLoop do
  begin
    Memo1.Append('A['+IntTostr(i)+']='+FloatToStr(A[i])+'  A['+IntTostr(i+3)+']='+FloatToStr(A[i+3]));
  end;

  For i := 0 to MaxLoop do
  begin
    answer:=answer+(A[i]*math.Power(x,i)) ;
    Memo1.Append('answer='+FloatToStr(answer));
  end;

  Distance0:=0.5;
  Memo1.Append('p='+FloatToStr(Distance0));
  Distance1:=1.5;
  Memo1.Append('p='+FloatToStr(Distance1));
  pLoop:=100;
  p:= (Distance1-Distance0)/pLoop;
  Memo1.Append('p='+FloatToStr(p));
  answer:=0;

  //0.5-1.5∫ydx
  //Create
  //x= position 0.5 to 1.5  total 100 loop
  //Each loop
  //[distance per loop]= (0.5 - 1.5)/100
  //x= [begin distance]+(loop*[distance per loop])
  //y=f(x)
  //y=1(x^0)+2(x^1)+3(x^2)+...n(x^(n-1))

  For i := 0 to pLoop do
  begin
    xx[i]:=Distance0+(i*p);
    yy[i]:=0.0;
    For j := 0 to MaxLoop do
    begin
      yy[i]:=yy[i]+(A[j]*math.Power(xx[i],j));
      Memo1.Append('i='+IntToStr(i)+' j='+IntToStr(j)+' x='+FloatToStr(xx[i])+ ' A='+FloatToStr(A[j]) + ' y='+FloatToStr(yy[i]));
    end;
  end;

  //Trapezium
  //Area=((a+b)/2)*h
  Memo1.Append('Trapezium Area='+FloatToStr((2.8003+2.8512)*(1.0/2.0)*0.01));
  //Trapezoidal
  Memo1.Append('---Trapezoidal---');
  For i := 0 to pLoop do
  begin
    //a=yy[i]
    //b=yy[i+1]
    //h=p
    trapezium[i]:=(1.0/2.0)*p*(yy[i]+yy[i+1]);
    answer:=answer+trapezium[i];
    Memo1.Append('x='+FloatToStr(xx[i])+' y='+FloatToStr(yy[i])+' y+1='+FloatToStr(yy[i+1])+' trapezium='+FloatToStr(trapezium[i])+' Answer='+FloatToStr(answer));
  end;

  //Rectangular
  Memo1.Append('---Rectangular---');
  answer:=0;
  For i := 0 to pLoop do
  begin
    trapezium[i]:=yy[i]*p;
    answer:=answer+trapezium[i];
    //area:=area+(y_*width_);
    Memo1.Append(' answer='+FloatToStr(answer));
  end;
  //Memo1.Append('answer='+FloatToStr(answer));

  MaxRecordTime:=60*60*12;
  ListChartSource5.Clear;
  ChartForceManual.Extent.YMax:=0;
  For i := 0 to pLoop do
  begin
    Txt:=FormatFloat('0.00',xx[i]);  //floatToStr(xx[i]);
    if ChartForceManual.Extent.YMax < yy[i]+2 then
    begin
      ChartForceManual.Extent.YMax := yy[i]+2;
      ChartForceManual.ExtentSizeLimit.YMax:= yy[i]+2; ;
    end;
    if ChartForceManual.Extent.YMin > yy[i]-1 then
    begin
      ChartForceManual.Extent.YMin := yy[i]-1;
      ChartForceManual.ExtentSizeLimit.YMin:= yy[i]-1; ;
    end;
    if ListChartSource5.Count < MaxRecordTime then ListChartSource5.Add(ListChartSource5.Count,yy[i],Txt,clRed);
    if(ListChartSource5.Count<=60)then ChartForceManual.BottomAxis.Range.Max:=60;
    if(ListChartSource5.Count>60)then ChartForceManual.BottomAxis.Range.Max:=ListChartSource5.Count;
    ChartForceManual.BottomAxis.Range.Min:=0;
    ChartForceManual.Extent.XMin:=0;
    if(ListChartSource5.Count<=60)then ChartForceManual.Extent.XMax:=60;
    if(ListChartSource5.Count>60)then ChartForceManual.Extent.XMax:=ListChartSource5.Count;
  end;

  //for s_Series in ChartForceManual.Series do
  //  s_Series.Active := s_Series.Index = rgSeriesType.ItemIndex;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i : integer;
  j : integer;
  A  : Array[0..10] of double;
  s:string;
  MaxLoop: integer;
  x:double;
  answer:double;

  Distance0:double;
  Distance1:double;
  p:double;
  pLoop:integer;

  xx  : Array[0..201] of double;
  yy  : Array[0..201] of double;
  trapezium  : Array[0..200] of double;
  MaxRecordTime:integer;
  Txt:String;

begin
  For i := 0 to 10 do
  begin
    A[i]:=(i*1.0)+1.0;
  end;

  For i := 0 to 201 do
  begin
    xx[i]:=0.0;
    yy[i]:=0.0;
  end;

  For i := 0 to 200 do
  begin
    trapezium[i]:=0.0;
  end;


  s:='';
  Memo1.Clear;
  MaxLoop:=2;
  x:=1.0;
  answer:=0.0;

  For i := 0 to MaxLoop do
  begin
    if i = 0 then
      begin
        s:= s+'f(x) = ('+FormatFloat('0.0',A[i])+')+';
      end;
    if i = MaxLoop then
      begin
        s:= s+'('+FormatFloat('0.0',A[i])+'*x^'+IntToStr(i)+')';
      end;
    if (i > 0) and (i < MaxLoop) then
      begin
        s:= s+'('+FormatFloat('0.0',A[i])+'*x^'+IntToStr(i)+')+';
      end;
  end;
  Memo1.Append(s);

  For i := 0 to MaxLoop do
  begin
    Memo1.Append('A['+IntTostr(i)+']='+FloatToStr(A[i]));
  end;

  For i := 0 to MaxLoop do
  begin
    answer:=answer+(A[i]*math.Power(x,i)) ;
    Memo1.Append('answer='+FloatToStr(answer));
  end;

  Distance0:=0.5;
  Memo1.Append('p='+FloatToStr(Distance0));
  Distance1:=1.5;
  Memo1.Append('p='+FloatToStr(Distance1));
  pLoop:=200;
  p:= (Distance1-Distance0)/pLoop;
  Memo1.Append('p='+FloatToStr(p));
  answer:=0;

  //0.5-1.5∫ydx
  //Create
  //x= position 0.5 to 1.5  total 200 loop
  //Each loop
  //[distance per loop]= (0.5 - 1.5)/200
  //x= [begin distance]+(loop*[distance per loop])
  //y=f(x)
  //y=1(x^0)+2(x^1)+3(x^2)+...n(x^(n-1))

  For i := 0 to pLoop do
  begin
    xx[i]:=Distance0+(i*p);
    yy[i]:=0.0;
    For j := 0 to MaxLoop do
    begin
      yy[i]:=yy[i]+(A[j]*math.Power(xx[i],j));
    end;
  end;

  //Trapezoidal
  Memo1.Append('---Trapezoidal---');
  For i := 0 to pLoop do
  begin
    trapezium[i]:=(1.0/2.0)*p*(yy[i]+yy[i+1]);
    answer:=answer+trapezium[i];
    Memo1.Append('answer='+FloatToStr(answer));
  end;

  //Rectangular
  Memo1.Append('---Rectangular---');
  answer:=0;
  For i := 0 to pLoop do
  begin
    trapezium[i]:=yy[i]*p;
    answer:=answer+trapezium[i];
    //area:=area+(y_*width_);
    Memo1.Append(' answer='+FloatToStr(answer));
  end;
  //Memo1.Append('answer='+FloatToStr(answer));

  MaxRecordTime:=60*60*12;
  ListChartSource5.Clear;
  ChartForceManual.Extent.YMax:=0;
  For i := 0 to pLoop do
  begin
    Txt:=FormatFloat('0.00',xx[i]);  //floatToStr(xx[i]);
    if ChartForceManual.Extent.YMax < yy[i]+2 then
    begin
      ChartForceManual.Extent.YMax := yy[i]+2;
      ChartForceManual.ExtentSizeLimit.YMax:= yy[i]+2; ;
    end;
    if ChartForceManual.Extent.YMin > yy[i]-1 then
    begin
      ChartForceManual.Extent.YMin := yy[i]-1;
      ChartForceManual.ExtentSizeLimit.YMin:= yy[i]-1; ;
    end;
    if ListChartSource5.Count < MaxRecordTime then ListChartSource5.Add(ListChartSource5.Count,yy[i],Txt,clRed);
    if(ListChartSource5.Count<=60)then ChartForceManual.BottomAxis.Range.Max:=60;
    if(ListChartSource5.Count>60)then ChartForceManual.BottomAxis.Range.Max:=ListChartSource5.Count;
    ChartForceManual.BottomAxis.Range.Min:=0;
    ChartForceManual.Extent.XMin:=0;
    if(ListChartSource5.Count<=60)then ChartForceManual.Extent.XMax:=60;
    if(ListChartSource5.Count>60)then ChartForceManual.Extent.XMax:=ListChartSource5.Count;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  x_:float;
  y_ :float;
  width_:float;
  area:float;
  upper_limit:float;
  lower_limit :float;

  MaxRecordTime:integer;
  Txt:String;
begin
  Memo1.Clear;

  width_:=0.01;
  lower_limit:=0;
  upper_limit:=3;

  MaxRecordTime:=60*60*12;
  ListChartSource5.Clear;
  ChartForceManual.Extent.YMax:=0;

  //Rectangular
  Memo1.Append('---Rectangular---');
  area:=0;
  x_:= lower_limit;
  while x_ <= upper_limit do
  begin
    y_ :=  math.Power(x_,2)+1;
    area:=area+(y_*width_);
    Memo1.Append('x='+FloatToStr(x_)+' y='+FloatToStr(y_)+' area='+FloatToStr(area));

    Txt:=FormatFloat('0.00',x_);
    if ChartForceManual.Extent.YMax < y_+2 then
    begin
      ChartForceManual.Extent.YMax := y_+2;
      ChartForceManual.ExtentSizeLimit.YMax:= y_+2; ;
    end;
    if ChartForceManual.Extent.YMin > y_-1 then
    begin
      ChartForceManual.Extent.YMin := y_-1;
      ChartForceManual.ExtentSizeLimit.YMin:= y_-1; ;
    end;
    if ListChartSource5.Count < MaxRecordTime then ListChartSource5.Add(ListChartSource5.Count,y_,Txt,clRed);
    if(ListChartSource5.Count<=60)then ChartForceManual.BottomAxis.Range.Max:=60;
    if(ListChartSource5.Count>60)then ChartForceManual.BottomAxis.Range.Max:=ListChartSource5.Count;
    ChartForceManual.BottomAxis.Range.Min:=0;
    ChartForceManual.Extent.XMin:=0;
    if(ListChartSource5.Count<=60)then ChartForceManual.Extent.XMax:=60;
    if(ListChartSource5.Count>60)then ChartForceManual.Extent.XMax:=ListChartSource5.Count;

    x_ := x_ + width_;
  end;

end;

procedure TForm1.Button5Click(Sender: TObject);
var
  x_:float;
  y_ :float;
  width_:float;
  area:float;
  upper_limit:float;
  lower_limit :float;
  i:integer;
  MaxRecordTime:integer;
  Txt:String;

begin
  Memo1.Clear;

  width_:=0.01;
  lower_limit:=0.5;
  upper_limit:=1.5;

  MaxRecordTime:=60*60*12;
  ListChartSource5.Clear;
  ChartForceManual.Extent.YMax:=0;

  //Rectangular
  Memo1.Append('---Rectangular---');
  area:=0;
  x_:= lower_limit;
  while x_ <= upper_limit do
  begin
    y_ := 0;
    For i := 0 to 2 do
    begin
      y_ :=  y_+((i+1)*math.Power(x_,i));
    end;

    area:=area+(y_*width_);
    Memo1.Append('x='+FloatToStr(x_)+' y='+FloatToStr(y_)+' area='+FloatToStr(area));

    Txt:=FormatFloat('0.00',x_);  //floatToStr(x_);
    if ChartForceManual.Extent.YMax < y_+2 then
    begin
      ChartForceManual.Extent.YMax := y_+2;
      ChartForceManual.ExtentSizeLimit.YMax:= y_+2; ;
    end;
    if ChartForceManual.Extent.YMin > y_-1 then
    begin
      ChartForceManual.Extent.YMin := y_-1;
      ChartForceManual.ExtentSizeLimit.YMin:= y_-1; ;
    end;
    if ListChartSource5.Count < MaxRecordTime then ListChartSource5.Add(ListChartSource5.Count,y_,Txt,clRed);
    if(ListChartSource5.Count<=60)then ChartForceManual.BottomAxis.Range.Max:=60;
    if(ListChartSource5.Count>60)then ChartForceManual.BottomAxis.Range.Max:=ListChartSource5.Count;
    ChartForceManual.BottomAxis.Range.Min:=0;
    ChartForceManual.Extent.XMin:=0;
    if(ListChartSource5.Count<=60)then ChartForceManual.Extent.XMax:=60;
    if(ListChartSource5.Count>60)then ChartForceManual.Extent.XMax:=ListChartSource5.Count;

    x_ := x_ + width_;
  end;

end;

procedure TForm1.Button6Click(Sender: TObject);
var
  x_:float;
  y_ :float;
  y1_ :float;
  width_:float;
  area:float;
  upper_limit:float;
  lower_limit :float;
  i:integer;

  MaxRecordTime:integer;
  Txt:String;

begin
  Memo1.Clear;

  width_:=0.01;
  lower_limit:=0.5;
  upper_limit:=1.5;

  MaxRecordTime:=60*60*12;
  ListChartSource5.Clear;
  ChartForceManual.Extent.YMax:=0;

  //Trapezoidal
  Memo1.Append('---Trapezoidal---');
  area:=0;
  x_:= lower_limit;
  while x_ <= upper_limit do
  begin
      y_ := 0;
      For i := 0 to 2 do
      begin
        y_ :=  y_+((i+1)*math.Power(x_,i));
      end;

      Txt:=FormatFloat('0.00',x_);  //floatToStr(x_);
      if ChartForceManual.Extent.YMax < y_+2 then
      begin
        ChartForceManual.Extent.YMax := y_+2;
        ChartForceManual.ExtentSizeLimit.YMax:= y_+2; ;
      end;
      if ChartForceManual.Extent.YMin > y_-1 then
      begin
        ChartForceManual.Extent.YMin := y_-1;
        ChartForceManual.ExtentSizeLimit.YMin:= y_-1; ;
      end;
      if ListChartSource5.Count < MaxRecordTime then ListChartSource5.Add(ListChartSource5.Count,y_,Txt,clRed);
      if(ListChartSource5.Count<=60)then ChartForceManual.BottomAxis.Range.Max:=60;
      if(ListChartSource5.Count>60)then ChartForceManual.BottomAxis.Range.Max:=ListChartSource5.Count;
      ChartForceManual.BottomAxis.Range.Min:=0;
      ChartForceManual.Extent.XMin:=0;
      if(ListChartSource5.Count<=60)then ChartForceManual.Extent.XMax:=60;
      if(ListChartSource5.Count>60)then ChartForceManual.Extent.XMax:=ListChartSource5.Count;


      x_ := x_ + width_;
      y1_ := 0;
      For i := 0 to 2 do
      begin
        y1_ :=  y1_+((i+1)*math.Power(x_,i));
      end;

      //a=yy[i]
      //b=yy[i+1]
      //h=p
      //trapezium[i]:=(1.0/2.0)*p*(yy[i]+yy[i+1]);
      //answer:=answer+trapezium[i];

      area:=area+(1.0/2.0)*width_*(y_+y1_);
      Memo1.Append('x='+FloatToStr(x_-width_)+' y='+FloatToStr(y_)+' y1='+FloatToStr(y1_)+' area='+FloatToStr(area));
  end;

  //Rectangular
  Memo1.Append('---Rectangular---');
  area:=0;
  x_:= lower_limit;
  while x_ <= upper_limit do
  begin
    y_ := 0;
    For i := 0 to 2 do
    begin
      y_ :=  y_+((i+1)*math.Power(x_,i));
    end;

    area:=area+(y_*width_);
    Memo1.Append('x='+FloatToStr(x_)+' y='+FloatToStr(y_)+' area='+FloatToStr(area));
    x_ := x_ + width_;
  end;

end;

procedure TForm1.ChartForceManualBeforeDrawBackground(ASender: TChart;
  ACanvas: TCanvas; const ARect: TRect; var ADoDefaultDrawing: Boolean);
begin
  ACanvas.GradientFill(ARect, $FFFFFF, $FF8080, gdVertical);
  ADoDefaultDrawing := false;
end;

procedure TForm1.ChartForceManualBeforeDrawBackWall(ASender: TChart;
  ACanvas: TCanvas; const ARect: TRect; var ADoDefaultDrawing: Boolean);
begin
  ACanvas.GradientFill(ARect, $FFFFFF, $80FF80, gdVertical);
  ADoDefaultDrawing := false;
end;

procedure TForm1.ChartForceManualMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin

end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin

end;

procedure TForm1.CheckBox1EditingDone(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    ctCrosshair.Shape:=ccsCross;  //ccsNone  //ccsCross
    ChartForceManualConstantLine1.Active:=false;
    ChartForceManualConstantLine2.Active:=false;
  end;

  if not CheckBox1.Checked then
  begin
    ctCrosshair.Shape:=ccsNone;  //ccsNone  //ccsCross
    ChartForceManualConstantLine1.Active:=true;
    ChartForceManualConstantLine2.Active:=true;
  end;
end;

procedure TForm1.ctCrosshairAfterMouseMove(ATool: TChartTool; APoint: TPoint);
begin

  if ChartForceManual.XImageToGraph(APoint.X) < 0 then exit;
  if ChartForceManual.XImageToGraph(APoint.X) > ChartForceManual.Extent.XMax then exit;

  if ChartForceManual.YImageToGraph(APoint.Y) < 0 then exit;
  if ChartForceManual.YImageToGraph(APoint.Y) > ChartForceManual.Extent.YMax then exit;

  ctCrosshair.Size:=round(ChartForceManual.Extent.XMax*ChartForceManual.Extent.YMax);
  if ChartForceManual.Extent.YMax > ChartForceManual.Extent.XMax then
  begin
    ctCrosshair.GrabRadius:=round(ChartForceManual.Extent.YMax);
  end
  else
  begin
    ctCrosshair.GrabRadius:=round(ChartForceManual.Extent.XMax);
  end;
  ChartForceManualConstantLine1.Position:=ChartForceManual.YImageToGraph(APoint.Y);
  ChartForceManualConstantLine2.Position:=ChartForceManual.XImageToGraph(APoint.X);

  ListChartSource6.SetXValue(0,ChartForceManual.XImageToGraph(APoint.X));
  ListChartSource6.SetXValue(1,ChartForceManual.XImageToGraph(APoint.X));
  ListChartSource6.SetYValue(0,ChartForceManual.Extent.YMin);
  ListChartSource6.SetYValue(1,ChartForceManual.Extent.YMax);

  ListChartSource7.SetYValue(0,ChartForceManual.YImageToGraph(APoint.Y));
  ListChartSource7.SetYValue(1,ChartForceManual.YImageToGraph(APoint.Y));
  ListChartSource7.SetXValue(0,ChartForceManual.Extent.XMin);
  ListChartSource7.SetXValue(1,ChartForceManual.Extent.XMax);

  ////ListChartSource6.Clear;
  ////ListChartSource6.Add(10.0,-100.0);
  ////ListChartSource6.Add(10.0,100.0);
  ////ListChartSource7.SetYValue(0,ChartForceManual.YImageToGraph(APoint.Y));
  ////ListChartSource7.SetYValue(1,ChartForceManual.YImageToGraph(APoint.Y));
  //if(ListChartSource5.Count<=60)then ChartForceManual.BottomAxis.Range.Max:=60;
  //  if(ListChartSource5.Count>60)then ChartForceManual.BottomAxis.Range.Max:=ListChartSource5.Count;
  //  ChartForceManual.BottomAxis.Range.Min:=0;
  //  ChartForceManual.Extent.XMin:=0;
  //  if(ListChartSource5.Count<=60)then ChartForceManual.Extent.XMax:=60;
  //  if(ListChartSource5.Count>60)then ChartForceManual.Extent.XMax:=ListChartSource5.Count;
end;

procedure TForm1.ctCrosshairDraw(ASender: TDataPointDrawTool);
var
  ser: TChartSeries;
begin
  ser := TChartSeries(ASender.Series);
  if ser <> nil then begin
    with ser.Source.Item[ASender.PointIndex]^ do
      Statusbar1.SimpleText := Format('Cursor at (%f; %f)', [X, Y]);
  end else
    Statusbar1.SimpleText := '';
end;

procedure TForm1.DragAfterMouseMove(ATool: TChartTool; APoint: TPoint);
begin

end;

procedure TForm1.DragBeforeKeyDown(ATool: TChartTool; APoint: TPoint);
const
  ZOOM_FACTOR = 2;
var
  ext: TDoubleRect;
  x, sz, ratio: Double;
begin
  if not (ssShift in ATool.Toolset.DispatchedShiftState) then exit;
  ext := ChartForceManual.LogicalExtent;
  if ext.b.x - ext.a.x >= 10 then begin
    x := ChartForceManual.XImageToGraph(APoint.X);
    sz := ext.b.x - ext.a.x;
    ratio := (x - ext.a.x) / sz;
    ext.a.x := x - sz * ratio / ZOOM_FACTOR;
    ext.b.x := x + sz * (1 - ratio) / ZOOM_FACTOR;
    ChartForceManual.LogicalExtent := ext;
  end;
  ATool.Handled;
end;

procedure TForm1.DragBeforeKeyUp(ATool: TChartTool; APoint: TPoint);
begin
  Unused(APoint);
  ChartForceManual.ZoomFull;
  ATool.Handled;
end;

procedure TForm1.DragBeforeMouseMove(ATool: TChartTool; APoint: TPoint);
begin

end;

procedure TForm1.DragMeasure(ASender: TDataPointDistanceTool);
const
  DIST_TEXT: array [TChartDistanceMode] of String = ('', 'x ', 'y ');
begin
  with ASender do
    Statusbar1.SimpleText := Format(
      'Measured %sdistance between (%f; %f) and (%f; %f): %f', [
      DIST_TEXT[MeasureMode],
      PointStart.GraphPos.X, PointStart.GraphPos.Y,
      PointEnd.GraphPos.X, PointEnd.GraphPos.Y,
      Distance(cuPixel)
    ]);
end;

procedure TForm1.Ctrl_DragMeasure(ASender: TDataPointDistanceTool);
const
  DIST_TEXT: array [TChartDistanceMode] of String = ('', 'x ', 'y ');
begin
  with ASender do
    Statusbar1.SimpleText := Format(
      'Measured %sdistance between (%f; %f) and (%f; %f): %f', [
      DIST_TEXT[MeasureMode],
      PointStart.GraphPos.X, PointStart.GraphPos.Y,
      PointEnd.GraphPos.X, PointEnd.GraphPos.Y,
      Distance(cuPixel)
    ]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  mDistanceTextChange(nil);

  //Drag.DistanceMode := TChartDistanceMode(1);
  //Ctrl_Drag.DistanceMode := TChartDistanceMode(1);
  //ctCrosshair.DistanceMode := TChartDistanceMode(1);

  if CheckBox1.Checked then
  begin
    ctCrosshair.Shape:=ccsCross;  //ccsNone  //ccsCross
    ChartForceManualConstantLine1.Active:=false;
    ChartForceManualConstantLine2.Active:=false;
  end;

  if not CheckBox1.Checked then
  begin
    ctCrosshair.Shape:=ccsNone;  //ccsNone  //ccsCross
    ChartForceManualConstantLine1.Active:=true;
    ChartForceManualConstantLine2.Active:=true;
  end;
end;

procedure TForm1.mDistanceTextChange(Sender: TObject);
var
  s: String;
begin
  s := mDistanceText.Lines.Text;
  try
    Format(s, [1.0, 1.0]);
    Drag.Marks.Format := s;
    Ctrl_Drag.Marks.Format := s;
  except
  end;
end;

procedure TForm1.mDistanceTextEditingDone(Sender: TObject);
begin

end;

//procedure TForm1.Chart1BarSeries1BeforeDrawBar(ASender: TBarSeries;
//  ACanvas: TCanvas; const ARect: TRect; APointIndex, AStackIndex: Integer;
//  var ADoDefaultDrawing: Boolean);
//begin
//  if APointIndex mod 2 = 0 then
//    ACanvas.Brush.Style := bsDiagCross;
//  ADoDefaultDrawing := APointIndex <> 4;
//end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  ChartForceManual.CopyToClipboardBitmap;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  ChartForceManual.SaveToBitmapFile('test.bmp');
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  SaveAs(ChartForceManual, vfWindowsMetafileWMF);
end;

//https://www.youtube.com/watch?v=Vsb4yho_hTk
//https://docs.scipy.org/doc/scipy/tutorial/integrate.html
//https://www.online-python.com/
//https://www.onlineide.pro/playground/python?utm_source=online-python&utm_medium=navbar&utm_campaign=onlineidepro
//https://www.geeksforgeeks.org/python/scipy-integration/

//https://pyscript.com/@examples
//https://pyscript.com/

//https://youtu.be/GKsCWivmlHg
//https://www.youtube.com/watch?v=MM3cBamj1Ms
{
import numpy as np

# Define y-values for a function (e.g., y = x^2)
y_values = np.array([0, 1, 4, 9, 16])

# Define corresponding x-values (evenly spaced in this case)
x_values = np.array([0, 1, 2, 3, 4])

# Calculate the integral using numpy.trapz with specified x-values
integral_with_x = np.trapz(y_values, x_values)
print(f"Integral with x-values: {integral_with_x}")

# Calculate the integral assuming evenly spaced x-values with dx=1
integral_dx_1 = np.trapz(y_values)
print(f"Integral with dx=1: {integral_dx_1}")
}
end.

