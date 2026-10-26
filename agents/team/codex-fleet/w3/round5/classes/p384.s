# n=5 model=out iset=I1 prefix14_class=384
cmp P2, P1
cmovl S0, P2
cmovl P2, P1
mov S2, P3
cmovl P1, S0
cmp S2, P0
mov S1, P1
cmovge P3, P0
cmovg P0, S2
cmovle S2, P0
cmp P1, P3
cmovle S1, P3
cmovg P1, P3
cmp P2, S2
