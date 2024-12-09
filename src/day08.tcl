#!/usr/bin/env tclsh8.6

set antenna   [dict create]
set antipart1 [dict create]
set antipart2 [dict create]
set rows 0
set cols 0

proc in_bounds { row col } {
  global rows cols
  if {$row < 0 || $row > $rows - 1 || $col < 0 || $col > $cols - 1} {
    return 0
  }
  return 1
}

# main
foreach line [split [read stdin]] {
  set col 0 
  if {[string length $line] == 0} { break }
  foreach c [split $line ""] {
    if { $c ne "." } {
      dict lappend antenna $c [list $rows $col]  
    }
    incr col
  }
  # end of a line
  if { $cols != 0 && $col != $cols } { 
    puts "row: $rows, columns were $col should be $cols"
    puts "bad input, column sizes don't match"
    exit 1
  }
  set cols $col
  incr rows
}

dict for {label locations} $antenna {
  # must have two antenna
  if {[llength $locations] < 2} { continue }
  for {set a 0} {$a<[llength $locations]-1} {incr a} {
    for {set b [expr {$a + 1}]} {$b<[llength $locations]} {incr b} {
      foreach {arow acol} [lindex $locations $a] {}
      foreach {brow bcol} [lindex $locations $b] {}
      set delta_row [expr { $arow - $brow}]
      set delta_col [expr { $acol - $bcol}]
      set count 0
      set i 0
      set row $arow
      for {set i 0; set row $arow} {$row>=0} {incr i; incr row -1} {
        set delta_arow [expr {$arow + ($delta_row * $i)}]
        set delta_acol [expr {$acol + ($delta_col * $i)}]
        if {[in_bounds $delta_arow $delta_acol]} {
          dict set antipart2 [list $delta_arow $delta_acol] 1
          if {$i==1} {
            dict set antipart1 [list $delta_arow $delta_acol] 1
          } 
        } else {
          break
        }
      }
      for {set i 0; set row $arow} {$row<$rows} {incr i; incr row} {
        set delta_brow [expr {$brow - ($delta_row * $i)}]
        set delta_bcol [expr {$bcol - ($delta_col * $i)}]
        if {[in_bounds $delta_brow $delta_bcol]} {
          dict set antipart2 [list $delta_brow $delta_bcol] 1
          if {$i==1} {
            dict set antipart1 [list $delta_brow $delta_bcol] 1
          } 
        } else { 
          break
        }
      }
    }
  }
}
puts "part1 total: [dict size $antipart1]"
puts "part2 total: [dict size $antipart2]"
