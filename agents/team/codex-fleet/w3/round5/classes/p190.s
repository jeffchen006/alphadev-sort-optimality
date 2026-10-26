# n=5 model=out iset=I1 prefix14_class=190
cmp P0, P2
mov S2, P2
cmovg P2, P0
cmovg P0, S2
mov S0, P3
cmp P1, S0
cmovle S0, P1
cmovl P1, P3
mov S1, P0
cmp S0, P0
cmovge P0, S0
cmovl S1, S0
mov P3, P2
cmp P3, P1
