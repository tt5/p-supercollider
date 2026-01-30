Quarks.install("SafetyNet")
Safety.all;
Safety.setLimit(0.5);

s.quit
s.boot

// Turn down volume first!
{ [SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;

// s-enter
// c-.

(
//some
//somemore
)

// c-enter

~globalvar = \symbol

// s-c-d

// function
(
~fn = {
  arg arg1 = 1, arg2 = 1;
}
)

~fn.value(2);
~fn.(2, 2);
~fn.(arg2: 2, arg1: 2);

// ar audio rate (use this)
// kr control rate
// initialization rate
