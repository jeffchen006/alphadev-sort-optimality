# n=5 model=out iset=I1 prefix14_class=4514
cmp P1, P0
mov S0, P1
mov S1, P3
cmovge P1, P0
cmovl S0, P0
cmp S1, P2
cmovge P3, P2
cmovg P2, S1
cmovle S1, P2
cmp P2, S0
cmovg P2, S0
cmovg S0, S1
cmp P1, P3
cmovl S1, P1
