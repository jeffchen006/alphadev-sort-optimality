# n=5 model=out iset=I1 prefix14_class=13368
cmp P2, P3
mov S0, P1
mov S1, P2
cmovl P2, P3
cmovl P3, S1
cmp P0, P1
cmovge P1, P0
cmovl S0, P0
cmp S0, P3
mov S2, P3
cmovle S2, S0
cmovg P3, S0
cmp P2, P1
cmovle S2, P2
