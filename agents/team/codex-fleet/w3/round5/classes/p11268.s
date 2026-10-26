# n=5 model=out iset=I1 prefix14_class=11268
mov S2, P1
cmp S2, P2
cmovl P1, P2
cmovg S2, P2
cmp P0, P3
cmovg S0, P3
cmovge P3, P0
cmovg P0, S0
cmp P1, P3
cmovg P2, P1
cmovle P2, P3
cmovg P1, P3
cmp P0, S2
cmovg P3, P0
