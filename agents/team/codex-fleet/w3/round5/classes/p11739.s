# n=5 model=out iset=I1 prefix14_class=11739
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovl P2, P1
cmp P3, P0
cmovge P1, P3
cmovg P3, P0
mov S1, S0
cmovge P0, P1
cmp S0, P0
cmovl S1, P0
cmovle P0, S0
cmp P2, P3
cmovle S2, P2
