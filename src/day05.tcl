#!/usr/bin/env tclsh8.6

## variables
# * a dictionary to hold the rules
# * part1 and part2 will hold the totals
set rules [dict create]
set part1 0
set part2 0

# read in the rule and the data
set rule_lines {}
set data_lines {}
set in_rules 1
set input [read stdin]
set lines [split $input "\n"]
foreach line $lines {
  if {[string trim $line] eq ""} {
    set in_rules 0
    continue
  }
  if {$in_rules} {
    lappend rule_lines $line
  } else {
    lappend data_lines $line
  }
}

# read in the rules so we have a dictionary
# that has those that r1 depends on r2
# will indicate that with a 1
foreach line $rule_lines {
    if {$line ne ""} {
        lassign [split $line "|"] r1 r2
        dict set rules $r2 $r1 1
    }
}

# Our sort command.
# returns
# -1 a is less than b.
#     a must come before b.
#  0 a is equal to b.
#     a and b are equal
#  1 a is greater than b.
#     b must come before a.
proc compare {rules a b} {

    # pull in the flag to set to 0 if there is a
    # rules violation
    global flag 

    # first one is a rules violation
    if {[dict exists $rules $a $b]} { set flag 0; return -1 }
    if {[dict exists $rules $b $a]} { return 1  }

    # no rule, so sort numerically
    if {[expr {$a < $b}]} { return -1 }
    if {[expr {$a > $b}]} { return 1  }

    return 0
}

# Process each data line
foreach line $data_lines {
    if {$line eq ""} { continue }

    # get the elements
    set elements [split $line ","]

    # assume everything is okay
    set flag 1

    # sort them with our custom command
    # we have now sorted per the rules given
    # this should only affect things that were wrong.
    set sorted_elements [lsort -command [list compare $rules] $elements]

    # Fine the media, using sorted elements.
    set medianIndex [expr {[llength $sorted_elements] / 2}]
    set median [lindex $sorted_elements $medianIndex]

    # Accumulate results
    if {$flag} {
        incr part1 $median
    } else {
        incr part2 $median
    }
}

# Output results
puts "part1 total: $part1"
puts "part2 total: $part2"

