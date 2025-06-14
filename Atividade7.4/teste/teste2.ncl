;****************************************************
; xy_overlay_25.ncl
;
; Concepts illustrated:
;   - Drawing an XY plot with two different Y axes
;   - Adding curves to an existing XY plot that contains two different Y axes
;   - Removing trailing zeros from tickmark labels
;   - Maximizing plots after they've been created
;
;****************************************************
; This script is similar to xy_25.ncl, except it
; uses the "overlay" procedure to add the third
; curve to the existing plot.
;****************************************************
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
;****************************************************
begin
;---Read in data
  f    = addfile ("TestData.xy3.nc" , "r")
  t0   = f->T(0,0:35)                 ; read in left variable
  p0   = f->P(0,0:35)                 ; read in right variable
  p1   = f->P(1,0:35)

  pmin = min((/p0,p1/))             ; Get min/max so we can set limits
  pmax = max((/p0,p1/))             ; of axes in advance.
  tmin = min(t0)
  tmax = max(t0)

  time = f->time(0:35)

;---Start the graphics
  wks = gsn_open_wks("png","xy_overlay")    ; send graphics to PNG file

;---Set common resources for all plots
  res                  = True
  res@gsnMaximize      = True
  res@vpWidthF         = 0.8            ; Change the aspect ratio, but 
  res@vpHeightF        = 0.4            ; make plot as large as possible.

; Uncomment these if you don't want to draw the first two plots
;  res@gsnDraw          = False
;  res@gsnFrame         = False

;---Set resources for "left" variable
  resL                  = res

  resL@trYMinF          = tmin           ; Set min/max of left Y axis
  resL@trYMaxF          = tmax

  resL@xyLineColor      = "Brown"
  resL@xyLineThicknessF = 4.0

  resL@tiMainString     = "Two-curve plot"

  resL@tiYAxisFontColor = resL@xyLineColor

;---Set resources for "right" variable
  resR                  = res

  resR@trYMinF          = pmin           ; Set min/max of right Y axis
  resR@trYMaxF          = pmax

  resR@xyLineColor      = "NavyBlue"
  resR@xyDashPattern    = 2              ; Dashed line for 2nd curve
  resR@xyLineThicknessF = 4.0

  resR@tiYAxisFontColor = resR@xyLineColor

  resR@tmYRFormat       = "f"            ; Remove trailing zeros from labels

  plot = gsn_csm_xy2(wks,time,t0,p0,resL,resR)

;---Add the third line to the plots by using overlay
  res@xyLineColor       = resR@xyLineColor
  res@xyDashPattern     = 7                    ; different dash line but same color
  res@xyLineThicknessF  = resR@xyLineThicknessF
  res@tiMainString      = "Single-curve plot"

  overlay_plot = gsn_csm_xy(wks,time,p1,res)

  overlay(plot@xy2,overlay_plot)

;---Update the titles before we draw the plot
  setvalues plot
    "tiMainString" : "Three-curve plot"
  end setvalues

;---Have to turn off title for "right" axis plot (not sure why)
  setvalues plot@xy2
    "tiMainString" : ""
  end setvalues

  draw(plot)    ; This will draw all three curves
  frame(wks)
  
end