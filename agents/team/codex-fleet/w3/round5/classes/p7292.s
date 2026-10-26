# n=5 model=out iset=I1 prefix14_class=7292
mov S2, P0
cmp P2, P0
cmovg S2, P2
cmovle P0, P2
cmp P3, P1
mov S0, P1
cmovle P1, P3
cmovl P3, S0
mov P2, P1
cmp P2, P0
cmovge P2, P0
cmovg P0, P1
cmp S2, P3
cmovge P1, S2
