# n=5 model=out iset=I1 prefix14_class=4486
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
cmovl S2, P2
cmp P3, P0
mov S0, P3
cmovg S0, P0
cmovle P3, P0
cmp P3, S2
cmovg P0, P3
cmovg P3, S2
cmovg S2, P0
cmp S0, P1
mov S2, S0
