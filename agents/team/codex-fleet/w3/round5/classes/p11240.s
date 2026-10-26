# n=5 model=out iset=I1 prefix14_class=11240
cmp P2, P3
cmovg S1, P2
cmovg P2, P3
mov S0, P1
cmovg P3, S1
cmp P0, P1
cmovle P1, P0
mov S2, P3
cmovl P0, S0
cmp P0, P3
cmovg S2, P0
cmovge P0, P3
mov S2, P1
cmp S2, P2
