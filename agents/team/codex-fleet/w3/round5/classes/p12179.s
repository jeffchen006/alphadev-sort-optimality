# n=5 model=out iset=I1 prefix14_class=12179
cmp P2, P1
mov S2, P2
cmovg P2, P1
mov S0, P0
cmovle S2, P1
cmp P3, P0
cmovle S0, P3
cmovge P0, P3
cmp S0, P2
cmovl P1, S0
cmovl S0, P2
cmovl P2, P1
cmp S2, P0
cmovl P2, P0
