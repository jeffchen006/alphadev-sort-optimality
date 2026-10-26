# n=5 model=out iset=I1 prefix14_class=8802
mov S2, P0
mov S0, P3
cmp S0, P1
cmovl S0, P1
cmovl P1, P3
cmp P2, S2
cmovl S2, P2
cmovg P0, P2
cmp P0, S0
cmovge P2, P0
cmovg P0, S0
cmovl P2, S0
cmp S2, P1
cmovle S0, S2
