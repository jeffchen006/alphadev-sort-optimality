# n=5 model=out iset=I1 prefix14_class=3147
mov S0, P3
cmp P2, S0
cmovl P3, P2
cmovg S0, P2
mov S2, P0
cmp P1, S2
cmovg S2, P1
cmovle P0, P1
cmp P3, P0
cmovg P2, P3
cmovg P3, P0
cmovle P2, P0
cmp S0, S2
cmovge P1, S2
