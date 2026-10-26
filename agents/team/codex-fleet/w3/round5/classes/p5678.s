# n=5 model=out iset=I1 prefix14_class=5678
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovge P1, P2
mov S2, P0
cmp S2, P3
cmovge P0, P3
cmovg P3, S2
cmp P0, S0
cmovl P2, S0
cmovl S0, P0
mov S0, P1
cmovl P0, P2
cmp P3, S0
