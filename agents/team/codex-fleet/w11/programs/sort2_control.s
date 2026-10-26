# n=2 model=out iset=I1 source=w11_control
cmp P0, P1
mov S0, P0
cmovg P0, P1
cmovg P1, S0
out 0, P0
out 1, P1
