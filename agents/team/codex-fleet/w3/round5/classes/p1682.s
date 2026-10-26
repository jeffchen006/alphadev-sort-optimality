# n=5 model=out iset=I1 prefix14_class=1682
cmp P1, P3
mov S1, P3
cmovge P3, P1
mov S0, P2
cmovl S1, P1
cmp S0, P0
cmovg P2, P0
cmovg P0, S0
cmovge S0, P2
cmp S0, S1
cmovle S0, S1
cmovg P2, S1
cmp P3, P0
cmovge P1, P0
