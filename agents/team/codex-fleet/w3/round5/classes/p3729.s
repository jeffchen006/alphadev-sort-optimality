# n=5 model=out iset=I1 prefix14_class=3729
mov S2, P1
cmp S2, P0
mov S0, P3
cmovle P1, P0
cmovl P0, S2
cmp P2, S0
cmovg S0, P2
cmovg P2, P3
cmp P2, P0
cmovl P3, P0
cmovle P0, P2
mov S1, S0
cmovge P3, P2
mov P0, P3
