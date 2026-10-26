# n=2 R=3 model=out iset=I1 source=w10_partial_sat
cmp P0, P1
mov S0, P1
cmovl S0, P0
out 0, S0
cmovge P1, P0
out 1, P1
