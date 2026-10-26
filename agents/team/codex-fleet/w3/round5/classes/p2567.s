# n=5 model=out iset=I1 prefix14_class=2567
cmp P1, P0
mov S0, P0
cmovle S0, P1
cmovge P0, P1
mov S1, P2
cmp P3, S1
cmovge P2, P3
cmovge P3, S1
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovl S1, P2
cmp S0, P3
cmovg P1, S0
