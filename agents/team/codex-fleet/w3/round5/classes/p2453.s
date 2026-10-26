# n=5 model=out iset=I1 prefix14_class=2453
mov S2, P0
mov S1, P3
cmp P0, P2
cmovg S2, P2
cmovle P0, P2
cmp P1, P3
cmovge P3, P1
cmovg P1, S1
cmp P3, P0
mov S1, P3
cmovl P3, P0
cmovle P0, S1
cmp S2, P1
cmovl P3, P1
