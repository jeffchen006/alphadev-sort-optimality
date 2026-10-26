# n=5 model=out iset=I1 prefix14_class=3978
mov S1, P1
mov S0, P3
cmp S1, P2
cmovl S1, P2
cmovge P1, P2
cmp P0, S0
mov S2, P1
cmovl P3, P0
cmovg S0, P0
cmp P3, S2
cmovge S2, P3
cmovg P3, P1
cmp S0, S1
cmovle P1, S1
