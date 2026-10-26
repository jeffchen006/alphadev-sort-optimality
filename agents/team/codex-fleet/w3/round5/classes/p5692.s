# n=5 model=out iset=I1 prefix14_class=5692
mov S1, P1
cmp S1, P0
mov S0, P2
cmovge P1, P0
cmovg P0, S1
cmp S0, P3
cmovge S0, P3
mov S1, P1
cmovg P3, P2
cmp S0, S1
cmovl S1, S0
cmovle S0, P1
cmp P0, P3
cmovg P1, P0
