# n=5 model=out iset=I1 prefix14_class=12969
mov S2, P1
cmp P2, S2
cmovg S2, P2
cmovl P1, P2
cmovge P2, P1
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P1, P0
cmovle P1, P0
cmovl P0, P2
cmp S2, P3
cmovl P0, S2
