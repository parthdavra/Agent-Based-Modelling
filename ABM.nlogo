breed [humans human]

globals [
  student_id
  student_name
  student_score
  student_feedback
  most_effective_measure
  least_effective_measure
  population_most_affected
  population_most_immune
  self_isolation_link
  population_density
  total_infected_percentage
  green_infected_percentage
  blue_infected_percentage
  total_deaths
  green_deaths
  blue_deaths
  total_antibodies_percentage
  green_antibodies_percentage
  blue_antibodies_percentage
  human_speed
  rad

]

humans-own[
  infected_time
  antibodies
  immunity
  check_infected
  infected?
  human_death

]
patches-own [ solid ]

to setup_world
  clear-patches
  reset-ticks
  clear-all
  set student_id 20063130
  set student_name "Parth Babubhai Davra"
  set human_speed 0.2
  set green_population 5000
  set blue_population 2500
  set initially_infected 10
  set infection_rate 5
  set survival_rate 80
  set immunity_duration 500
  set undetected_period 200
  set illness_duration 300
  set travel_restrictions false
  set social_distancing false
  set self_isolation false
  set rad 1
  set total_deaths 0
  set green_deaths 0
  set blue_deaths 0
  ask patches [
    ifelse ( pxcor >= min-pxcor and pycor <= max-pycor and pycor > min-pycor and pxcor <= 0 )
    [ set pcolor blue ]
    [ set pcolor green ]
  ]
  draw_wall
end

to setup_agents

  create-humans green_population [
    set shape "green person"
    set color yellow
    set size 1
    set antibodies 0
    set infected? false
    setxy random max-pycor -1 * random-ycor
    set infected_time 0
    set immunity 0
    set check_infected 0
    set human_death 0
  ]
  ask n-of initially_infected humans with [shape = "green person" ]
  [
    set color red
    set infected? true
    set antibodies 0
    set immunity 0
    set check_infected 1
    set human_death 0
    set infected_time illness_duration
  ]

  create-humans blue_population [
    set shape "blue person"
    set color yellow
    set size 1
    set infected? false
    set antibodies 0
    setxy random min-pycor -1  * random-ycor
    set infected_time 0
    set immunity 0
    set check_infected 0
    set human_death 0
  ]

  ask n-of initially_infected humans with [shape = "blue person" ]
  [
    set color red
    set infected? true
    set antibodies 0
    set immunity 0
    set check_infected 1
    set infected_time illness_duration
    set human_death 0
  ]

end

to run_model

  make_humans_move
  spread_infection

  ask humans [
    if(color != red)
    [

    ]

    if (infected? = true and check_infected = 1 )
    [
      if( infected? = true )
      [
        set infected_time infected_time - 1

      ]

      if (infected_time = 0 and infected? = true and check_infected = 1 )
      [
        set infected? false
        set color black
        set antibodies 1
        set immunity immunity_duration
        set check_infected 0
        set human_death 0
      ]
      if (immunity > 0)
      [
        set immunity immunity - 1

      ]

    ]
    if(color = black)
    [
      ifelse (immunity = 0)
          [
            set infected? false
            set color yellow
            set antibodies 0
            set infected_time 0
            set immunity 0
            set check_infected 0
            set human_death 0
      ]
      [
        set immunity immunity - 1
      ]

    ]

    if(color = red)
    [
      if( self_isolation = true )
      [
        if( color = red and (illness_duration - undetected_period) >= infected_time)
        [
          set color orange

        ]

      ]
    ]

    if (color = orange)
    [
      if( self_isolation = false )
      [
        set color red
      ]
    ]

  ]
  humans_death
  tick
end

to humans_death
  let num_of_active_case count humans with [ color = red or color = orange]
  if num_of_active_case > 0
  [
    ask one-of humans with [color = red or color = orange]
        [
         ifelse   survival_rate < random-float 100
        [
        set total_deaths  total_deaths + 1
        if(shape = "blue person")
        [
          set blue_deaths blue_deaths + 1
        ]
        if(shape = "green person")
        [
          set green_deaths green_deaths + 1
        ]
        die
        ]
          [
            set human_death 1

          ]

      ]
  ]
end



to make_humans_move
  ask humans [
    right 20 left 20
    if social_distancing = true
    [

      if any? other humans in-radius 1 [
        right random 90
      ]

    ]

    if travel_restrictions = true
    [

      detect_wall
    ]

    if color != orange
    [
      forward human_speed
    ]

  ]
end
to spread_infection
  ask humans [
    if ( infected? = true and antibodies = 0 )[
      ask other humans in-radius 1
    [
        if ( infected? = false and antibodies = 0 )
        [
      if random-float 100 <= infection_rate
      [

          set infected? true
        set color red
        set antibodies 0
        set immunity 0
        set check_infected 1

        set infected_time illness_duration
        set human_death 0


        ]
        ]
      ]
    ]
  ]
end


to draw_wall
  ask patches [
    set solid false

  ]
  ask patches with [ pxcor = 0]  [
    set solid true


  ]
end

to detect_wall
  if [solid] of patch-ahead 1 = true [
    right random 90
    make_travel_restrictions
  ]

end
to make_travel_restrictions
    if (shape = "blue person" and pcolor = green)[
      facexy 0 pycor
    ]
    if (shape = "green person" and pcolor = blue)[
      facexy -150 pycor
    ]
end

to my_analysis
  set most_effective_measure 1
  set least_effective_measure 3
  set population_most_affected 1
  set population_most_immune 1
  set self_isolation_link 7
  set population_density 5
end












@#$#@#$#@
GRAPHICS-WINDOW
213
10
823
621
-1
-1
2.0
1
10
1
1
1
0
1
1
1
-150
150
-150
150
1
1
1
ticks
30.0

BUTTON
0
22
101
55
setup_world
setup_world
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
105
22
201
55
setup_agent
setup_agents
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
0
63
198
96
run_model
run_model
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
1
104
198
137
green_population
green_population
1
10000
5000.0
1
1
NIL
HORIZONTAL

SLIDER
1
145
202
178
blue_population
blue_population
1
10000
2500.0
1
1
NIL
HORIZONTAL

SLIDER
3
185
202
218
initially_infected
initially_infected
10
2000
10.0
1
1
NIL
HORIZONTAL

SLIDER
4
223
203
256
infection_rate
infection_rate
0
100
5.0
1
1
NIL
HORIZONTAL

SLIDER
4
261
202
294
survival_rate
survival_rate
0
100
80.0
1
1
NIL
HORIZONTAL

SLIDER
3
301
203
334
immunity_duration
immunity_duration
0
1000
500.0
1
1
NIL
HORIZONTAL

SLIDER
3
340
200
373
undetected_period
undetected_period
0
300
200.0
1
1
NIL
HORIZONTAL

SLIDER
3
380
198
413
illness_duration
illness_duration
0
300
300.0
1
1
NIL
HORIZONTAL

SWITCH
4
420
200
453
travel_restrictions
travel_restrictions
1
1
-1000

SWITCH
5
458
200
491
self_isolation
self_isolation
1
1
-1000

SWITCH
4
497
200
530
social_distancing
social_distancing
1
1
-1000

MONITOR
830
30
1017
75
total_infected_percentage
((count humans with [color = red]) * (100)) / count humans
17
1
11

MONITOR
829
81
1018
126
total_deaths
total_deaths
17
1
11

MONITOR
830
132
1018
177
total_antibodies_percentage
((count humans with [color = black]) * (100)) / count humans
17
1
11

MONITOR
828
184
1017
229
count humans
count humans
17
1
11

MONITOR
1024
32
1220
77
green_antibodies_percentage
((count humans with [shape = \"green person\" and color = black]) * (100)) / count humans with [shape = \"green person\"]
17
1
11

MONITOR
1024
80
1219
125
green_deaths
green_deaths
17
1
11

MONITOR
1025
132
1219
177
green_infected_percentage
((count humans with [shape = \"green person\" and color = red]) * (100)) / count humans with [shape = \"green person\"]
17
1
11

MONITOR
1024
185
1217
230
current green population
count humans with [shape = \"green person\"]
17
1
11

MONITOR
1228
34
1415
79
blue_antibodies_percentage
((count humans with [shape = \"blue person\" and color = black]) * (100)) / count humans with [shape = \"blue person\"]
17
1
11

MONITOR
1228
84
1414
129
blue_deaths
blue_deaths
17
1
11

MONITOR
1228
132
1414
177
blue_infected_percentage
((count humans with [shape = \"blue person\" and color = red]) * (100)) / count humans with [shape = \"blue person\"]
17
1
11

MONITOR
1227
185
1414
230
current blue population
count humans with [shape = \"blue person\"]
17
1
11

MONITOR
1423
33
1505
78
Active case
count humans with [ color = red]
17
1
11

PLOT
848
428
1183
618
population
Hours
Number of People
0.0
347.0
0.0
347.0
true
false
"" ""
PENS
"Infected" 1.0 0 -5298144 true "" "plot count humans with [infected? = true]"
"Immune" 1.0 0 -16777216 true "" "plot count humans with [antibodies = 1]"

PLOT
848
241
1179
421
populations
NIL
NIL
0.0
1000.0
0.0
1000.0
true
false
"" ""
PENS
"green_population" 1.0 0 -10899396 true "" "plot count humans with [shape = \"green person\"]"
"blue_population" 1.0 0 -13345367 true "" "plot count humans with [shape = \"blue person\"]"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

blue person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Circle -13345367 true false 120 30 30
Circle -13345367 true false 150 30 30

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

green person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Circle -13840069 true false 120 30 30
Circle -13840069 true false 150 30 30

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
