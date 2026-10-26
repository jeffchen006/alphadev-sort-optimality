# n=5 model=out iset=I1 prefix14_class=3775
mov S1, P1
cmp P2, P1
cmovle S1, P2
cmovge P1, P2
mov S2, P3
cmp P0, P3
cmovge P3, P0
cmovg P0, S2
cmp S1, P0
mov S0, S1
cmovl S1, P0
cmovl P0, S0
cmp P1, P3
cmovge P0, P1
