# n=5 model=out iset=I1 prefix14_class=12724
mov S2, P2
cmp P2, P0
cmovge P2, P0
cmovl S2, P0
cmp P1, P3
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P3, P2
cmovg S0, P3
cmovle S0, P2
cmovge P3, P2
cmp S2, P1
cmovg P2, S2
