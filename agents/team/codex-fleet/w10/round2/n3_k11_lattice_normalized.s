# n=3 R=5 model=out iset=I1 source=w10_partial_sat
cmp P0, P1
mov S0, P0
cmovl P0, P1
mov S1, P2
cmovle P1, S0
cmp P2, P1
cmovge S1, P1
out 0, S1
cmovge P1, P2
cmp P0, P2
cmovg P2, P0
out 2, P2
cmovge P0, P1
out 1, P0
