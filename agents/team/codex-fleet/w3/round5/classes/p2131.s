# n=5 model=out iset=I1 prefix14_class=2131
cmp P1, P2
cmovge S0, P2
cmovl S0, P1
mov S1, P0
cmovg P2, P1
cmp S1, P3
cmovg P0, P3
cmovg P3, S1
cmovle S1, P3
cmp S1, P2
cmovge P3, P2
mov S2, P0
cmovl S1, P2
mov S1, P3
