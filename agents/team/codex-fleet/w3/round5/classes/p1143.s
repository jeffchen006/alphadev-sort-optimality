# n=5 model=out iset=I1 prefix14_class=1143
cmp P2, P1
cmovl S2, P2
cmovle P2, P1
mov S0, P0
cmovl P1, S2
cmp P3, P0
cmovge S0, P3
cmovge P3, P0
cmp S0, P2
cmovle S2, P2
cmovl P2, S0
cmovg S2, S0
mov S0, P1
cmp P3, S0
