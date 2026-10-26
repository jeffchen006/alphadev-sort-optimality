# n=5 model=out iset=I1 prefix14_class=11707
mov S0, P1
cmp S0, P2
cmovle S0, P2
cmovg P1, P2
cmovg P2, S0
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
cmp P3, S0
cmovge P2, P3
cmovl S0, P3
cmp P1, P0
cmovge P3, P1
