# n=5 model=out iset=I1 prefix14_class=6863
mov S1, P1
mov S0, P2
cmp P3, P2
cmovl P2, P3
cmovl P3, S0
cmp S1, P0
mov S2, P3
cmovl P1, P0
cmovl P0, S1
cmp P1, P3
cmovle S2, P1
cmovge P3, P1
cmp P0, P2
cmovg P3, P2
