# n=5 model=out iset=I1 prefix14_class=673
mov S0, P2
cmp P3, S0
cmovl P2, P3
cmovl P3, S0
mov S2, P0
mov S0, P3
cmp S2, P1
cmovge P0, P1
cmovl S2, P1
cmp S0, S2
cmovle P3, S2
cmovl S2, S0
cmp P2, P0
cmovle S0, P2
