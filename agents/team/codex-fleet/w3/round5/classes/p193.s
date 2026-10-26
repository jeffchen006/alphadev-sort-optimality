# n=5 model=out iset=I1 prefix14_class=193
mov S0, P2
cmp P1, S0
cmovg S0, P1
cmovg P1, P2
mov S2, P0
cmovle P2, P1
cmp P3, S2
cmovl P0, P3
cmovle P3, S2
cmp P0, P2
cmovge P1, P0
mov S1, P3
cmovle P2, P0
cmp S1, S0
