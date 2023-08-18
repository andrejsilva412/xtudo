unit uimage;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, buttons, ExtCtrls, Graphics,
  BGRABitmap, BGRASVG, BGRAUnits, utypes;


type

  { TImages }

  TImages = class
    private
      function SetColor(aSVG: String; aCor: TColor): String;
      procedure SVGToImage(aImage: TImage; SVG: String; W, H: Integer);
      procedure SVGToBitmap(aImage: TBitmap; aSVG: String; W, H: Integer);
    public
      procedure SVG(bmp: TBitmap; aSVG: String; W, H: Integer;
        Cor: TColor = clBlack; AResource: Boolean = true); overload;
      procedure SVG(Image: TImage; aSVG: String; W, H: Integer;
        Cor: TColor = clBlack); overload;
      procedure SVG(Image: TImage; aSVG: TSVGImages; W, H: Integer;
        Cor: TColor = clBlack); overload;
      procedure SVG(ASpeedButton: TSpeedButton; aSVG: String;
        Cor: TColor = clBlack; AResource: Boolean = true); overload;
  end;

var
  Test2SVGcontent: String = '<?xml version="1.0" encoding="utf-8"?><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"> <svg version="1.1" id="Ebene_1" xmlns:svg="http://www.w3.org/2000/svg" 	 xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="16.527px" 	 height="24.076px" viewBox="0 0 16.527 24.076" enable-background="new 0 0 16.527 24.076" xml:space="preserve"> <g id="breadboard"> 	<rect id="connector0pin" x="0.001" y="22.997" fill="none" width="2.16" height="0.999"/> 	<rect id="connector1pin" x="7.181" y="22.997" fill="none" width="2.159" height="0.999"/> 	<rect id="connector2pin" x="14.366" y="22.997" fill="none" width="2.16" height="0.999"/> 	 		<line id="connector0leg" fill="none" stroke="#8C8C8C" stroke-width="2.16" stroke-linecap="round" x1="1.081" y1="24.076" x2="1.081" y2="31.255"/> 	 		<line id="connector1leg" fill="none" stroke="#8C8C8C" stroke-width="2.16" stroke-linecap="round" x1="8.26" y1="24.076" x2="8.26" y2="31.255"/> 	 		<line id="connector2leg" fill="none" stroke="#8C8C8C" stroke-width="2.16" stroke-linecap="round" x1="15.446" y1="24.076" x2="15.446" y2="31.255"/> 	<rect id="rect9506" x="7.178" y="14.729" fill="#8C8C8C" width="2.153" height="9.349"/> 	<path id="path9510" fill="#8C8C8C" d="M3.288,14.729v3.315c0,0.425-0.782,1.06-1.198,1.425c-1.024,0.892-2.088,1.82-2.088,2.992 		v1.618h2.154c0,0,0-0.999,0-1.208c0-0.519,0.903-1.39,1.35-1.771c0.997-0.868,1.944-1.688,1.944-2.747v-3.625H3.288L3.288,14.729z" 		/> 	<path id="path9514" fill="#8C8C8C" d="M13.22,14.729v3.315c0,0.425,0.78,1.06,1.198,1.425c1.027,0.892,2.089,1.82,2.089,2.992 		v1.618h-2.153c0,0,0-0.999,0-1.208c0-0.519-0.904-1.39-1.35-1.771c-0.998-0.868-1.945-1.688-1.945-2.747v-3.625H13.22L13.22,14.729 		z"/> 	<rect id="rect9553" x="1.616" y="4.658" fill="#1A1A1A" width="13.276" height="10.068"/> 	<path id="path9555" fill="#141414" d="M13.888,4.658v2.452v8.228v1.843c0.632-0.713,1.004-1.554,1.004-2.453l0,0V4.658H13.888z"/> 	<path id="path9557" fill="#242424" d="M2.622,4.658H1.617v10.068l0,0c0,0.899,0.373,1.74,1.005,2.453v-1.842V7.111V4.658z"/> 	<path id="path9559" fill="#1F1F1F" d="M1.616,4.658L1.616,4.658c0,0.898,0.373,1.739,1.005,2.452h11.274 		C14.527,6.398,14.9,5.557,14.9,4.658l0,0H1.616z"/> 	<path id="path9561" fill="#141414" d="M8.255,0C4.588,0,1.616,2.085,1.616,4.66h13.276C14.892,2.085,11.923,0,8.255,0z"/> 	<rect id="rect9563" x="2.622" y="7.111" width="11.274" height="10.069"/> </g> <text transform="matrix(1 0 0 1 3.6531 12.8127)" fill="#FFFFFF" font-family="''Droid Sans''" font-size="3.4819">TRIAC</text> </svg>';

implementation

uses uhtmlutils, utils;

{ TImages }

function TImages.SetColor(aSVG: String; aCor: TColor): String;
var
  HTMLUtils: THTMLUtils;
  HTMLColor: String;
begin

  HTMLUtils := THTMLUtils.Create;
  try
    HTMLColor := HTMLUtils.ColorToHTML(aCor);
    Result := Format(aSVG, [HTMLColor]);
  finally
    FreeAndNil(HTMLUtils);
  end;

end;

procedure TImages.SVGToImage(aImage: TImage; SVG: String; W, H: Integer);
var
  bmp: TBGRABitmap;
  StreamSVG: TBGRASVG;
begin

  bmp := TBGRABitmap.Create;
  StreamSVG := TBGRASVG.Create(TStringStream.Create(svg));
  try
     bmp.SetSize(W, H);
     StreamSVG.StretchDraw(bmp.Canvas2D, taCenter, tlCenter,
       0, 0, W, H);
     aImage.Picture.Bitmap.Assign(bmp);
  finally
    StreamSVG.Free;
    bmp.Free;
  end;

end;

procedure TImages.SVGToBitmap(aImage: TBitmap; aSVG: String; W, H: Integer);
var
  img: TImage;
  bmp: TBitmap;
begin

  img := TImage.Create(nil);
  bmp := TBitmap.Create;
  try
    SVGToImage(img, aSVG, W, H);
    bmp.Assign(img.Picture.Bitmap);
    aImage.Assign(bmp);
  finally
    bmp.Free;
    img.Free;
  end;

end;

procedure TImages.SVG(bmp: TBitmap; aSVG: String; W, H: Integer; Cor: TColor;
  AResource: Boolean);
begin

  if AResource then
    aSVG := GetResourceToString(aSVG);

  aSVG := SetColor(aSVG, Cor);
  SVGToBitmap(bmp, aSVG, W, H);

end;

procedure TImages.SVG(Image: TImage; aSVG: String; W, H: Integer; Cor: TColor);
begin
  SVG(Image.Picture.Bitmap, aSVG, W, H, cor);
end;

procedure TImages.SVG(Image: TImage; aSVG: TSVGImages; W, H: Integer;
  Cor: TColor);
begin
  SVG(Image, SVGImagesToString(aSVG), W, H, Cor);
end;

procedure TImages.SVG(ASpeedButton: TSpeedButton; aSVG: String; Cor: TColor;
  AResource: Boolean);
begin
  SVG(ASpeedButton.Glyph, aSVG,
    ASpeedButton.Width, ASpeedButton.Height, Cor, AResource);
end;

end.

