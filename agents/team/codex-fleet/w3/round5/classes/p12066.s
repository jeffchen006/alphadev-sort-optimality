# n=5 model=out iset=I1 prefix14_class=12066
cmp P0, P2
cmovle S0, P2
cmovl P2, P0
cmovg S0, P0
cmp P1, P3
cmovge P0, P3
cmovg P3, P1
cmovge P1, P0
mov S2, P1
mov S1, S0
cmp P2, S2
cmovg P1, P2
cmovl S2, P2
cmp S0, P3
