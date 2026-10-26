# n=5 model=out iset=I1 prefix14_class=478
mov S0, P1
cmp P2, P0
cmovle S2, P0
cmovg S2, P2
cmovl P0, P2
cmp S0, P3
mov S1, S2
cmovg P1, P3
cmovge P3, S0
cmp P1, P0
mov S0, P0
cmovle P0, P1
cmovl P1, S0
mov P2, P1
