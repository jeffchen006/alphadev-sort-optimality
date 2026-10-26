# n=3 R=5 model=out iset=I1 source=w10_partial_sat
cmp P0, P1
mov S0, P0
cmovg P0, P1
cmovl S0, P1
mov S1, P2
cmp S0, S1
cmovl P2, S0
cmovl S0, S1
out 2, S0
cmp P0, P2
cmovg P2, P0
out 1, P2
cmovl S1, P0
out 0, S1
