# n=5 model=out iset=I1 prefix14_class=14134
cmp P2, P1
cmovl S0, P2
cmovle P2, P1
cmovl P1, S0
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
mov S2, P2
mov S1, P1
cmovg P3, S0
cmp S2, P0
cmovle P2, P0
cmovle P0, S2
cmp S1, P3
