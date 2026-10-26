# n=3 R=5 model=out iset=I1 source=w10_partial_sat
cmp P0, P1
mov S0, P2
mov S1, P1
cmovg S1, P0
cmovl P1, P0
cmp S0, P1
cmovg S0, P1
out 0, S0
cmovg P1, P2
cmp P2, S1
cmovg P1, S1
out 1, P1
cmovge S1, P2
out 2, S1
